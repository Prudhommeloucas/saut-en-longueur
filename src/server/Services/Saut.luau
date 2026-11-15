-- Saut : le premier contact avec le sable donne la distance ; effets d'atterrissage ; flammes du jetpack.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local Sons = require(Config:WaitForChild("Sons"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Donnees = require(script.Parent.Donnees)
local Personnage = require(script.Parent.Personnage)

local Saut = {}

local enAtterrissage = {} -- [player] = true entre l'atterrissage et le retour piste

-- Gerbe de sable à l'atterrissage, confettis et fanfare en cas de record
local function effetAtterrissage(position: Vector3, estRecord: boolean)
	local p = Instance.new("Part")
	p.Name = "EffetAtterrissage"
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Transparency = 1
	p.Size = Vector3.new(3, 0.2, 3)
	p.Position = Vector3.new(position.X, 0.2, position.Z)

	local s = Instance.new("ParticleEmitter")
	s.Texture = "rbxasset://textures/particles/smoke_main.dds"
	s.Enabled = false
	s.EmissionDirection = Enum.NormalId.Top
	s.Color = ColorSequence.new(Color3.fromRGB(232, 205, 140))
	s.Lifetime = NumberRange.new(0.6, 1.1)
	s.Speed = NumberRange.new(12, 26)
	s.SpreadAngle = Vector2.new(55, 55)
	s.Acceleration = Vector3.new(0, -50, 0)
	s.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 3.5) })
	s.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	s.Parent = p

	local son = Instance.new("Sound")
	son.SoundId = Sons.Atterrissage
	son.Volume = 1.5
	son.RollOffMaxDistance = 200
	son.Parent = p

	local confettis, fanfare
	if estRecord then
		confettis = Instance.new("ParticleEmitter")
		confettis.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		confettis.Enabled = false
		confettis.EmissionDirection = Enum.NormalId.Top
		confettis.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 170, 255)),
		})
		confettis.LightEmission = 0.7
		confettis.Lifetime = NumberRange.new(1.5, 2.5)
		confettis.Speed = NumberRange.new(25, 45)
		confettis.SpreadAngle = Vector2.new(35, 35)
		confettis.Acceleration = Vector3.new(0, -40, 0)
		confettis.Size = NumberSequence.new(1.2)
		confettis.Parent = p
		fanfare = Instance.new("Sound")
		fanfare.SoundId = Sons.Record
		fanfare.Volume = 0.8
		fanfare.RollOffMaxDistance = 200
		fanfare.Parent = p
	end

	p.Parent = workspace
	s:Emit(35)
	son:Play()
	if confettis then
		confettis:Emit(70)
		fanfare:Play()
	end
	Debris:AddItem(p, 6)
end

local function surContactSable(hit: BasePart)
	local char = hit:FindFirstAncestorOfClass("Model")
	local player = char and Players:GetPlayerFromCharacter(char)
	if not player or not Donnees.estCharge(player) or enAtterrissage[player] then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health <= 0 then
		return
	end
	enAtterrissage[player] = true

	local metres = math.max(0, hrp.Position.X - SautConfig.LIGNE_X) / SautConfig.STUDS_PAR_METRE
	metres = math.floor(metres * 10 + 0.5) / 10
	local gain = math.floor(metres * SautConfig.PIECES_PAR_METRE)
	local ls = player.leaderstats
	ls["Pièces"].Value += gain

	local estRecord = metres > player:GetAttribute("Record")
	if estRecord then
		player:SetAttribute("Record", metres)
		ls["Record (m)"].Value = math.floor(metres)
	end
	Remotes.SautResultat:FireClient(player, metres, gain, estRecord)
	effetAtterrissage(hrp.Position, estRecord)
	Personnage.activerJetpack(char, false)

	task.delay(SautConfig.DELAI_RETOUR, function()
		if player.Parent and player.Character == char and char.Parent then
			local p = SautConfig.RETOUR_PISTE
			char:PivotTo(CFrame.lookAt(p, p + Vector3.xAxis))
		end
		enAtterrissage[player] = nil
	end)
end

function Saut.demarrer()
	local sable = workspace:WaitForChild("Map"):WaitForChild("Sable")
	sable.Touched:Connect(surContactSable)

	-- Jetpack : le client signale quand il pousse, le serveur montre les flammes à tous
	Remotes.JetpackEtat.OnServerEvent:Connect(function(player, actif)
		if type(actif) ~= "boolean" or not player:GetAttribute("Jetpack") then
			return
		end
		local char = player.Character
		if char then
			Personnage.activerJetpack(char, actif)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		enAtterrissage[player] = nil
	end)
end

return Saut
