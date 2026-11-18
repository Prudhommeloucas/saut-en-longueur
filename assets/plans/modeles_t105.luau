-- T-105, après construction_t105.luau : remplace les blocs de l'arche, des panneaux et du tunnel
-- par les vrais modèles de ReplicatedStorage.Assets.Decor (préparés : couleurs, pivot au sol, avant vers -Z local,
-- collisions simples, textes sur les plaques). Les blocs sont rangés dans ServerStorage.Modeles.BlocsT105.
local CHS = game:GetService("ChangeHistoryService")
local rec = CHS:TryBeginRecording("T-105 vrais modèles du stade")
local m = workspace.Mondes.Monde1
local decor = game.ReplicatedStorage.Assets.Decor
local stock = game:GetService("ServerStorage").Modeles.BlocsT105
local function dossier(parent, nom)
	local d = parent:FindFirstChild(nom)
	if not d then
		d = Instance.new("Folder")
		d.Name = nom
		d.Parent = parent
	end
	return d
end
local VERS_MOINS_X = CFrame.Angles(0, math.pi / 2, 0) -- l'avant (-Z local) regarde vers -X, la largeur suit Z

for _, c in m.Piste.Arche:GetChildren() do
	c.Parent = dossier(stock, "ArcheBlocs")
end
local arche = decor.stade_arche:Clone()
arche.Name = "Arche"
arche:PivotTo(CFrame.new(0, 0, 0) * VERS_MOINS_X)
arche.Parent = m.Piste.Arche

for _, c in m.Bac.Panneaux:GetChildren() do
	c.Parent = dossier(stock, "PanneauxBlocs")
end
for metres = 10, 90, 10 do
	local p = (metres == 50 and decor.stade_panneau_grand or decor.stade_panneau_petit):Clone()
	p.Name = "Panneau" .. metres
	for _, l in p:GetDescendants() do
		if l:IsA("TextLabel") then
			l.Text = metres .. " m"
		end
	end
	p:PivotTo(CFrame.new(120 + metres * 4, 0, -24) * VERS_MOINS_X)
	p.Parent = m.Bac.Panneaux
end

for _, c in m.Bac.Tunnel:GetChildren() do
	c.Parent = dossier(stock, "TunnelBlocs")
end
local tunnel = decor.stade_tunnel:Clone()
tunnel.Name = "Tunnel"
tunnel:PivotTo(CFrame.new(520, 0, 0) * VERS_MOINS_X)
tunnel.Parent = m.Bac.Tunnel

if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
return "Arche, 9 panneaux et tunnel posés"
