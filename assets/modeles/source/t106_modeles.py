# T-106 : anneau, écran géant, projecteur et spectateur, construits par script dans Blender (sans fenêtre).
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
    "Gris": "#5B6577", "Creme": "#FFF8E7", "Corps": "#1E90FF", "Peau": "#F2C9A0",
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

# ---------------------------------------------------------------- 1. Anneau
vider()
ID = "stade_anneau"
R_MOY, R_SEC = 5.75, 0.95  # rayon intérieur 4,8, extérieur 6,7 ; épaisseur 1,5 (écrasé en Y)
fusion(ID + "_Or", "Or", [tore(R_MOY, R_SEC, seg=32, segmin=8, ecrase=0.8)])["lisse"] = True
# liseré blanc sur la face avant, et quatre flèches blanches pointées vers l'extérieur
morceaux = [tore(R_MOY, 0.16, seg=32, segmin=6, centre=(0, -0.78, 0))]
for k in range(4):
    a = k * math.pi / 2
    rot = Matrix.Rotation(-a, 3, "Y")
    tige = boite(0.55, 0.55, 0.8, centre=(0, 0, 0), biseau=0.08, segments=1)
    bmesh.ops.translate(tige, vec=Vector((0, 0, 6.9)), verts=tige.verts)
    pointe = cylindre(0.75, 0.0, 0.9, centre=(0, 0, 7.7), seg=4)
    for bm in (tige, pointe):
        bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=rot)
        morceaux.append(bm)
fusion(ID + "_Blanc", "Blanc", morceaux)
finir(ID)

# ---------------------------------------------------------------- 2. Écran géant
vider()
ID = "stade_ecran"
LARGE, HAUT, PROF, PIED = 30.0, 16.0, 2.0, 3.0
ZC = PIED + 0.4 + HAUT / 2  # pieds de 3 + liseré
# cadre : 4 barres arrondies (le centre reste vide pour les deux écrans)
e = 1.2
cadre = [
    boite(LARGE, PROF, e, centre=(0, 0, ZC + HAUT / 2 - e / 2), biseau=0.4),
    boite(LARGE, PROF, e, centre=(0, 0, ZC - HAUT / 2 + e / 2), biseau=0.4),
    boite(e, PROF, HAUT - 2 * e + 0.2, centre=(-LARGE / 2 + e / 2, 0, ZC), biseau=0.4),
    boite(e, PROF, HAUT - 2 * e + 0.2, centre=(LARGE / 2 - e / 2, 0, ZC), biseau=0.4),
]
fusion(ID + "_Bleu", "Bleu", cadre)
# écran : une plaque sombre légèrement en retrait des deux côtés
fusion(ID + "_Nuit", "Nuit", [boite(LARGE - 2 * e + 0.2, PROF - 0.5, HAUT - 2 * e + 0.2, centre=(0, 0, ZC))])
# blason : étoile arrondie et deux ailes, liseré sous le cadre
etoile = bmesh.new()
pts = []
for k in range(10):
    a = math.pi / 2 + k * math.pi / 5
    r = 2.0 if k % 2 == 0 else 0.95
    pts.append((r * math.cos(a), r * math.sin(a)))
avant = [etoile.verts.new((x, -0.45, z)) for x, z in pts]
arriere = [etoile.verts.new((x, 0.45, z)) for x, z in pts]
etoile.faces.new(avant[::-1]); etoile.faces.new(arriere)
for k in range(10):
    etoile.faces.new((avant[k], avant[(k + 1) % 10], arriere[(k + 1) % 10], arriere[k]))
bmesh.ops.translate(etoile, vec=Vector((0, 0, ZC + HAUT / 2 + 1.5)), verts=etoile.verts)
ailes = []
for s in (-1, 1):
    for i, (lg, dz) in enumerate(((4.2, 0.9), (3.4, 0.0), (2.4, -0.8))):
        b = boite(lg, 0.6, 0.7, biseau=0.25, segments=1)
        bmesh.ops.rotate(b, verts=b.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(s * math.radians(-18), 3, "Y"))
        bmesh.ops.translate(b, vec=Vector((s * (1.6 + lg / 2), 0, ZC + HAUT / 2 + 1.2 + dz * 0.6)), verts=b.verts)
        ailes.append(b)
lisere = boite(LARGE - 3, PROF - 0.6, 0.4, centre=(0, 0, PIED + 0.2), biseau=0.1, segments=1)
fusion(ID + "_Or", "Or", [etoile] + ailes + [lisere])
# pieds
pieds = []
for s in (-1, 1):
    pieds.append(cylindre(0.55, 0.55, PIED, centre=(s * 9, 0, PIED / 2), seg=12))
    pieds.append(cylindre(1.3, 1.3, 0.35, centre=(s * 9, 0, 0.175), seg=16))
fusion(ID + "_Gris", "Gris", pieds)
finir(ID)

# ---------------------------------------------------------------- 3. Projecteur
vider()
ID = "stade_projecteur"
H_MAT = 45.0
ZT = H_MAT + 3.0  # centre de la tête (axe de la charnière)
fusion(ID + "_Gris", "Gris", [
    cylindre(2.4, 2.4, 0.5, centre=(0, 0, 0.25), seg=20),
    cylindre(1.05, 0.7, H_MAT, centre=(0, 0, H_MAT / 2 + 0.5), seg=16),
])
fusion(ID + "_Bleu", "Bleu", [
    cylindre(1.05, 1.05, 0.7, centre=(0, 0, 15), seg=16),
    cylindre(0.92, 0.92, 0.7, centre=(0, 0, 30), seg=16),
])
# charnière en U (fixe, sur le mât) : traverse + deux bras + deux pivots
charniere = [
    boite(5.2, 0.9, 0.7, centre=(0, 0, H_MAT + 0.35 + 0.5), biseau=0.15, segments=1),
]
for s in (-1, 1):
    charniere.append(boite(0.7, 0.9, 2.6, centre=(s * 2.25, 0, H_MAT + 2.0), biseau=0.15, segments=1))
    charniere.append(cylindre(0.55, 0.55, 0.5, centre=(s * 2.75, 0, ZT), seg=12, rot=Matrix.Rotation(math.pi / 2, 3, "Y")))
fusion(ID + "_Charniere", "Or", charniere)
# tête (pièce à orienter) : boîte arrondie, entre les bras de la charnière, plus le chapeau doré
fusion(ID + "_Tete", "Nuit", [boite(12, 2.5, 7, centre=(0, 0, ZT + 1.8), biseau=0.8, segments=2)])
fusion(ID + "_Chapeau", "Or", [cylindre(0.6, 0.6, 0.6, centre=(0, 0, ZT + 1.8 + 3.8), seg=12)])
# face des lampes : 2 rangs de 4, cerclages dorés
lampes, cerclages = [], []
rx = Matrix.Rotation(math.pi / 2, 3, "X")
for i in range(4):
    for j in range(2):
        x = -4.2 + i * 2.8
        z = ZT + 1.8 + (1.45 if j == 0 else -1.45)
        lampes.append(cylindre(1.05, 1.05, 0.25, centre=(x, -1.35, z), seg=14, rot=rx))
        cerclages.append(tore(1.15, 0.16, seg=14, segmin=4, centre=(x, -1.3, z)))
fusion(ID + "_Lampe", "Creme", lampes)
fusion(ID + "_Cerclages", "Or", cerclages)
finir(ID)

# ---------------------------------------------------------------- 4. Spectateur (moins de 60 triangles)
vider()
ID = "stade_spectateur"
corps = boite(1.6, 1.2, 1.8, centre=(0, 0, 0.9))
# tronc un peu plus étroit en haut
for v in corps.verts:
    if v.co.z > 1.0:
        v.co.x *= 0.85
bras = []
for s in (-1, 1):
    b = boite(0.45, 0.45, 1.5)
    bmesh.ops.rotate(b, verts=b.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(s * math.radians(28), 3, "Y"))
    bmesh.ops.translate(b, vec=Vector((s * 0.95, 0, 2.15)), verts=b.verts)
    bras.append(b)
fusion(ID + "_Corps", "Corps", [corps] + bras)
tete = bmesh.new()
bmesh.ops.create_uvsphere(tete, u_segments=8, v_segments=5, radius=0.8)
bmesh.ops.translate(tete, vec=Vector((0, 0, 2.6)), verts=tete.verts)
fusion(ID + "_Peau", "Peau", [tete])["lisse"] = True
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
