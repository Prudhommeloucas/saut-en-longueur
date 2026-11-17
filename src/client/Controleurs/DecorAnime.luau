-- Décor animé : chaque Part ou Model tagué « DecorAnime » bouge seul, côté joueur seulement.
-- Attributs : Type (Rotation, Flottement, Balancement, Pulsation), Vitesse, Amplitude, AxeRotation (voir Config/Decor).
-- L'objet bouge autour de son pivot. Mouvements en sinus (accélération et ralenti), objets voisins décalés dans le temps,
-- rien ne bouge au-delà de Config/Decor.DISTANCE de la caméra. Les changements ne sont pas envoyés au serveur.
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Decor"))

local DecorAnime = {}

type Anime = {
	objet: Instance,
	type: string,
	base: CFrame, -- pivot de départ
	taille: Vector3?, -- taille de départ (Part en Pulsation)
	echelle: number?, -- échelle de départ (Model en Pulsation)
	vitesse: number,
	amplitude: number,
	axe: Vector3,
	phase: number, -- décalage dans le temps, propre à chaque objet
}

local animes: { [Instance]: Anime } = {}

local function attribut(objet: Instance, nom: string, defaut: any): any
	local v = objet:GetAttribute(nom)
	if v == nil then
		return defaut
	end
	return v
end

local function pivot(objet: Instance): CFrame
	return (objet :: any):GetPivot()
end

local function brancher(objet: Instance)
	if animes[objet] or not (objet:IsA("BasePart") or objet:IsA("Model")) or not objet:IsDescendantOf(workspace) then
		return
	end
	local typ = objet:GetAttribute("Type")
	local defauts = typ and Config.TYPES[typ]
	if not defauts then
		warn("DecorAnime : type inconnu sur", objet:GetFullName(), typ)
		return
	end
	local base = pivot(objet)
	local axe = attribut(objet, "AxeRotation", defauts.AxeRotation or Vector3.yAxis)
	-- Décalage dans le temps tiré de la position : deux objets voisins ne bougent pas à l'unisson
	local p = base.Position
	local phase = ((p.X * 0.137 + p.Z * 0.071 + p.Y * 0.053) % 1) * math.pi * 2
	animes[objet] = {
		objet = objet,
		type = typ,
		base = base,
		taille = if objet:IsA("BasePart") then objet.Size else nil,
		echelle = if objet:IsA("Model") then objet:GetScale() else nil,
		vitesse = attribut(objet, "Vitesse", defauts.Vitesse or 1),
		amplitude = attribut(objet, "Amplitude", defauts.Amplitude or 0),
		axe = if axe.Magnitude > 0 then axe.Unit else Vector3.yAxis,
		phase = phase,
	}
end

local function debrancher(objet: Instance)
	animes[objet] = nil
end

local function placer(a: Anime, cf: CFrame)
	(a.objet :: any):PivotTo(cf)
end

local function animer(a: Anime, t: number)
	local onde = math.sin(t * a.vitesse * math.pi * 2 + a.phase)
	if a.type == "Rotation" then
		local angle = math.rad(a.vitesse * t) + a.phase
		placer(a, a.base * CFrame.fromAxisAngle(a.axe, angle))
	elseif a.type == "Flottement" then
		placer(a, a.base + Vector3.yAxis * (a.amplitude * onde))
	elseif a.type == "Balancement" then
		placer(a, a.base * CFrame.fromAxisAngle(a.axe, math.rad(a.amplitude * onde)))
	elseif a.type == "Pulsation" then
		local facteur = 1 + a.amplitude * onde
		local objet = a.objet
		if objet:IsA("BasePart") and a.taille then
			objet.Size = a.taille * facteur
			objet:PivotTo(a.base)
		elseif objet:IsA("Model") and a.echelle then
			objet:ScaleTo(a.echelle * facteur)
			objet:PivotTo(a.base)
		end
	end
end

function DecorAnime.demarrer()
	CollectionService:GetInstanceAddedSignal("DecorAnime"):Connect(brancher)
	CollectionService:GetInstanceRemovedSignal("DecorAnime"):Connect(debrancher)
	-- Ces deux signaux suivent aussi le streaming : un objet tagué chargé ou déchargé arrive ou part ici
	for _, objet in CollectionService:GetTagged("DecorAnime") do
		brancher(objet)
	end

	local distance2 = Config.DISTANCE * Config.DISTANCE
	RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		local oeil = camera.CFrame.Position
		local t = os.clock()
		for _, a in animes do
			local d = a.base.Position - oeil
			if d:Dot(d) <= distance2 then
				animer(a, t)
			end
		end
	end)
end

return DecorAnime
