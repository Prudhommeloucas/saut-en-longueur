# T-218 et T-219 : tableau des quêtes (place_tableau) et cadeau (place_cadeau), construits par script dans Blender (sans fenêtre).
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
    for nom, d in (("face", Vector((0, -1, 0))), ("34", Vector((0.8, -1, 0.55)))):
        pos = centre + d.normalized() * rayon * 3
        cam.location = pos
        cam.rotation_euler = (centre - pos).to_track_quat("-Z", "Y").to_euler()
        sc.render.filepath = os.path.join(APERCU, f"{ident}_apercu{'' if nom == '34' else '_face'}.png")
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

# ---------------------------------------------------------------- Tableau des quêtes (T-218)
# Origine au sol, au centre ; l'avant vers -Y. L'écran (planche nuit) : 17,4 × 9,6, face avant en y = -0,55, centre z = 8,6.
vider()
ID = "place_tableau"
bleu, orr, orange = [], [], []
for s in (-1, 1):
    x = s * 10.0
    bleu.append(boite(2.2, 2.2, 13.0, centre=(x, 0, 0.8 + 6.5), biseau=0.3, segments=2))
    orr.append(boite(3.0, 3.0, 0.8, centre=(x, 0, 0.4), biseau=0.2, segments=1))
    orr.append(boite(3.0, 3.0, 1.4, centre=(x, 0, 14.5), biseau=0.25, segments=1))
    orange.append(boite(5.0, 3.4, 0.6, centre=(x + s * 0.8, 0, 15.5), biseau=0.2, segments=1))
    for z in (5.0, 11.0):
        orr.append(cylindre(0.35, 0.35, 0.3, centre=(x, -1.2, z), seg=10, rot=Matrix.Rotation(math.pi / 2, 3, "X")))
blanc = [boite(18.6, 0.9, 10.8, centre=(0, 0.1, 8.6), biseau=0.3, segments=2)]
nuit = [boite(17.4, 0.9, 9.6, centre=(0, -0.1, 8.6), biseau=0.05, segments=1)]
# fronton doré en arc, bordé de blanc, sur la traverse
orr.append(boite(17.4, 1.2, 1.0, centre=(0, 0, 14.5)))
orr.append(arche(17.4, 3.8, 15.0, 1.2, y=0.0))
blanc.append(arche(18.4, 4.3, 14.6, 0.9, y=0.25))
blanc.append(arche(15.0, 2.9, 15.4, 0.1, y=-0.66))  # liseré blanc sur la face avant
orr.append(arche(14.4, 2.6, 15.55, 0.12, y=-0.72))
orange.append(etoile(2.0, 0.9, (0, 19.3), -0.2))
fusion(ID + "_Bleu", "Bleu", bleu)
fusion(ID + "_Or", "Or", orr)
fusion(ID + "_Orange", "Orange", orange)
fusion(ID + "_Blanc", "Blanc", blanc)
fusion(ID + "_Nuit", "Nuit", nuit)
finir(ID)

# ---------------------------------------------------------------- Cadeau (T-219)
# Origine au sol, au centre. Le couvercle (meshes « Couvercle_* ») est séparé : il saute à l'ouverture.
vider()
ID = "place_cadeau"
fusion(ID + "_Bleu", "Bleu", [cylindre(5.5, 5.5, 0.5, centre=(0, 0, 0.25), seg=32)])
fusion(ID + "_Blanc", "Blanc", [cylindre(5.1, 5.1, 0.7, centre=(0, 0, 0.85), seg=32)])
Z0 = 1.2
fusion(ID + "_Violet", "Violet", [boite(7.0, 7.0, 5.0, centre=(0, 0, Z0 + 2.5), biseau=0.5, segments=2)])
fusion(ID + "_Or", "Or", [
    boite(1.4, 7.16, 4.9, centre=(0, 0, Z0 + 2.45), biseau=0.1, segments=1),
    boite(7.16, 1.4, 4.9, centre=(0, 0, Z0 + 2.45), biseau=0.1, segments=1),
])
ZC = Z0 + 5.0
fusion(ID + "_Couvercle_Violet", "Violet", [boite(7.6, 7.6, 1.5, centre=(0, 0, ZC + 0.75), biseau=0.4, segments=2)])
liseré = []
for s in (-1, 1):
    liseré.append(boite(7.7, 0.12, 0.22, centre=(0, s * 3.8, ZC + 0.12)))
    liseré.append(boite(0.12, 7.7, 0.22, centre=(s * 3.8, 0, ZC + 0.12)))
fusion(ID + "_Couvercle_Blanc", "Blanc", liseré)
noeud = [
    boite(1.5, 7.76, 1.42, centre=(0, 0, ZC + 0.78), biseau=0.1, segments=1),
    boite(7.76, 1.5, 1.42, centre=(0, 0, ZC + 0.78), biseau=0.1, segments=1),
    boite(1.4, 1.4, 1.2, centre=(0, 0, ZC + 2.0), biseau=0.35, segments=2),
]
for s in (-1, 1):
    boucle = tore(1.25, 0.42, seg=16, segmin=6, ecrase=1.0)
    bmesh.ops.scale(boucle, vec=(1.0, 1.0, 0.8), verts=boucle.verts)
    bmesh.ops.rotate(boucle, verts=boucle.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(s * math.radians(-25), 3, "Y"))
    bmesh.ops.translate(boucle, vec=Vector((s * 1.55, 0, ZC + 2.6)), verts=boucle.verts)
    noeud.append(boucle)
    queue = boite(0.7, 0.3, 1.6, centre=(0, 0, 0), biseau=0.1, segments=1)
    bmesh.ops.rotate(queue, verts=queue.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(s * math.radians(35), 3, "Y"))
    bmesh.ops.translate(queue, vec=Vector((s * 0.9, -0.8, ZC + 1.4)), verts=queue.verts)
    noeud.append(queue)
fusion(ID + "_Couvercle_Or", "Or", noeud)
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
