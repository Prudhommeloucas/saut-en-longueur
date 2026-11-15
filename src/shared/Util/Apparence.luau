-- Apparence : applique à un compagnon cloné l'aspect de sa version (Argent, Or), d'après ReplicatedStorage.Assets.Versions.
-- Voir Réalisation/Contrats.md, « Versions Argent et Or ».
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Apparence = {}

function Apparence.appliquerVersion(modele: Model, version: string)
	if version == "Normal" then
		return
	end
	local versions = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Versions")
	local recette = versions:FindFirstChild(version)
	if not recette then
		return
	end
	local garder = {}
	for nom in string.gmatch(recette:GetAttribute("Garder") or "", "[^,]+") do
		garder[nom] = true
	end
	local couleur = recette:GetAttribute("Couleur")
	local melange = recette:GetAttribute("Melange") or 0
	local matiere = Enum.Material[recette:GetAttribute("Matiere") or "Metal"]
	for _, p in modele:GetDescendants() do
		if
			p:IsA("BasePart")
			and not garder[p.Name]
			and p.Material ~= Enum.Material.Neon
			and p.Material ~= Enum.Material.Glass
		then
			p.Color = p.Color:Lerp(couleur, melange)
			p.Material = matiere
		end
	end

	-- Médaille au cou, posée sur l'attachment « Cou » du compagnon
	local cou = modele.PrimaryPart and modele.PrimaryPart:FindFirstChild("Cou")
	local modeleMedaille = versions:FindFirstChild(recette:GetAttribute("Medaille") or "")
	if cou and modeleMedaille then
		local medaille = modeleMedaille:Clone()
		local accroche = medaille.PrimaryPart:FindFirstChild("Accroche")
		medaille:PivotTo(cou.WorldCFrame * accroche.CFrame:Inverse())
		local w = Instance.new("WeldConstraint")
		w.Part0 = modele.PrimaryPart
		w.Part1 = medaille.PrimaryPart
		w.Parent = medaille.PrimaryPart
		medaille.Parent = modele
	end
end

return Apparence
