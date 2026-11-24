# T-206 : cage à squat (salle_cage), presse à mollets (salle_presse), tapis de course (salle_tapis), construits par script dans Blender (sans fenêtre).
# 1 unité = 1 stud, Z vers le haut, avant vers -Y, un mesh par couleur nommé identifiant_Couleur.
import bpy, bmesh, math, os, sys
from mathutils import Vector, Matrix

RACINE = r"C:\Users\prudh\Desktop\projet roblox\saut en longueur\assets\modeles"
SOURCE = os.path.join(RACINE, "source")
EXPORT = os.path.join(RACINE, "export")
APERCU = os.path.join(RACINE, "planches")
JOURNAL = sys.argv[sys.argv.index("--") + 1]
lignes = []

def hexa(h):
    h = h.lstrip("#")
    c = [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]
    return [x ** 2.2 for x in c] + [1]

COULEURS = {
    "Or": "#FFC83D", "Blanc": "#FFFFFF", "Bleu": "#1E90FF", "Nuit": "#16213E",
    "Gris": "#5B6577", "Orange": "#FF7A1A", "Violet": "#9B5CFF",
}

def vider():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def matiere(nom):
    m = bpy.data.materials.get(nom)
    if not m:
        m = bpy.data.materials.new(nom)
        m.diffuse_color = hexa(COULEURS[nom])
    return m

def objet_bm(nom, bm):
    me = bpy.data.meshes.new(nom)
    bm.to_mesh(me)
    bm.free()
    ob = bpy.data.objects.new(nom, me)
    bpy.context.scene.collection.objects.link(ob)
    return ob

def boite(sx, sy, sz, centre=(0, 0, 0), biseau=0.0, segments=2):
    bm = bmesh.new()
    bmesh.ops.create_cube(bm, size=1.0)
    bmesh.ops.scale(bm, vec=(sx, sy, sz), verts=bm.verts)
    if biseau > 0:
        bmesh.ops.bevel(bm, geom=bm.edges[:] + bm.verts[:], offset=biseau, segments=segments, affect="EDGES", profile=0.5)
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def cylindre(r1, r2, h, centre=(0, 0, 0), seg=16, rot=None):
    bm = bmesh.new()
    bmesh.ops.create_cone(bm, cap_ends=True, cap_tris=False, segments=seg, radius1=r1, radius2=r2, depth=h)
    if rot:
        bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=rot)
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def tore(R, r, seg=32, segmin=8, ecrase=1.0, centre=(0, 0, 0)):
    # Tore dans le plan XZ (face vers -Y), section écrasée en Y par « ecrase »
    bm = bmesh.new()
    anneaux = []
    for i in range(seg):
        a = 2 * math.pi * i / seg
        ligne = []
        for j in range(segmin):
            b = 2 * math.pi * j / segmin
            rr = R + r * math.cos(b)
            ligne.append(bm.verts.new((rr * math.cos(a) + centre[0], r * math.sin(b) * ecrase + centre[1], rr * math.sin(a) + centre[2])))
        anneaux.append(ligne)
    for i in range(seg):
        for j in range(segmin):
            a, b = anneaux[i], anneaux[(i + 1) % seg]
            bm.faces.new((a[j], b[j], b[(j + 1) % segmin], a[(j + 1) % segmin]))
    return bm

def sphere(r, centre, sub=1):
    bm = bmesh.new()
    bmesh.ops.create_icosphere(bm, subdivisions=sub, radius=r)
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def fusion(nom, couleur, morceaux):
    bm = bmesh.new()
    for m in morceaux:
        me = bpy.data.meshes.new("tmp")
        m.to_mesh(me)
        m.free()
        bm.from_mesh(me)
        bpy.data.meshes.remove(me)
    ob = objet_bm(nom, bm)
    ob.data.materials.append(matiere(couleur))
    return ob

def finir(ident, origine=(0, 0, 0)):
    # Nettoyage (doublons, triangulation), export FBX, .blend, aperçu
    tris = 0
    for ob in bpy.context.scene.objects:
        if ob.type != "MESH":
            continue
        bm = bmesh.new()
        bm.from_mesh(ob.data)
        bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=0.0005)
        bmesh.ops.dissolve_degenerate(bm, edges=bm.edges, dist=0.0005)
        bmesh.ops.triangulate(bm, faces=bm.faces)
        bm.normal_update()
        bm.to_mesh(ob.data)
        tris += len(bm.faces)
        bm.free()
        lisse = ob.get("lisse", False)
        if lisse:
            ob.data.shade_smooth()
        else:
            ob.data.shade_flat()
    mins = Vector((1e9,) * 3); maxs = Vector((-1e9,) * 3)
    for ob in bpy.context.scene.objects:
        if ob.type == "MESH":
            for v in ob.data.vertices:
                w = ob.matrix_world @ v.co
                mins = Vector(map(min, mins, w)); maxs = Vector(map(max, maxs, w))
    taille = maxs - mins
    bpy.ops.wm.save_as_mainfile(filepath=os.path.join(SOURCE, ident + ".blend"))
    bpy.ops.export_scene.fbx(filepath=os.path.join(EXPORT, ident + ".fbx"), use_selection=False,
                             apply_scale_options="FBX_SCALE_UNITS", object_types={"MESH"}, mesh_smooth_type="FACE")
    apercu(ident, mins, maxs)
    lignes.append(f"{ident}: {tris} triangles, taille {taille.x:.2f} x {taille.y:.2f} x {taille.z:.2f} (X largeur, Y profondeur, Z hauteur), objets {[o.name for o in bpy.context.scene.objects if o.type == 'MESH']}")

def apercu(ident, mins, maxs):
    sc = bpy.context.scene
    sc.render.engine = "BLENDER_WORKBENCH"
    sc.display.shading.light = "STUDIO"
    sc.display.shading.color_type = "MATERIAL"
    sc.display.shading.show_cavity = True
    sc.render.film_transparent = False
    sc.world = bpy.data.worlds.new("Monde") if not sc.world else sc.world
    sc.world.color = (1, 1, 1)
    sc.render.resolution_x, sc.render.resolution_y = 900, 600
    sc.render.image_settings.file_format = "PNG"
    centre = (mins + maxs) / 2
    rayon = (maxs - mins).length
    cam_data = bpy.data.cameras.new("Cam")
    cam_data.type = "ORTHO"
    t = maxs - mins
    cam_data.ortho_scale = max(t.x, t.y, t.z * 1.5) * 1.35
    cam = bpy.data.objects.new("Cam", cam_data)
    sc.collection.objects.link(cam)
    sc.camera = cam
    for nom, d in (("face", Vector((0, -1, 0))), ("34", Vector((0.8, -1, 0.55))), ("dos", Vector((-0.8, 1, 0.55)))):
        pos = centre + d.normalized() * rayon * 3
        cam.location = pos
        cam.rotation_euler = (centre - pos).to_track_quat("-Z", "Y").to_euler()
        sc.render.filepath = os.path.join(APERCU, f"{ident}_apercu{'' if nom == '34' else '_' + nom}.png")
        bpy.ops.render.render(write_still=True)
    bpy.data.objects.remove(cam)

def prisme(points, ep, y=0.0):
    # Polygone (x, z) extrudé en Y sur l'épaisseur ep, centré en y
    bm = bmesh.new()
    av = [bm.verts.new((x, y - ep / 2, z)) for x, z in points]
    ar = [bm.verts.new((x, y + ep / 2, z)) for x, z in points]
    bm.faces.new(av)
    bm.faces.new(list(reversed(ar)))
    n = len(points)
    for i in range(n):
        j = (i + 1) % n
        bm.faces.new((av[i], av[j], ar[j], ar[i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return bm

def arche(largeur, hauteur, base, ep, y=0.0, seg=16):
    pts = []
    for i in range(seg + 1):
        a = math.pi * i / seg
        pts.append((largeur / 2 * math.cos(a), base + hauteur * math.sin(a)))
    return prisme(pts, ep, y)

def etoile(r, ep, centre, y):
    pts = []
    for i in range(10):
        a = math.pi / 2 + math.pi * i / 5
        rr = r if i % 2 == 0 else r * 0.45
        pts.append((centre[0] + rr * math.cos(a), centre[1] + rr * math.sin(a)))
    return prisme(pts, ep, y)

COULEURS.update({
    "Noir": "#1F2229", "Anthracite": "#2B2F38", "Sol": "#3A3F48", "Metal": "#B9C2CC",
    "Cyan": "#3BE0FF", "CadreRouge": "#E5484D", "CadreBleu": "#1E90FF", "CadreGris": "#C7CFD8",
})

def rotx(bm, deg, cent=(0, 0, 0)):
    bmesh.ops.rotate(bm, verts=bm.verts, cent=Vector(cent), matrix=Matrix.Rotation(math.radians(deg), 3, "X"))
    return bm

AXE_X = Matrix.Rotation(math.pi / 2, 3, "Y")   # cylindre couché selon X
AXE_Y = Matrix.Rotation(math.pi / 2, 3, "X")   # cylindre couché selon Y

# ---------------------------------------------------------------- Cage à squat (salle_cage)
# Origine au sol, au centre ; l'avant (côté joueur) vers -Y. Le cadre (« _Cadre ») se recolore dans Studio selon le palier.
# La barre et ses disques (« _Barre_* ») sont séparés : DecorAnime les fait monter et descendre.
vider()
ID = "salle_cage"
cadre, orr = [], []
PX, PY, H = 2.8, 1.6, 9.0
for sx in (-1, 1):
    for sy in (-1, 1):
        cadre.append(boite(0.6, 0.6, H - 0.2, centre=(sx * PX, sy * PY, 0.2 + (H - 0.2) / 2), biseau=0.12, segments=1))
    cadre.append(boite(0.7, 2 * PY + 1.0, 0.45, centre=(sx * PX, 0, 0.42), biseau=0.12, segments=1))   # rail au sol
    cadre.append(boite(0.6, 2 * PY + 0.6, 0.5, centre=(sx * PX, 0, H - 0.25), biseau=0.12, segments=1))  # longeron du haut
    # crochets (J) et bras de sécurité dorés, sur les montants avant
    orr.append(boite(0.45, 0.8, 0.25, centre=(sx * PX, -PY - 0.6, 5.25), biseau=0.06, segments=1))
    orr.append(boite(0.45, 0.2, 0.55, centre=(sx * PX, -PY - 0.95, 5.5), biseau=0.06, segments=1))
    orr.append(boite(0.4, 1.4, 0.3, centre=(sx * PX, -PY - 0.85, 3.0), biseau=0.06, segments=1))
    orr.append(boite(0.4, 0.2, 0.5, centre=(sx * PX, -PY - 1.45, 3.25), biseau=0.06, segments=1))
cadre.append(boite(2 * PX, 0.6, 0.5, centre=(0, -PY, H - 0.25), biseau=0.12, segments=1))   # traverse avant
cadre.append(boite(2 * PX, 0.6, 0.5, centre=(0, PY, H - 0.25), biseau=0.12, segments=1))    # traverse arrière
cadre.append(boite(2 * PX, 0.7, 0.45, centre=(0, PY, 0.42), biseau=0.12, segments=1))      # rail arrière
cadre_ob = fusion(ID + "_Cadre", "CadreRouge", cadre)
fusion(ID + "_Or", "Or", orr)
fusion(ID + "_Tapis", "Sol", [boite(8.0, 6.0, 0.2, centre=(0, 0, 0.1), biseau=0.08, segments=1)])
BY, BZ = -PY - 0.65, 5.62
barre = [cylindre(0.13, 0.13, 9.6, centre=(0, BY, BZ), seg=10, rot=AXE_X)]
noir, blanc = [], []
for sx in (-1, 1):
    barre.append(cylindre(0.22, 0.22, 0.3, centre=(sx * 4.7, BY, BZ), seg=10, rot=AXE_X))   # embouts
    barre.append(cylindre(0.25, 0.25, 0.15, centre=(sx * 3.2, BY, BZ), seg=10, rot=AXE_X))  # colliers
    noir.append(cylindre(1.3, 1.3, 0.4, centre=(sx * 3.5, BY, BZ), seg=24, rot=AXE_X))
    noir.append(cylindre(1.3, 1.3, 0.4, centre=(sx * 3.92, BY, BZ), seg=24, rot=AXE_X))
    blanc.append(cylindre(1.32, 1.32, 0.36, centre=(sx * 4.32, BY, BZ), seg=24, rot=AXE_X))
    noir.append(cylindre(0.95, 0.95, 0.44, centre=(sx * 4.32, BY, BZ), seg=20, rot=AXE_X))
fusion(ID + "_Barre_Anthracite", "Anthracite", barre)
fusion(ID + "_Barre_Noir", "Noir", noir)
fusion(ID + "_Barre_Blanc", "Blanc", blanc)
finir(ID)

# ---------------------------------------------------------------- Presse à mollets (salle_presse)
# Origine au sol, au centre ; l'avant (plateau) vers -Y. Le plateau (« _Plateau_* ») bascule autour de son bord arrière.
vider()
ID = "salle_presse"
cadre, gris, noir, metal, orr = [], [], [], [], []
CY = 1.9          # plan des montants
UX = 1.55
for sx in (-1, 1):
    cadre.append(boite(0.5, 0.5, 5.6, centre=(sx * UX, CY, 0.4 + 2.8), biseau=0.12, segments=1))  # montants
    cadre.append(boite(0.55, 6.2, 0.4, centre=(sx * 1.7, -0.4, 0.35), biseau=0.12, segments=1))    # rails au sol
    for y in (-3.3, 2.5):
        noir.append(boite(0.8, 0.6, 0.25, centre=(sx * 1.7, y, 0.12), biseau=0.08, segments=1))    # pieds
    metal.append(cylindre(0.07, 0.07, 5.0, centre=(sx * 0.55, CY, 3.2), seg=8))                    # tiges guides
cadre.append(boite(2 * UX + 0.5, 0.5, 0.5, centre=(0, CY, 6.0), biseau=0.2, segments=2))   # haut arrondi
cadre.append(boite(3.9, 0.5, 0.4, centre=(0, CY, 0.55), biseau=0.12, segments=1))          # traverse basse
cadre.append(boite(3.9, 0.5, 0.4, centre=(0, -3.0, 0.55), biseau=0.12, segments=1))        # traverse avant
cadre.append(boite(0.45, 2.8, 0.45, centre=(0, CY - 1.4, 5.1), biseau=0.12, segments=1))  # bras vers l'avant
cadre.append(boite(2.8, 0.45, 0.45, centre=(0, 0.5, 5.1), biseau=0.12, segments=1))       # barre des épaulières
cadre.append(boite(2.6, 1.6, 0.45, centre=(0, -1.7, 0.7), biseau=0.12, segments=1))        # socle sous le plateau
noir.append(boite(1.9, 0.9, 2.6, centre=(0, CY, 0.8 + 1.3), biseau=0.08, segments=1))     # pile de poids
for i in range(6):
    gris.append(boite(1.95, 0.95, 0.06, centre=(0, CY, 0.95 + i * 0.42)))                  # joints de la pile
gris.append(cylindre(0.3, 0.3, 0.25, centre=(0, CY, 6.35), seg=12))                          # poulie
for sx in (-1, 1):
    orr.append(cylindre(0.62, 0.62, 0.5, centre=(sx * 0.75, 0.2, 4.68), seg=20))              # épaulières
    gris.append(cylindre(0.11, 0.11, 0.9, centre=(sx * 1.8, 0.5, 5.1), seg=8, rot=AXE_X))     # poignées
    noir.append(cylindre(0.16, 0.16, 0.7, centre=(sx * 2.55, 0.5, 5.1), seg=10, rot=AXE_X))
fusion(ID + "_Cadre", "CadreBleu", cadre)
fusion(ID + "_Anthracite", "Anthracite", gris)
fusion(ID + "_Noir", "Noir", noir)
fusion(ID + "_Metal", "Metal", metal)
fusion(ID + "_Or", "Or", orr)
# plateau incliné de 16° (avant plus bas), pivot au bord arrière (y = -0,6, z = 0,95)
pl_gris = rotx(boite(3.3, 2.6, 0.3, centre=(0, -1.9, 1.12), biseau=0.08, segments=1), -16, (0, -0.6, 0.95))
pl_blanc = rotx(boite(3.6, 2.9, 0.22, centre=(0, -1.9, 0.92), biseau=0.1, segments=1), -16, (0, -0.6, 0.95))
fusion(ID + "_Plateau_Anthracite", "Anthracite", [pl_gris])
fusion(ID + "_Plateau_Blanc", "Blanc", [pl_blanc])
finir(ID)

# ---------------------------------------------------------------- Tapis de course (salle_tapis)
# Origine au sol, au centre ; la console vers -Y, le coureur regarde vers -Y. La bande (« _Bande_* ») est séparée.
vider()
ID = "salle_tapis"
cadre, nuit, noir, orange, gris = [], [], [], [], []
L = 9.6
cadre.append(boite(4.2, L, 0.7, centre=(0, 0.2, 0.75), biseau=0.2, segments=2))            # plateau
for sx in (-1, 1):
    cadre.append(boite(0.6, L - 0.4, 0.55, centre=(sx * 2.25, 0.3, 1.0), biseau=0.2, segments=2))  # rebords
    for k in range(3):
        b = boite(0.08, 0.22, 0.4, centre=(sx * 2.56, 1.4 + k * 0.45, 1.0))
        bmesh.ops.rotate(b, verts=b.verts, cent=Vector((sx * 2.56, 1.6 + k * 0.45, 0.95)), matrix=Matrix.Rotation(math.radians(-30), 3, "X"))
        orange.append(b)
    orange.append(boite(0.08, 2.4, 0.2, centre=(sx * 2.56, 3.3, 1.0)))
    noir.append(cylindre(0.45, 0.45, 0.35, centre=(sx * 2.1, 4.75, 0.45), seg=16, rot=AXE_X))  # roues arrière
    noir.append(boite(0.6, 0.6, 0.4, centre=(sx * 1.8, -4.0, 0.2), biseau=0.1, segments=1))    # pieds avant
    # montants inclinés vers l'avant, de l'avant du plateau à la console
    m = boite(0.5, 0.6, 4.4, centre=(sx * 1.9, -3.75, 3.2), biseau=0.12, segments=1)
    rotx(m, 12, (sx * 1.9, -3.75, 1.0))
    cadre.append(m)
    gris.append(boite(0.35, 2.6, 0.35, centre=(sx * 2.15, -2.5, 4.85), biseau=0.1, segments=1))  # poignées
    noir.append(boite(0.45, 1.0, 0.45, centre=(sx * 2.15, -1.6, 4.85), biseau=0.12, segments=1))
nuit.append(boite(4.4, 1.6, 1.1, centre=(0, -4.2, 1.0), biseau=0.3, segments=2))           # capot moteur
nuit.append(boite(4.6, 1.4, 1.6, centre=(0, -4.25, 5.55), biseau=0.35, segments=2))        # console
rotx(nuit[-1], 25, (0, -4.25, 5.55))
ecran = boite(2.6, 0.12, 0.95, centre=(0, -3.5, 5.6), biseau=0.03, segments=1)
rotx(ecran, 25, (0, -4.25, 5.55))
fusion(ID + "_Cadre", "CadreGris", cadre)
fusion(ID + "_Nuit", "Nuit", nuit)
fusion(ID + "_Noir", "Noir", noir)
fusion(ID + "_Orange", "Orange", orange)
fusion(ID + "_Anthracite", "Anthracite", gris)
fusion(ID + "_Ecran_Cyan", "Cyan", [ecran])
fusion(ID + "_Bande_Noir", "Noir", [boite(3.6, L - 1.4, 0.12, centre=(0, 0.5, 1.16))])
lignes_bande = [boite(0.1, L - 1.4, 0.03, centre=(0, 0.5, 1.235))]
for k in range(5):
    lignes_bande.append(boite(3.4, 0.12, 0.03, centre=(0, -3.0 + k * 1.75, 1.235)))
fusion(ID + "_Bande_Blanc", "Blanc", lignes_bande)
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
