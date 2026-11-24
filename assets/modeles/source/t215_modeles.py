# T-215 : arche de palier, parc (kiosque, arbre, montgolfière, cerf-volant), lac (voilier, canard, bouée, roseaux), construits par script dans Blender (sans fenêtre).
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
    "Brun": "#7A4E26", "Bois": "#A0703C", "Vert": "#4FB83A", "VertClair": "#8BD43A", "Violet": "#7B3FD6",
    "Creme": "#FFF3D6", "Jaune": "#FFD84A", "Rouge": "#E5484D", "Noir": "#1F2229", "Lumiere": "#FFB347",
    "Roseau": "#4E9A3A", "Gris": "#9AA3AE", "Osier": "#B07A45",
})

AXE_X = Matrix.Rotation(math.pi / 2, 3, "Y")
AXE_Y = Matrix.Rotation(math.pi / 2, 3, "X")

def ico(r, centre, sub=2, echelle=(1, 1, 1)):
    bm = bmesh.new()
    bmesh.ops.create_icosphere(bm, subdivisions=sub, radius=r)
    bmesh.ops.scale(bm, vec=echelle, verts=bm.verts)
    bmesh.ops.translate(bm, vec=Vector(centre), verts=bm.verts)
    return bm

def tranche(bm, z0, z1):
    # garde la partie du maillage entre z0 et z1 (coupe ouverte)
    g = bm.verts[:] + bm.edges[:] + bm.faces[:]
    bmesh.ops.bisect_plane(bm, geom=g, plane_co=(0, 0, z1), plane_no=(0, 0, 1), clear_outer=True)
    g = bm.verts[:] + bm.edges[:] + bm.faces[:]
    bmesh.ops.bisect_plane(bm, geom=g, plane_co=(0, 0, z0), plane_no=(0, 0, 1), clear_inner=True)
    return bm

def part_tronc(a0, a1, r0, r1, z0, z1, centre=(0, 0)):
    # part de tronc de cône pleine (de l'angle a0 à a1), pour les toits à quartiers
    bm = bmesh.new()
    cx, cy = centre
    c0 = bm.verts.new((cx, cy, z0)); c1 = bm.verts.new((cx, cy, z1))
    p = [bm.verts.new((cx + r0 * math.cos(a), cy + r0 * math.sin(a), z0)) for a in (a0, a1)]
    q = [bm.verts.new((cx + r1 * math.cos(a), cy + r1 * math.sin(a), z1)) for a in (a0, a1)]
    bm.faces.new((c0, p[1], p[0]))
    bm.faces.new((c1, q[0], q[1]))
    bm.faces.new((p[0], p[1], q[1], q[0]))
    bm.faces.new((c0, p[0], q[0], c1))
    bm.faces.new((c0, c1, q[1], p[1]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return bm

def poteau(p0, p1, r, seg=6):
    # cylindre entre deux points
    p0, p1 = Vector(p0), Vector(p1)
    d = p1 - p0
    bm = cylindre(r, r, d.length, seg=seg)
    rot = d.to_track_quat("Z", "Y").to_matrix()
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=rot)
    bmesh.ops.translate(bm, vec=(p0 + p1) / 2, verts=bm.verts)
    return bm

# ---------------------------------------------------------------- Arche de palier (palier_arche)
# Largeur selon X (posée en travers du bac dans Studio), plaques sur les faces ±Y. Haut sans collision dans Studio.
vider()
ID = "palier_arche"
bleu, orr, blanc, orange = [], [], [], []
PX = 32
for s in (-1, 1):
    x = s * PX
    bleu.append(boite(9, 9, 2, centre=(x, 0, 1), biseau=0.4, segments=2))
    orr.append(boite(7.8, 7.8, 0.6, centre=(x, 0, 2.3), biseau=0.15, segments=1))
    bleu.append(boite(7, 7, 27.4, centre=(x, 0, 2.6 + 13.7), biseau=0.4, segments=2))
    for z in (8.5, 11.5):
        blanc.append(boite(7.2, 7.2, 1.1, centre=(x, 0, z), biseau=0.1, segments=1))
    orr.append(boite(7.8, 7.8, 0.9, centre=(x, 0, 30.4), biseau=0.2, segments=1))
    bleu.append(boite(6, 6, 5.2, centre=(x, 0, 33.4), biseau=0.4, segments=2))
    orr.append(cylindre(3.7, 3.4, 1.6, centre=(x, 0, 36.8), seg=16))
    orr.append(ico(2.5, (x, 0, 38.9), sub=2, echelle=(1, 1, 0.9)))
    orr.append(ico(0.8, (x, 0, 41.6), sub=1))
# poutre arquée orange, liseré blanc dessus et dessous
def arc(demi, bas0, bas1, haut0, haut1, ep, y=0.0, n=16):
    pts_h = [(demi * (2 * i / n - 1), haut0 + (haut1 - haut0) * (1 - (2 * i / n - 1) ** 2)) for i in range(n + 1)]
    pts_b = [(demi * (2 * i / n - 1), bas0 + (bas1 - bas0) * (1 - (2 * i / n - 1) ** 2)) for i in range(n, -1, -1)]
    return prisme(pts_h + pts_b, ep, y)
orange.append(arc(29.5, 30, 33, 36.5, 40.5, 6))
blanc.append(arc(29.7, 29.6, 32.6, 36.9, 40.9, 5.2))
for s in (-1, 1):
    orr.append(boite(19, 0.5, 5.2, centre=(0, s * 3.2, 36.8), biseau=0.2, segments=2))
    for xe in (-13.5, 13.5):
        orr.append(etoile(1.3, 0.4, (xe, 36.5), s * 3.15))
# drapeau sur le pilier droit (meshes « Drapeau_* » séparés : il se balance)
orr.append(cylindre(0.18, 0.18, 6, centre=(PX, 0, 44.6), seg=6))
fusion(ID + "_Bleu", "Bleu", bleu)
fusion(ID + "_Or", "Or", orr)
fusion(ID + "_Blanc", "Blanc", blanc)
fusion(ID + "_Orange", "Orange", orange)
fusion(ID + "_Drapeau_Bleu", "Bleu", [prisme([(PX + 0.2, 47.4), (PX + 4.4, 46.3), (PX + 0.2, 45.0)], 0.2)])
finir(ID)

# ---------------------------------------------------------------- Kiosque (parc_kiosque)
# Toit (« Toit_* ») séparé : il tourne lentement. Marches vers -Y.
vider()
ID = "parc_kiosque"
blanc, bois, orange, orr, toitb = [], [], [], [], []
blanc.append(cylindre(12, 12, 2.4, centre=(0, 0, 1.2), seg=32))
blanc.append(cylindre(12.4, 12.4, 0.4, centre=(0, 0, 2.6), seg=32))
for i, (w, h) in enumerate(((6, 0.8), (6, 1.6))):
    blanc.append(boite(w, 1.4, h, centre=(0, -12.6 - (1 - i) * 1.3, h / 2), biseau=0.1, segments=1))
for k in range(8):
    a = math.pi / 8 + k * math.pi / 4
    x, y = 10.4 * math.cos(a), 10.4 * math.sin(a)
    blanc.append(cylindre(0.6, 0.6, 8.2, centre=(x, y, 2.8 + 4.1), seg=10))
    blanc.append(cylindre(0.85, 0.85, 0.5, centre=(x, y, 3.05), seg=10))
    blanc.append(cylindre(0.85, 0.85, 0.5, centre=(x, y, 10.7), seg=10))
    # garde-corps entre les colonnes (sauf devant les marches)
    a2 = a + math.pi / 4
    if math.sin((a + a2) / 2) > -0.85:  # pas de garde-corps devant les marches (-Y)
        x2, y2 = 10.4 * math.cos(a2), 10.4 * math.sin(a2)
        blanc.append(poteau((x, y, 4.6), (x2, y2, 4.6), 0.18))
bois.append(cylindre(12.8, 12.8, 0.6, centre=(0, 0, 11.2), seg=32))
N = 16
for k in range(N):
    a0, a1 = 2 * math.pi * k / N, 2 * math.pi * (k + 1) / N
    (orange if k % 2 == 0 else toitb).append(part_tronc(a0, a1, 13.6, 1.4, 11.4, 17.2))
orr.append(cylindre(1.6, 1.6, 0.5, centre=(0, 0, 17.4), seg=16))
orr.append(ico(1.6, (0, 0, 19.0), sub=2))
orr.append(cylindre(0.08, 0.08, 2.4, centre=(0, 0, 21.6), seg=6))
fusion(ID + "_Blanc", "Blanc", blanc)
fusion(ID + "_Toit_Bois", "Bois", bois)
fusion(ID + "_Toit_Orange", "Orange", orange + [prisme([(0.1, 22.7), (1.6, 22.3), (0.1, 21.9)], 0.1)])
fusion(ID + "_Toit_Blanc", "Blanc", toitb)
fusion(ID + "_Toit_Or", "Or", orr)
finir(ID)

# ---------------------------------------------------------------- Arbre rond (parc_arbre)
vider()
ID = "parc_arbre"
brun = [
    cylindre(1.5, 0.9, 7.5, centre=(0, 0, 3.75), seg=10),
    poteau((0, 0, 6.2), (-2.2, -0.6, 8.2), 0.55),
    poteau((0, 0, 6.2), (2.2, -0.6, 8.2), 0.55),
]
for k in range(3):
    a = k * 2 * math.pi / 3 + 0.4
    brun.append(poteau((0, 0, 0.6), (1.9 * math.cos(a), 1.9 * math.sin(a), 0.05), 0.45))
fusion(ID + "_Brun", "Brun", brun)
fusion(ID + "_Vert", "Vert", [ico(6.4, (0, 0.6, 12.8)), ico(4.9, (5.0, -0.8, 9.6)), ico(4.6, (0, 4.0, 10.2))])
fusion(ID + "_VertClair", "VertClair", [ico(4.9, (-5.0, -0.8, 9.6))])
for ob in bpy.context.scene.objects:
    if "Vert" in ob.name:
        ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Montgolfière (parc_montgolfiere)
# Nacelle (« Nacelle_* ») séparée. Origine sous la nacelle.
vider()
ID = "parc_montgolfiere"
def profil(t):
    # t de 0 (bas) à 1 (haut) : rayon du ballon
    if t < 0.35:
        return 2.2 + (9.6 - 2.2) * math.sin(t / 0.35 * math.pi / 2) ** 1.3
    return 9.6 * math.sqrt(max(0.0, 1 - ((t - 0.35) / 0.65) ** 2.2)) + 0.0001
ZB, HB = 9.0, 22.0
NG, NT = 12, 14
def gore(k):
    bm = bmesh.new()
    a0, a1 = 2 * math.pi * k / NG, 2 * math.pi * (k + 1) / NG
    lignes = []
    for i in range(NT + 1):
        t = i / NT
        r, z = profil(t), ZB + HB * t
        lignes.append([bm.verts.new((r * math.cos(a), r * math.sin(a), z)) for a in (a0, (a0 + a1) / 2, a1)])
    for i in range(NT):
        for j in range(2):
            bm.faces.new((lignes[i][j], lignes[i][j + 1], lignes[i + 1][j + 1], lignes[i + 1][j]))
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=0.001)
    return bm
fusion(ID + "_Orange", "Orange", [gore(k) for k in range(0, NG, 2)])
fusion(ID + "_Or", "Or", [gore(k) for k in range(1, NG, 2)])
bande = bmesh.new()
for k in range(NG):
    b = gore(k)
    me = bpy.data.meshes.new("t"); b.to_mesh(me); b.free(); bande.from_mesh(me); bpy.data.meshes.remove(me)
bmesh.ops.remove_doubles(bande, verts=bande.verts, dist=0.001)
bmesh.ops.scale(bande, vec=(1.03, 1.03, 1), verts=bande.verts)
tranche(bande, ZB + HB * 0.47, ZB + HB * 0.62)
fusion(ID + "_Blanc", "Blanc", [bande, cylindre(2.3, 2.1, 0.8, centre=(0, 0, ZB - 0.2), seg=16)])
cordes = []
for k in range(4):
    a = math.pi / 4 + k * math.pi / 2
    cordes.append(poteau((2.0 * math.cos(a), 2.0 * math.sin(a), 4.3), (6.5 * math.cos(a), 6.5 * math.sin(a), ZB + 4.0), 0.07, seg=4))
    cordes.append(poteau((2.0 * math.cos(a), 2.0 * math.sin(a), 4.3), (1.6 * math.cos(a), 1.6 * math.sin(a), 6.8), 0.07, seg=4))
def anneau_couche(R, r, z, segmin=4):
    # le tore est construit dans le plan XZ : on le couche à plat, puis on le monte à la hauteur z
    t = tore(R, r, seg=16, segmin=segmin)
    bmesh.ops.rotate(t, verts=t.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.pi / 2, 3, "X"))
    bmesh.ops.translate(t, vec=(0, 0, z), verts=t.verts)
    return t
fusion(ID + "_Gris", "Gris", cordes + [anneau_couche(1.7, 0.12, 6.8)])
fusion(ID + "_Nacelle_Osier", "Osier", [boite(4.0, 4.0, 3.2, centre=(0, 0, 1.6), biseau=0.3, segments=2)])
fusion(ID + "_Nacelle_Brun", "Brun", [anneau_couche(2.2, 0.3, 3.2, segmin=6)])
for ob in bpy.context.scene.objects:
    if ob.name.endswith(("_Orange", "_Or", "_Blanc")):
        ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Cerf-volant (parc_cerf_volant)
# Dans le plan XZ (face vers -Y). Origine au bas de la queue.
vider()
ID = "parc_cerf_volant"
H0 = 6.0
haut, droite, bas, gauche = (0, H0 + 8.5), (3.0, H0 + 5.4), (0, H0), (-3.0, H0 + 5.4)
c = (0, H0 + 5.4)
tri = [(haut, droite), (droite, bas), (bas, gauche), (gauche, haut)]
fusion(ID + "_Violet", "Violet", [prisme([c, tri[0][0], tri[0][1]], 0.25), prisme([c, tri[2][0], tri[2][1]], 0.25)])
fusion(ID + "_Blanc", "Blanc", [prisme([c, tri[1][0], tri[1][1]], 0.25), prisme([c, tri[3][0], tri[3][1]], 0.25)])
cadre = []
for a, b in tri + [(haut, bas), (gauche, droite)]:
    cadre.append(poteau((a[0], -0.2, a[1]), (b[0], -0.2, b[1]), 0.12, seg=6))
queue = [poteau((0, 0, H0), (0.6, 0, H0 - 2.2), 0.06, seg=4), poteau((0.6, 0, H0 - 2.2), (-0.2, 0, H0 - 4.4), 0.06, seg=4), poteau((-0.2, 0, H0 - 4.4), (0.5, 0, 0), 0.06, seg=4)]
fusion(ID + "_Cadre_Violet", "Violet", cadre + queue)
noeuds = {"Blanc": [], "Violet": []}
for i, (x, z) in enumerate(((0.5, H0 - 1.6), (0.3, H0 - 3.3), (0.0, H0 - 5.0))):
    noeud = prisme([(x - 0.8, z + 0.4), (x, z), (x - 0.8, z - 0.4)], 0.3)
    noeud2 = prisme([(x + 0.8, z + 0.4), (x, z), (x + 0.8, z - 0.4)], 0.3)
    noeuds["Blanc" if i == 1 else "Violet"] += [noeud, noeud2]
fusion(ID + "_Noeud_Blanc", "Blanc", noeuds["Blanc"])
fusion(ID + "_Noeud_Violet", "Violet", noeuds["Violet"])
finir(ID)

# ---------------------------------------------------------------- Voilier (lac_voilier)
# Proue vers -X (le bateau avance vers -X). Voile (« Voile_* ») séparée. Origine au bas de la coque.
vider()
ID = "lac_voilier"
def coque(ech=1.0):
    bm = boite(16, 6, 3.6, centre=(0, 0, 1.8), biseau=1.4, segments=4)
    for v in bm.verts:
        if v.co.x < -3:
            k = 1 - 0.55 * min(1, (-3 - v.co.x) / 5)
            v.co.y *= k
        if v.co.z < 0.8:
            v.co.y *= 0.8
    bmesh.ops.scale(bm, vec=(ech, ech, 1), verts=bm.verts)
    return bm
fusion(ID + "_Blanc", "Blanc", [coque()])
ligne = coque(1.015)
tranche(ligne, 1.05, 1.55)
fusion(ID + "_Bleu", "Bleu", [ligne])
fusion(ID + "_Bois", "Bois", [boite(13, 4.6, 0.3, centre=(0.5, 0, 3.2)), boite(1.2, 4.4, 0.4, centre=(4.5, 0, 3.6))])
fusion(ID + "_Brun", "Brun", [
    cylindre(0.3, 0.25, 14, centre=(-1.5, 0, 3.2 + 7), seg=8),
    poteau((-1.5, 0, 5.6), (6.0, 0, 5.6), 0.18),
    boite(0.4, 0.3, 2.6, centre=(8.2, 0, 1.4)),
])
fusion(ID + "_Voile_Creme", "Creme", [
    prisme([(-1.2, 5.9), (6.0, 5.9), (-1.2, 16.8)], 0.15, y=0.15),
    prisme([(-1.8, 15.8), (-1.8, 6.0), (-7.4, 3.6)], 0.15, y=0.15),
])
# bande orange sur la grand-voile : trapèze entre deux hauteurs
z0, z1 = 9.6, 11.0
xa0, xa1 = 6.0 - 7.2 * (z0 - 5.9) / 10.9, 6.0 - 7.2 * (z1 - 5.9) / 10.9
fusion(ID + "_Voile_Orange", "Orange", [prisme([(-1.2, z0), (xa0, z0), (xa1, z1), (-1.2, z1)], 0.18, y=0.15)])
for ob in bpy.context.scene.objects:
    if ob.name.endswith(("_Blanc", "_Bleu")):
        ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Canard (lac_canard)
# Tête vers -Y. Origine sous le corps.
vider()
ID = "lac_canard"
fusion(ID + "_Jaune", "Jaune", [
    ico(1.0, (0, 0.15, 0.75), echelle=(0.95, 1.2, 0.78)),
    ico(0.62, (0, -0.6, 1.6)),
    ico(0.4, (0, 1.2, 1.15), echelle=(0.6, 0.7, 1.2)),
    ico(0.45, (0.85, 0.2, 0.85), echelle=(0.35, 1.0, 0.7)),
    ico(0.45, (-0.85, 0.2, 0.85), echelle=(0.35, 1.0, 0.7)),
])
fusion(ID + "_Orange", "Orange", [ico(0.35, (0, -1.2, 1.45), echelle=(1.1, 1.0, 0.5))])
fusion(ID + "_Noir", "Noir", [ico(0.09, (s * 0.3, -1.1, 1.78), sub=1) for s in (-1, 1)])
for ob in bpy.context.scene.objects:
    ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Bouée (lac_bouee)
vider()
ID = "lac_bouee"
def bande_bouee(z0, z1):
    return tranche(ico(1.4, (0, 0, 1.4), sub=3), z0, z1)
fusion(ID + "_Rouge", "Rouge", [bande_bouee(0, 0.7), bande_bouee(1.25, 1.95), bande_bouee(2.6, 2.8)])
fusion(ID + "_Blanc", "Blanc", [bande_bouee(0.7, 1.25), bande_bouee(1.95, 2.6)])
fusion(ID + "_Or", "Or", [cylindre(0.5, 0.45, 0.45, centre=(0, 0, 2.95), seg=12)])
fusion(ID + "_Lumiere", "Lumiere", [ico(0.38, (0, 0, 3.25), sub=2, echelle=(1, 1, 1.15))])
for ob in bpy.context.scene.objects:
    ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Roseaux (lac_roseaux)
vider()
ID = "lac_roseaux"
alea = __import__("random").Random(7)
feuilles = []
for k in range(14):
    a = 2 * math.pi * k / 14 + alea.uniform(-0.2, 0.2)
    h = alea.uniform(2.8, 5.0)
    incl = alea.uniform(0.1, 0.45) * (h / 5)
    f = prisme([(-0.22, 0), (0.22, 0), (0.02, h)], 0.06)
    bmesh.ops.rotate(f, verts=f.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(incl, 3, "X"))
    bmesh.ops.rotate(f, verts=f.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(a, 3, "Z"))
    bmesh.ops.translate(f, vec=(0.35 * math.cos(a), 0.35 * math.sin(a), 0), verts=f.verts)
    feuilles.append(f)
fusion(ID + "_Roseau", "Roseau", feuilles)
tiges, epis, pointes = [], [], []
for (x, y, h) in ((-0.3, 0.1, 4.6), (0.1, -0.2, 5.4), (0.4, 0.2, 4.9)):
    tiges.append(cylindre(0.05, 0.05, h, centre=(x, y, h / 2), seg=5))
    epis.append(cylindre(0.26, 0.26, 1.0, centre=(x, y, h + 0.1), seg=10))
    epis.append(ico(0.26, (x, y, h + 0.6), sub=1))
    epis.append(ico(0.26, (x, y, h - 0.4), sub=1))
    pointes.append(cylindre(0.03, 0.01, 0.6, centre=(x, y, h + 1.1), seg=4))
fusion(ID + "_Noir", "Noir", tiges + pointes)
fusion(ID + "_Brun", "Brun", epis)
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
