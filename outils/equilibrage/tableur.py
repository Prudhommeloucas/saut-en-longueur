# Tableur d'équilibrage (T-201) : génère assets/equilibrage/equilibrage.xlsx et la courbe record / temps
# à partir des modules de configuration (src/shared/Config) et du résultat de la simulation
# (assets/equilibrage/simulation_monde1.json, produit par outils/equilibrage/simulation.luau dans Studio).
# Bibliothèque standard seulement : se lance avec le Python de Blender, sans fenêtre :
#   blender-launcher.exe -b --factory-startup --python assets/modeles/source/lanceur_blender.py -- <journal> outils/equilibrage/tableur.py
import json, math, os, re, zipfile
from xml.sax.saxutils import escape

RACINE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CONFIG = os.path.join(RACINE, "src", "shared", "Config")
SORTIE = os.path.join(RACINE, "assets", "equilibrage")


def lire(nom):
    with open(os.path.join(CONFIG, nom + ".luau"), encoding="utf-8") as f:
        return f.read()


# --- Lecture de la configuration -------------------------------------------------------------
stats_src = lire("Stats")
def constante(nom):
    return float(re.search(r"Stats\." + nom + r"\s*=\s*([\d.]+)", stats_src).group(1))

EXPOSANT, K_V, K_S = constante("EXPOSANT"), constante("K_VITESSE"), constante("K_SAUT")
V0, S0 = constante("VITESSE_PISTE_BASE"), constante("SAUT_PISTE_BASE")
equipement_src = lire("Equipement")
catalogue_src = equipement_src.split("Equipement.CATALOGUE = {", 1)[1].split("} :: {", 1)[0]
catalogue = []
for m in re.finditer(r"\n\t(\w+) = \{(.*?)\}(?=,)", catalogue_src, re.S):
    champs = dict(re.findall(r"(\w+) = (\"[^\"]*\"|[\d.]+)", m.group(2)))
    champs = {k: (v.strip('"') if v.startswith('"') else float(v)) for k, v in champs.items()}
    champs["id"] = m.group(1)
    catalogue.append(champs)
catalogue.sort(key=lambda o: (o["famille"], o["prix"]))
chaussures = next(o["appel"] for o in catalogue if o["id"] == "chaussures_ressorts")
NIVEAU_MAX = int(re.search(r"NIVEAU_MAX = (\d+)", equipement_src).group(1))
BONUS_NIVEAU = float(re.search(r"BONUS_NIVEAU = ([\d.]+)", equipement_src).group(1))
bonus_debutant = re.search(r"BONUS_DEBUTANT = \{ multiplicateur = ([\d.]+), recordFin = ([\d.]+) \}", stats_src)

mondes_src = lire("Mondes")
GRAVITE = float(re.search(r"local GRAVITE = ([\d.]+)", mondes_src).group(1))
mondes = []
for bloc in re.split(r"\n\t\{\n", mondes_src.split("Mondes.LISTE = {", 1)[1])[1:]:
    def champ(n, b=bloc):
        m = re.search(n + r"\s*=\s*([^,\n]+),", b)
        return m.group(1).strip() if m else ""
    acces = re.search(r"acces = \{ monde = (\d+), record = (\d+)(?:, categorie = \"(\w+)\")? \}", bloc)
    zones = re.findall(r"\{ multiplicateur = ([\d.e]+)(?:, recordRequis = (\d+))?(?:, passe = \"(\w+)\")? \}", bloc)
    mondes.append({
        "nom": champ("nom").strip('"'),
        "studsParMetre": champ("studsParMetre"),
        "pieces": champ("pieces"),
        "gravite": champ("gravite").replace("GRAVITE", str(GRAVITE)),
        "plafondVitesse": champ("plafondVitesse"),
        "plafondSaut": champ("plafondSaut"),
        "longueurBac": champ("longueurBac"),
        "acces": (f"record {acces.group(2)} m au monde {acces.group(1)}" + (f", catégorie {acces.group(3)}" if acces.group(3) else "")) if acces else "départ",
        "zones": " ; ".join(
            f"× {float(m):g}" + (f" dès {r} m" if r else "") + (f" ({p})" if p else "") for m, r, p in zones
        ),
    })

sim = json.load(open(os.path.join(SORTIE, "simulation_monde1.json"), encoding="utf-8"))


# Même calcul que Config/Saut.portee (appel Bon, sans jetpack ni anneau)
def portee(vx, vy, gravite=GRAVITE, appel=1.10, spm=4):
    dt, y, t, v = 1 / 120, 0.0, 0.0, vy * appel
    while True:
        v -= gravite * dt
        y += v * dt
        t += dt
        if y < 0 or t > 60:
            break
    return vx * t / spm


def capacites(stat, plafondV=300, plafondS=600, avec_chaussures=True):
    vx = min(V0 + K_V * stat ** EXPOSANT, plafondV)
    vy = min((S0 + K_S * stat ** EXPOSANT) * (chaussures if avec_chaussures else 1), plafondS)
    return vx, vy


# --- Écriture du classeur (SpreadsheetML minimal) --------------------------------------------
def col(i):
    s = ""
    i += 1
    while i:
        i, r = divmod(i - 1, 26)
        s = chr(65 + r) + s
    return s


def feuille(lignes):
    xml = ['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
           '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>']
    for r, ligne in enumerate(lignes, 1):
        xml.append(f'<row r="{r}">')
        for c, v in enumerate(ligne):
            ref = f"{col(c)}{r}"
            if isinstance(v, (int, float)) and not isinstance(v, bool):
                xml.append(f'<c r="{ref}"><v>{v}</v></c>')
            elif v is None or v == "":
                continue
            else:
                style = ' s="1"' if r == 1 else ''
                xml.append(f'<c r="{ref}" t="inlineStr"{style}><is><t>{escape(str(v))}</t></is></c>')
        xml.append("</row>")
    xml.append("</sheetData></worksheet>")
    return "".join(xml)


def classeur(chemin, feuilles):
    noms = list(feuilles)
    with zipfile.ZipFile(chemin, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml",
            '<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
            '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
            '<Default Extension="xml" ContentType="application/xml"/>'
            '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
            '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
            + "".join(f'<Override PartName="/xl/worksheets/sheet{i}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>' for i in range(1, len(noms) + 1))
            + "</Types>")
        z.writestr("_rels/.rels",
            '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>')
        z.writestr("xl/workbook.xml",
            '<?xml version="1.0" encoding="UTF-8"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
            'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>'
            + "".join(f'<sheet name="{escape(n)}" sheetId="{i}" r:id="rId{i}"/>' for i, n in enumerate(noms, 1))
            + "</sheets></workbook>")
        z.writestr("xl/_rels/workbook.xml.rels",
            '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            + "".join(f'<Relationship Id="rId{i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet{i}.xml"/>' for i in range(1, len(noms) + 1))
            + f'<Relationship Id="rId{len(noms) + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'
            + "</Relationships>")
        z.writestr("xl/styles.xml",
            '<?xml version="1.0" encoding="UTF-8"?><styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
            '<fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><name val="Calibri"/></font></fonts>'
            '<fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>'
            '<borders count="1"><border/></borders><cellStyleXfs count="1"><xf/></cellStyleXfs>'
            '<cellXfs count="2"><xf/><xf fontId="1" applyFont="1"/></cellXfs></styleSheet>')
        for i, n in enumerate(noms, 1):
            z.writestr(f"xl/worksheets/sheet{i}.xml", feuille(feuilles[n]))


h = sim["hypotheses"]
lignes_formules = [
    ["Paramètre", "Valeur", "Source"],
    ["Vitesse de course = base + k × Vitesse^p", "", "Config/Stats.vitesseCourse"],
    ["base vitesse (piste)", V0, "Stats.VITESSE_PISTE_BASE"],
    ["k vitesse", K_V, "Stats.K_VITESSE"],
    ["Puissance de saut = (base + k × Puissance^p) × chaussures", "", "Config/Stats.puissanceSaut"],
    ["base saut (piste)", S0, "Stats.SAUT_PISTE_BASE"],
    ["k saut", K_S, "Stats.K_SAUT"],
    ["exposant p", EXPOSANT, "Stats.EXPOSANT"],
    ["appel des semelles à ressorts (niveau 1)", chaussures, "Equipement.CATALOGUE.chaussures_ressorts.appel"],
    ["bonus de débutant (entraînement) au record 0", float(bonus_debutant.group(1)), "Stats.BONUS_DEBUTANT.multiplicateur"],
    ["record où le bonus de débutant s'éteint (m)", float(bonus_debutant.group(2)), "Stats.BONUS_DEBUTANT.recordFin"],
    [],
    ["Stat (les deux)", "Vitesse de course", "Puissance de saut", "Distance (m, appel Bon, chaussures)", "Gain en doublant les deux stats"],
]
for e in range(0, 8):
    stat = 10 ** e
    vx, vy = capacites(stat)
    vx2, vy2 = capacites(stat * 2)
    d, d2 = portee(vx, vy), portee(vx2, vy2)
    lignes_formules.append([stat, round(vx, 1), round(vy, 1), round(d, 1), f"+{(d2 / d - 1) * 100:.0f} %"])
lignes_formules += [[], ["Règle : doubler une stat donne au moins 8 % de distance (relevés de la simulation)"]]
lignes_formules += [[r] for r in sim.get("regle8", [])]

lignes_mondes = [["Monde", "Nom", "Studs par mètre", "Pièces ×", "Gravité", "Plafond vitesse", "Plafond saut", "Longueur du bac (m)", "Accès", "Zones d'entraînement", "Distance au plafond (m)"]]
for i, m in enumerate(mondes, 1):
    try:
        d = portee(float(m["plafondVitesse"]), float(m["plafondSaut"]), float(m["gravite"].split("/")[0]) / (6 if "/" in m["gravite"] else 1), spm=float(m["studsParMetre"]))
    except ValueError:
        d = ""
    lignes_mondes.append([i, m["nom"], float(m["studsParMetre"]), float(m["pieces"]), m["gravite"], float(m["plafondVitesse"]), float(m["plafondSaut"]), float(m["longueurBac"]), m["acces"], m["zones"], round(d) if d else ""])

lignes_hyp = [["Hypothèse du joueur type", "Valeur"],
    ["Durée simulée (min)", h["duree"] / 60],
    ["Appel moyen (multiplicateur)", h["appel"]],
    ["Rythme d'entraînement actif (× passif)", h["rythme"]],
    ["Part du temps à s'entraîner", h["partEntrainement"]],
    ["Durée d'un saut avec retour (s)", h["dureeSaut"]],
    ["Anneaux, sauts rares, compagnons, catégories", "non comptés"],
    [], ["Matériel d'entraînement (Config/Equipement.MATERIEL)", "Multiplicateur", "Prix"]]
lignes_hyp += [[m["nom"], m["multiplicateur"], m["prix"]] for m in h["materiel"]]

lignes_catalogue = [["Famille", "Identifiant", "Nom", "Monde", "Prix"]
                    + [f"Niveau {n}" for n in range(2, NIVEAU_MAX + 1)]
                    + ["Effet au niveau 1", f"Effet au niveau {NIVEAU_MAX}"]]
for o in catalogue:
    niveaux = [round(o["prix"] / 2 * 2 ** (n - 2)) for n in range(2, NIVEAU_MAX + 1)]
    facteur = 1 + BONUS_NIVEAU * (NIVEAU_MAX - 1)
    if "appel" in o:
        effets = [f"appel × {o['appel']:g}", f"appel × {1 + (o['appel'] - 1) * facteur:.2f}"]
    elif "pieces" in o:
        effets = [f"pièces × {o['pieces']:g}", f"pièces × {1 + (o['pieces'] - 1) * facteur:.2f}"]
    else:
        effets = [f"{o['carburant']:g} s de poussée", f"{o['carburant'] * facteur:.2f} s de poussée"]
    lignes_catalogue.append([o["famille"], o["id"], o["nom"], o["monde"], o["prix"]] + niveaux + effets)

lignes_jalons = [["Record (m)", "Temps visé (min)", "Temps simulé (min)", "Écart (min)"]]
for j in sim["jalons"]:
    o = j.get("obtenu")
    lignes_jalons.append([j["record"], j["vise"], o if o is not None else "non atteint", round(o - j["vise"], 1) if o is not None else ""])
lignes_jalons += [[], ["Pire attente entre deux achats pendant la première heure (min)", round(sim["pireAttenteAchat"] / 60, 1)],
                  ["Règle de confort visée (min)", 5]]

lignes_achats = [["Temps (min)", "Événement", "Record (m)", "Attente depuis l'achat précédent (min)"]]
avant = 0
for e in sim["evenements"]:
    attente = ""
    if e["quoi"].startswith("achat"):
        attente = round((e["t"] - avant) / 60, 1)
        avant = e["t"]
    lignes_achats.append([round(e["t"] / 60, 1), e["quoi"], round(e["record"], 1), attente])

lignes_serie = [["Temps (min)", "Record (m)", "Puissance", "Vitesse", "Vitesse de course", "Puissance de saut", "Pièces", "Zone ×", "Matériel"]]
for s in sim["serie"]:
    lignes_serie.append([round(s["t"] / 60, 2), s["record"], s["puissance"], s["vitesse"], s["vx"], s["vy"], s["pieces"], s["zone"], s["materiel"]])

classeur(os.path.join(SORTIE, "equilibrage.xlsx"), {
    "Jalons": lignes_jalons,
    "Simulation": lignes_serie,
    "Achats": lignes_achats,
    "Catalogue": lignes_catalogue,
    "Formules": lignes_formules,
    "Mondes": lignes_mondes,
    "Hypothèses": lignes_hyp,
})

# --- Courbe record / temps (SVG) --------------------------------------------------------------
L, H_, M = 900, 520, 60
tmax = h["duree"] / 60
rmax = max(s["record"] for s in sim["serie"]) * 1.08
def px(t): return M + (L - 2 * M) * t / tmax
def py(r): return H_ - M - (H_ - 2 * M) * r / rmax
pts = " ".join(f"{px(s['t'] / 60):.1f},{py(s['record']):.1f}" for s in sim["serie"])
svg = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {L} {H_}" font-family="Segoe UI, Arial, sans-serif" font-size="13">',
       f'<rect width="{L}" height="{H_}" fill="#ffffff"/>',
       f'<text x="{M}" y="30" font-size="17" font-weight="bold" fill="#16213E">Monde 1 : record en fonction du temps de jeu (simulation T-201)</text>']
for t in range(0, int(tmax) + 1, 15):
    svg.append(f'<line x1="{px(t):.1f}" y1="{M}" x2="{px(t):.1f}" y2="{H_ - M}" stroke="#e6e6e6"/>')
    svg.append(f'<text x="{px(t):.1f}" y="{H_ - M + 18}" text-anchor="middle" fill="#555">{t} min</text>')
pas = 25 if rmax < 300 else 50
for r in range(0, int(rmax) + 1, pas):
    svg.append(f'<line x1="{M}" y1="{py(r):.1f}" x2="{L - M}" y2="{py(r):.1f}" stroke="#e6e6e6"/>')
    svg.append(f'<text x="{M - 8}" y="{py(r) + 4:.1f}" text-anchor="end" fill="#555">{r} m</text>')
svg.append(f'<polyline points="{pts}" fill="none" stroke="#1E90FF" stroke-width="3"/>')
for j in sim["jalons"]:
    x, y = px(j["vise"]), py(j["record"])
    svg.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="6" fill="#FF7A1A"/>')
    svg.append(f'<text x="{x + 9:.1f}" y="{y - 7:.1f}" fill="#C8552D">{j["record"]} m visé à {j["vise"]} min</text>')
for e in sim["evenements"]:
    if e["quoi"].startswith("zone"):
        x = px(e["t"] / 60)
        svg.append(f'<line x1="{x:.1f}" y1="{M}" x2="{x:.1f}" y2="{H_ - M}" stroke="#2BB673" stroke-dasharray="5,4"/>')
        svg.append(f'<text x="{x + 4:.1f}" y="{M + 14}" fill="#2BB673">{escape(e["quoi"])}</text>')
svg.append(f'<line x1="{L - 290}" y1="{H_ - 18}" x2="{L - 260}" y2="{H_ - 18}" stroke="#1E90FF" stroke-width="3"/><text x="{L - 254}" y="{H_ - 14}">simulé</text>')
svg.append(f'<circle cx="{L - 190}" cy="{H_ - 18}" r="6" fill="#FF7A1A"/><text x="{L - 180}" y="{H_ - 14}">visé (Boucles de gameplay)</text>')
svg.append("</svg>")
with open(os.path.join(SORTIE, "courbe_record_monde1.svg"), "w", encoding="utf-8") as f:
    f.write("\n".join(svg))

JOURNAL = __import__("sys").argv[__import__("sys").argv.index("--") + 1] if "--" in __import__("sys").argv else None
if JOURNAL:
    open(JOURNAL, "w", encoding="utf-8").write("FIN\n" + "\n".join(str(l) for l in lignes_mondes) + "\n" + "\n".join(str(l) for l in lignes_formules[12:21]))
