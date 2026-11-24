# T-116 : dirigeable, canon à confettis, lanceur de feux d'artifice, drapeau du vent, construits par script dans Blender (sans fenêtre).
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
    "Gris": "#5B6577", "CielClair": "#BEE6FF", "Ardoise": "#3A3F48", "Fond": "#2B2F38",
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

def poteau(p0, p1, r, seg=8):
    p0, p1 = Vector(p0), Vector(p1)
    d = p1 - p0
    bm = cylindre(r, r, d.length, seg=seg)
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=d.to_track_quat("Z", "Y").to_matrix())
    bmesh.ops.translate(bm, vec=(p0 + p1) / 2, verts=bm.verts)
    return bm

def coucher(bm, z_centre):
    # construit le long de Z, couché le long de Y, nez vers -Y, puis monté à z_centre
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(math.pi / 2, 3, "X"))
    bmesh.ops.translate(bm, vec=(0, 0, z_centre), verts=bm.verts)
    return bm

# ---------------------------------------------------------------- Dirigeable (stade_dirigeable)
# Long de 60 selon Y, nez vers -Y. Hélices (« Helice_* ») séparées. Origine sous la nacelle.
vider()
ID = "stade_dirigeable"
ZC = 13.0
corps = ico(1.0, (0, 0, 0), sub=3, echelle=(10, 10, 30))
for v in corps.verts:
    if v.co.z > 0:
        v.co.x *= 1 + 0.08 * v.co.z / 30
        v.co.y *= 1 + 0.08 * v.co.z / 30
fusion(ID + "_Orange", "Orange", [coucher(corps, ZC)])
bandes = []
for (z0, z1) in ((-24, -20), (-12, -8), (6, 10), (18, 22)):
    b = ico(1.0, (0, 0, 0), sub=3, echelle=(10.15, 10.15, 30.15))
    for v in b.verts:
        if v.co.z > 0:
            v.co.x *= 1 + 0.08 * v.co.z / 30
            v.co.y *= 1 + 0.08 * v.co.z / 30
    bandes.append(coucher(tranche(b, z0, z1), ZC))
fusion(ID + "_Blanc", "Blanc", bandes + [boite(0.5, 24, 6, centre=(s * 10.6, 1, ZC + 1), biseau=0.4, segments=2) for s in (-1, 1)])
fusion(ID + "_Bleu", "Bleu", [
    boite(0.4, 25.4, 7.4, centre=(s * 10.4, 1, ZC + 1), biseau=0.5, segments=2) for s in (-1, 1)
] + [
    boite(9, 14, 5, centre=(0, 0, 2.5), biseau=1.6, segments=3),
    boite(1.2, 9, 8, centre=(0, 26, ZC + 6), biseau=0.4, segments=2),
    boite(1.2, 9, 8, centre=(0, 26, ZC - 6), biseau=0.4, segments=2),
    boite(8, 9, 1.2, centre=(6, 26, ZC), biseau=0.4, segments=2),
    boite(8, 9, 1.2, centre=(-6, 26, ZC), biseau=0.4, segments=2),
])
fusion(ID + "_Pointes_Blanc", "Blanc", [
    boite(1.3, 3, 2, centre=(0, 29.5, ZC + 9.5), biseau=0.4, segments=2),
    boite(1.3, 3, 2, centre=(0, 29.5, ZC - 9.5), biseau=0.4, segments=2),
    boite(2, 3, 1.3, centre=(9.5, 29.5, ZC), biseau=0.4, segments=2),
    boite(2, 3, 1.3, centre=(-9.5, 29.5, ZC), biseau=0.4, segments=2),
])
fusion(ID + "_CielClair", "CielClair", [ico(0.8, (s * 4.4, y, 2.8), sub=1, echelle=(0.4, 1, 1)) for s in (-1, 1) for y in (-4, 0, 4)])
fusion(ID + "_Or", "Or", [ico(2.2, (0, -31.5, ZC), sub=2, echelle=(1, 1.3, 1))])
fusion(ID + "_Gris", "Gris", [poteau((s * 4.4, 4, 2.5), (s * 8.5, 4, 1.5), 0.35) for s in (-1, 1)])
for s in (-1, 1):
    pales = [ico(0.6, (s * 8.5, 4, 1.5), sub=1)]
    for k in range(3):
        a = k * 2 * math.pi / 3
        pale = ico(1.0, (0, 0, 0), sub=1, echelle=(0.6, 0.25, 2.2))
        bmesh.ops.translate(pale, vec=(0, 0, 2.0), verts=pale.verts)
        bmesh.ops.rotate(pale, verts=pale.verts, cent=(0, 0, 0), matrix=Matrix.Rotation(a, 3, "Y"))
        bmesh.ops.translate(pale, vec=(s * 8.5, 4.6, 1.5), verts=pale.verts)
        pales.append(pale)
    fusion(ID + ("_HeliceG_Or" if s < 0 else "_HeliceD_Or"), "Or", pales)
for ob in bpy.context.scene.objects:
    if ob.name.endswith(("_Orange", "_Blanc")):
        ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Canon à confettis (stade_canon)
# Le fût (« Fut_* ») vise l'avant (-Y) à 45°, séparé. Origine au sol.
vider()
ID = "stade_canon"
fusion(ID + "_Orange", "Orange", [cylindre(1.55, 1.45, 0.8, centre=(0, 0, 0.55), seg=24)])
fusion(ID + "_Or", "Or", [cylindre(1.75, 1.75, 0.22, centre=(0, 0, 0.11), seg=24)] + [ico(0.32, (s * 0.95, 0, 1.75), sub=2) for s in (-1, 1)])
fusion(ID + "_Bleu", "Bleu", [boite(0.3, 0.9, 1.2, centre=(s * 0.95, 0, 1.4), biseau=0.12, segments=2) for s in (-1, 1)])
inclin = Matrix.Rotation(math.radians(45), 3, "X")
def fut(r1, r2, h, z):
    bm = cylindre(r1, r2, h, centre=(0, 0, z), seg=20)
    bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=inclin)
    bmesh.ops.translate(bm, vec=(0, 0, 1.75), verts=bm.verts)
    return bm
fusion(ID + "_Fut_Bleu", "Bleu", [fut(0.78, 0.7, 2.4, 0.6), ico(0.78, (0, 0, 0), sub=2)])
fusion(ID + "_Fut_Or", "Or", [fut(0.82, 0.82, 0.22, 0.3), fut(0.78, 0.78, 0.22, 1.2)])
fusion(ID + "_Fut_Blanc", "Blanc", [fut(0.98, 0.98, 0.55, 1.95)])
fusion(ID + "_Fut_Fond", "Fond", [fut(0.62, 0.62, 0.05, 2.24)])
for ob in bpy.context.scene.objects:
    ob["lisse"] = True
finir(ID)

# ---------------------------------------------------------------- Lanceur de feux d'artifice (stade_lanceur)
vider()
ID = "stade_lanceur"
fusion(ID + "_Ardoise", "Nuit", [boite(3.0, 2.0, 0.8, centre=(0, 0, 0.4), biseau=0.25, segments=2)])
tubes, bagues, fonds = [], [], []
for (x, y, h, ax) in ((-0.75, 0.2, 2.0, -6), (0.0, -0.25, 2.6, 0), (0.75, 0.2, 2.2, 6)):
    rot = Matrix.Rotation(math.radians(ax), 3, "Y")
    def place(bm):
        bmesh.ops.rotate(bm, verts=bm.verts, cent=(0, 0, 0), matrix=rot)
        bmesh.ops.translate(bm, vec=(x, y, 0.8), verts=bm.verts)
        return bm
    tubes.append(place(cylindre(0.42, 0.42, h, centre=(0, 0, h / 2), seg=14)))
    bagues.append(place(cylindre(0.5, 0.5, 0.25, centre=(0, 0, h - 0.05), seg=14)))
    fonds.append(place(cylindre(0.3, 0.3, 0.04, centre=(0, 0, h + 0.09), seg=12)))
fusion(ID + "_Gris", "Gris", tubes)
fusion(ID + "_Orange", "Orange", bagues)
fusion(ID + "_Fond", "Fond", fonds)
finir(ID)

# ---------------------------------------------------------------- Drapeau du vent (stade_drapeau_vent)
# Le drapeau (« Drapeau_* ») est séparé, tendu vers +X, attaché au mât en x = 0.
vider()
ID = "stade_drapeau_vent"
fusion(ID + "_Gris", "Gris", [cylindre(0.2, 0.2, 12, centre=(0, 0, 6.2), seg=10), ico(0.9, (0, 0, 0), sub=2, echelle=(1, 1, 0.45))])
fusion(ID + "_Or", "Or", [ico(0.45, (0, 0, 12.4), sub=2)])
x0, x1, zb, zh = 0.2, 5.2, 8.7, 11.7
fusion(ID + "_Drapeau_Orange", "Orange", [prisme([(x0, zh), (x1, zh), (x0, zb)], 0.12)])
fusion(ID + "_Drapeau_Blanc", "Blanc", [prisme([(x1, zh), (x1, zb), (x0, zb)], 0.12)])
finir(ID)

if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("\n".join(lignes) + "\nFIN\n")
