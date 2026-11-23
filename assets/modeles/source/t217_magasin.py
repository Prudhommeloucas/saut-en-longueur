# T-217 : magasin de la place centrale (place_magasin), construit par script dans Blender (sans fenêtre).
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
    "Gris": "#5B6577", "Orange": "#FF7A1A",
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
    for nom, d in (("face", Vector((0, -1, 0))), ("34", Vector((0.8, -1, 0.55)))):
        pos = centre + d.normalized() * rayon * 3
        cam.location = pos
        cam.rotation_euler = (centre - pos).to_track_quat("-Z", "Y").to_euler()
        sc.render.filepath = os.path.join(APERCU, f"{ident}_apercu{'' if nom == '34' else '_face'}.png")
        bpy.ops.render.render(write_still=True)
    bpy.data.objects.remove(cam)

def demi_disque(r, ep, centre, seg=8):
    # Demi-disque pendant vers le bas, dans le plan XZ, épaisseur ep en Y
    bm = bmesh.new()
    cx, cy, cz = centre
    av, ar = [], []
    for i in range(seg + 1):
        a = math.pi + math.pi * i / seg  # de 180° à 360° : moitié basse
        x, z = cx + r * math.cos(a), cz + r * math.sin(a)
        av.append(bm.verts.new((x, cy - ep / 2, z)))
        ar.append(bm.verts.new((x, cy + ep / 2, z)))
    bm.faces.new(av)
    bm.faces.new(list(reversed(ar)))
    for i in range(seg):
        bm.faces.new((av[i], av[i + 1], ar[i + 1], ar[i]))
    bm.faces.new((av[-1], av[0], ar[0], ar[-1]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return bm

def tourner(bm, angle, axe, cent):
    bmesh.ops.rotate(bm, verts=bm.verts, cent=Vector(cent), matrix=Matrix.Rotation(angle, 3, axe))
    return bm

# ---------------------------------------------------------------- Magasin
# Origine au sol, au centre ; ouvert vers -Y (l'avant). 34 de large, 20 de profondeur hors auvent, environ 22 de haut.
vider()
ID = "place_magasin"
Z0 = 1.2           # dessus du socle
H_MUR = 13.0       # hauteur des murs au-dessus du socle
ZT = Z0 + H_MUR    # bas du toit

bleu = [
    boite(34, 20, Z0, centre=(0, 0, Z0 / 2), biseau=0.4, segments=1),                 # socle
    boite(33, 2, 2.5, centre=(0, 8.25, Z0 + 1.25), biseau=0.3, segments=1),           # bande du mur du fond
    boite(35, 21, 1.6, centre=(0, 0, ZT + 0.8), biseau=0.5, segments=2),              # toit
    boite(24, 3, 4, centre=(0, -5.5, Z0 + 2), biseau=0.3, segments=1),                # comptoir
]
for s in (-1, 1):
    bleu.append(boite(2, 19, 2.5, centre=(s * 15.25, 0, Z0 + 1.25), biseau=0.3, segments=1))  # bandes des côtés
blanc = [boite(32, 1.5, H_MUR, centre=(0, 8.25, Z0 + H_MUR / 2), biseau=0.2, segments=1)]
for s in (-1, 1):
    blanc.append(boite(1.5, 18, H_MUR, centre=(s * 15.25, 0, Z0 + H_MUR / 2), biseau=0.2, segments=1))
# marche devant le comptoir (bleue elle aussi, comme le socle)
bleu.append(boite(22, 2.4, 0.6, centre=(0, -11.1, 0.3), biseau=0.15, segments=1))
# fond intérieur gris et quatre niches sombres
gris = [boite(29, 0.3, H_MUR - 0.2, centre=(0, 7.35, Z0 + H_MUR / 2))]
nuit = []
XN = (-10.5, -3.5, 3.5, 10.5)
ZN = Z0 + 7.5
for x in XN:
    nuit.append(boite(5.6, 0.3, 4.6, centre=(x, 7.1, ZN), biseau=0.15, segments=1))
# comptoir : dessus et façade dorés
orr = [
    boite(25, 3.6, 0.6, centre=(0, -5.5, Z0 + 4.3), biseau=0.2, segments=1),
    boite(19, 0.3, 2.2, centre=(0, -7.05, Z0 + 2), biseau=0.1, segments=1),
]
# enseigne sur le toit, penchée vers l'avant : cadre nuit, panneau or vide
cadre = boite(20, 1.2, 6.4, centre=(0, -2, ZT + 1.6 + 3.2), biseau=0.4, segments=2)
panneau = boite(18, 0.4, 4.8, centre=(0, -2.7, ZT + 1.6 + 3.2), biseau=0.1, segments=1)
pied = boite(16, 1.4, 0.8, centre=(0, -1.6, ZT + 1.6 + 0.2), biseau=0.2, segments=1)
for bm in (cadre, panneau):
    tourner(bm, math.radians(-10), "X", (0, -2, ZT + 1.6))
nuit += [cadre, pied]
orr.append(panneau)
# objets des niches : chaussures, propulseur, haltère, maillot
ZB = ZN - 2.3 + 0.15   # fond de la niche
orange = []
# chaussures (x = -10.5) : deux semelles blanches et deux tiges orange
for dx in (-1.1, 1.1):
    blanc.append(boite(1.6, 3.0, 0.5, centre=(-10.5 + dx, 6.2, ZB + 0.25), biseau=0.15, segments=1))
    orange.append(boite(1.5, 2.2, 1.4, centre=(-10.5 + dx, 6.5, ZB + 1.2), biseau=0.35, segments=1))
# propulseur (x = -3.5) : sac bleu, deux tuyères grises
bleu.append(boite(3.0, 1.6, 3.2, centre=(-3.5, 6.4, ZB + 2.0), biseau=0.5, segments=2))
for dx in (-0.8, 0.8):
    gris.append(cylindre(0.55, 0.35, 1.0, centre=(-3.5 + dx, 6.4, ZB + 0.25), seg=10))
# haltère (x = 3.5) : barre nuit, deux disques gris
rx = Matrix.Rotation(math.pi / 2, 3, "Y")
nuit.append(cylindre(0.25, 0.25, 4.2, centre=(3.5, 6.4, ZB + 1.3), seg=8, rot=rx))
for dx in (-1.6, 1.6):
    gris.append(cylindre(1.2, 1.2, 0.6, centre=(3.5 + dx, 6.4, ZB + 1.3), seg=14, rot=rx))
# maillot (x = 10.5) sur un cintre doré
orange.append(boite(2.4, 0.6, 3.0, centre=(10.5, 6.4, ZB + 1.7), biseau=0.2, segments=1))
for s in (-1, 1):
    b = boite(1.2, 0.6, 0.9, centre=(0, 0, 0), biseau=0.15, segments=1)
    tourner(b, s * math.radians(35), "Y", (0, 0, 0))
    bmesh.ops.translate(b, vec=Vector((10.5 + s * 1.6, 6.4, ZB + 2.8)), verts=b.verts)
    orange.append(b)
blanc.append(boite(2.4, 0.62, 0.5, centre=(10.5, 6.4, ZB + 2.0)))  # bande blanche du maillot
orr.append(cylindre(0.12, 0.12, 2.6, centre=(10.5, 6.4, ZB + 3.4), seg=6, rot=rx))
orr.append(cylindre(0.1, 0.1, 0.8, centre=(10.5, 6.4, ZB + 3.8), seg=6))
# auvent rayé : 11 bandes de 3, du bord du toit vers l'avant et le bas, festons en bas
Y0, Z_HAUT = -10.6, ZT + 0.2
Y1, Z_BAS = -14.4, ZT - 2.7
L = math.hypot(Y1 - Y0, Z_BAS - Z_HAUT)
ang = math.atan2(Z_HAUT - Z_BAS, Y0 - Y1)
N = 11
for i in range(N):
    x = -16.5 + 1.5 + i * 3
    b = boite(3.0, L, 0.4, centre=(0, 0, 0))
    tourner(b, ang, "X", (0, 0, 0))
    bmesh.ops.translate(b, vec=Vector((x, (Y0 + Y1) / 2, (Z_HAUT + Z_BAS) / 2)), verts=b.verts)
    feston = demi_disque(1.5, 0.4, (x, Y1, Z_BAS + 0.1))
    (orange if i % 2 == 0 else blanc).extend([b, feston])
# deux poteaux dorés aux coins avant, sous l'auvent
for s in (-1, 1):
    orr.append(cylindre(0.45, 0.45, Z_BAS - 0.6, centre=(s * 15.5, -13.6, (Z_BAS - 0.6) / 2 + 0.0), seg=10))
    orr.append(sphere(0.7, (s * 15.5, -13.6, Z_BAS - 0.4), sub=1))

fusion(ID + "_Bleu", "Bleu", bleu)
fusion(ID + "_Blanc", "Blanc", blanc)
fusion(ID + "_Orange", "Orange", orange)
fusion(ID + "_Or", "Or", orr)
fusion(ID + "_Nuit", "Nuit", nuit)
fusion(ID + "_Gris", "Gris", gris)
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
