# T-115 : mascotte Bondo en pièces R15 rigides, construite par script dans Blender (sans fenêtre).
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

import json
COULEURS.update({
    "Fourrure": "#E08A3C", "Creme": "#FFE7C2", "Rose": "#FFB3A7", "Noir": "#1F2229", "Bouche": "#8A2232",
})

def ico(r, centre, sub=2, echelle=(1, 1, 1)):
    bm = bmesh.new()
    bmesh.ops.create_icosphere(bm, subdivisions=sub, radius=r)
    bmesh.ops.scale(bm, vec=echelle, verts=bm.verts)
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def tranche(bm, z0, z1):
    g = bm.verts[:] + bm.edges[:] + bm.faces[:]
    bmesh.ops.bisect_plane(bm, geom=g, plane_co=(0, 0, z1), plane_no=(0, 0, 1), clear_outer=True)
    g = bm.verts[:] + bm.edges[:] + bm.faces[:]
    bmesh.ops.bisect_plane(bm, geom=g, plane_co=(0, 0, z0), plane_no=(0, 0, 1), clear_inner=True)
    return bm

def capsule(p0, p1, r, seg=10):
    p0, p1 = Vector(p0), Vector(p1)
    d = p1 - p0
    bm = cylindre(r, r, d.length, seg=seg)
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=d.to_track_quat("Z", "Y").to_matrix())
    bmesh.ops.translate(bm, vec=(p0 + p1) / 2, verts=bm.verts)
    for p in (p0, p1):
        s = ico(r, p, sub=1)
        me = bpy.data.meshes.new("t"); s.to_mesh(me); s.free(); bm.from_mesh(me); bpy.data.meshes.remove(me)
    return bm

def cone(p0, p1, r0, r1, seg=10):
    p0, p1 = Vector(p0), Vector(p1)
    d = p1 - p0
    bm = cylindre(r0, r1, d.length, seg=seg)
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=d.to_track_quat("Z", "Y").to_matrix())
    bmesh.ops.translate(bm, vec=(p0 + p1) / 2, verts=bm.verts)
    return bm

def disque_face(r, centre, ep=0.04, seg=16):
    # disque tourné vers -Y (vers l'avant)
    bm = cylindre(r, r, ep, seg=seg)
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.pi / 2, 3, "X"))
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def anneau(R, r, z, seg=20):
    t = tore(R, r, seg=seg, segmin=6)
    bmesh.ops.rotate(t, verts=t.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.pi / 2, 3, "X"))
    bmesh.ops.translate(t, vec=(0, 0, z), verts=t.verts)
    return t

# ---------------------------------------------------------------- Mascotte Bondo (mascotte_bondo)
# Personnage R15 en pièces rigides, haut d'environ 6,4 (agrandi × 10 dans Studio). Chaque objet s'appelle
# mascotte_bondo_<Pièce R15>_<Couleur> ; la pièce principale de chaque membre est listée dans PRINCIPALES.
vider()
ID = "mascotte_bondo"
P = {}
def ajoute(piece, couleur, morceaux):
    P.setdefault((piece, couleur), []).extend(morceaux)

# Articulations (Blender)
J = {
    "Neck": (0, 0, 4.0), "Waist": (0, 0, 2.85), "Root": (0, 0, 2.55),
    "LeftShoulder": (-0.95, 0, 3.75), "RightShoulder": (0.95, 0, 3.75),
    "LeftHip": (-0.42, 0, 2.3), "RightHip": (0.42, 0, 2.3),
    "LeftKnee": (-0.45, 0.05, 1.35), "RightKnee": (0.45, 0.05, 1.35),
    "LeftAnkle": (-0.45, 0, 0.45), "RightAnkle": (0.45, 0, 0.45),
}
for cote, s in (("Left", -1), ("Right", 1)):  # le personnage regarde -Z dans Roblox : sa gauche est -X
    d = Vector((s * 0.5, 0, -0.866))
    epaule = Vector(J[cote + "Shoulder"])
    coude = epaule + d * 0.7
    poignet = coude + d * 0.62
    J[cote + "Elbow"] = tuple(coude)
    J[cote + "Wrist"] = tuple(poignet)
    ajoute(cote + "UpperArm", "Fourrure", [capsule(epaule, coude, 0.22)])
    ajoute(cote + "LowerArm", "Fourrure", [capsule(coude, poignet - d * 0.08, 0.2)])
    ajoute(cote + "LowerArm", "Blanc", [cone(poignet - d * 0.28, poignet - d * 0.06, 0.25, 0.25, seg=12)])
    main = poignet + d * 0.24
    ajoute(cote + "Hand", "Fourrure", [ico(0.27, main, sub=2, echelle=(0.9, 0.75, 1.1))] + [
        ico(0.09, main + d * 0.22 + Vector((0, -0.12 + 0.08 * k, 0)), sub=1) for k in range(4)
    ])
    hanche, genou, cheville = Vector(J[cote + "Hip"]), Vector(J[cote + "Knee"]), Vector(J[cote + "Ankle"])
    ajoute(cote + "UpperLeg", "Fourrure", [ico(0.5, (s * 0.46, 0.05, 1.85), sub=2, echelle=(0.95, 1.15, 1.15))])
    ajoute(cote + "LowerLeg", "Fourrure", [capsule(genou, cheville + Vector((0, 0, 0.12)), 0.2)])
    ajoute(cote + "Foot", "Blanc", [boite(0.62, 1.15, 0.42, centre=(s * 0.45, -0.22, 0.29), biseau=0.18, segments=3)])
    ajoute(cote + "Foot", "Orange", [boite(0.66, 1.2, 0.14, centre=(s * 0.45, -0.22, 0.07), biseau=0.06, segments=2)])

# Bassin, ventre et queue
ajoute("LowerTorso", "Fourrure", [
    ico(0.78, (0, 0.02, 2.6), sub=2, echelle=(1, 0.8, 0.55)),
    cone((0, 0.45, 2.35), (0, 1.5, 1.05), 0.36, 0.24, seg=12),
    cone((0, 1.5, 1.05), (0, 2.25, 0.35), 0.24, 0.17, seg=12),
])
ajoute("LowerTorso", "Creme", [ico(0.5, (0, -0.38, 2.6), sub=2, echelle=(0.9, 0.45, 0.75)), ico(0.2, (0, 2.42, 0.25), sub=2, echelle=(1, 1.8, 1))])
# Torse : fourrure, maillot bleu, bande orange, rond blanc, médaille
ajoute("UpperTorso", "Fourrure", [ico(0.8, (0, 0, 3.4), sub=2, echelle=(1, 0.68, 0.78))])
maillot = ico(0.86, (0, 0, 3.4), sub=3, echelle=(1, 0.72, 0.8))
ajoute("UpperTorso", "Bleu", [tranche(maillot, 2.86, 3.95)])
# bande orange en diagonale : une tranche du maillot, inclinée de 32°
bande = ico(0.88, (0, 0, 0), sub=3, echelle=(1, 0.74, 0.82))
bmesh.ops.rotate(bande, verts=bande.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.radians(32), 3, "Y"))
tranche(bande, -0.12, 0.12)
bmesh.ops.rotate(bande, verts=bande.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.radians(-32), 3, "Y"))
bmesh.ops.translate(bande, vec=(0, 0, 3.4), verts=bande.verts)
ajoute("UpperTorso", "Orange", [bande])
ajoute("UpperTorso", "Blanc", [disque_face(0.2, (0.3, -0.64, 3.2))])
ajoute("UpperTorso", "Or", [disque_face(0.15, (0, -0.66, 3.62), ep=0.06)])
ajoute("UpperTorso", "Bleu", [anneau(0.42, 0.035, 3.92)])
# Tête
ajoute("Head", "Fourrure", [
    ico(0.8, (0, 0, 4.75), sub=3, echelle=(1, 0.95, 0.95)),
    ico(1.0, (0.45, 0.05, 5.85), sub=2, echelle=(0.25, 0.13, 0.62)),
    ico(1.0, (-0.45, 0.05, 5.85), sub=2, echelle=(0.25, 0.13, 0.62)),
    ico(0.18, (0, 0.1, 5.58), sub=1), ico(0.14, (0.12, 0.05, 5.6), sub=1),
])
ajoute("Head", "Rose", [ico(1.0, (s * 0.45, -0.07, 5.85), sub=2, echelle=(0.17, 0.05, 0.48)) for s in (-1, 1)])
ajoute("Head", "Creme", [ico(0.44, (0, -0.58, 4.48), sub=2, echelle=(1.05, 0.85, 0.72))])
ajoute("Head", "Noir", [ico(0.13, (0, -0.95, 4.66), sub=2, echelle=(1.2, 0.8, 0.8))] + [ico(0.12, (s * 0.3, -0.78, 4.98), sub=2, echelle=(0.9, 0.5, 1.15)) for s in (-1, 1)])
ajoute("Head", "Blanc", [ico(0.21, (s * 0.3, -0.66, 4.98), sub=2, echelle=(0.95, 0.6, 1.2)) for s in (-1, 1)])
ajoute("Head", "Bouche", [ico(0.22, (0, -0.86, 4.32), sub=2, echelle=(1.2, 0.45, 0.7))])
ajoute("Head", "Bleu", [anneau(0.62, 0.12, 5.3, seg=24)])

for (piece, couleur), morceaux in P.items():
    ob = fusion(ID + "_" + piece + "_" + couleur, couleur, morceaux)
    ob["lisse"] = True

PRINCIPALES = {
    "Head": "Fourrure", "UpperTorso": "Bleu", "LowerTorso": "Fourrure",
    "LeftUpperArm": "Fourrure", "LeftLowerArm": "Fourrure", "LeftHand": "Fourrure",
    "RightUpperArm": "Fourrure", "RightLowerArm": "Fourrure", "RightHand": "Fourrure",
    "LeftUpperLeg": "Fourrure", "LeftLowerLeg": "Fourrure", "LeftFoot": "Blanc",
    "RightUpperLeg": "Fourrure", "RightLowerLeg": "Fourrure", "RightFoot": "Blanc",
}
def roblox(v):
    return [round(v[0], 4), round(v[2], 4), round(v[1], 4)]
centres = {}
for piece, couleur in PRINCIPALES.items():
    ob = bpy.data.objects[ID + "_" + piece + "_" + couleur]
    xs = [v.co for v in ob.data.vertices]
    mn = Vector((min(c.x for c in xs), min(c.y for c in xs), min(c.z for c in xs)))
    mx = Vector((max(c.x for c in xs), max(c.y for c in xs), max(c.z for c in xs)))
    centres[piece] = roblox((mn + mx) / 2)
json.dump({"centres": centres, "articulations": {k: roblox(v) for k, v in J.items()}, "principales": PRINCIPALES},
          open(os.path.join(SOURCE, ID + "_articulations.json"), "w", encoding="utf-8"), indent=1)
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
