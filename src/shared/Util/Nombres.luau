-- Nombres : un seul endroit pour afficher les grands nombres (T-201, note Économie).
-- abreger(1234) → « 1,2 K » ; 3,4 M ; 5,6 Md ; puis notation en lettres : aa, ab… (× 1 000 à chaque fois).
-- Les classements ordonnés de Roblox n'acceptent que des entiers : distances en centimètres.
local Nombres = {}

local SUFFIXES = { "K", "M", "Md" }

-- Suffixe du rang r (1 = mille) : K, M, Md, puis aa, ab… az, ba…
local function suffixe(r: number): string
	if r <= #SUFFIXES then
		return SUFFIXES[r]
	end
	local i = r - #SUFFIXES - 1 -- 0 pour « aa »
	local a = string.byte("a")
	return string.char(a + (i // 26) % 26) .. string.char(a + i % 26)
end

-- Écrit x avec au plus `decimales` chiffres après la virgule, sans zéros inutiles, virgule française
local function decimal(x: number, decimales: number): string
	local s = string.format("%." .. decimales .. "f", x)
	if decimales > 0 then
		s = s:gsub("0+$", ""):gsub("%.$", "")
	end
	return (s:gsub("%.", ","))
end

-- Nombre abrégé pour l'affichage : « 999 », « 1,2 K », « 45,6 M », « 7,8 aa »
function Nombres.abreger(n: number, decimales: number?): string
	if n ~= n then
		return "0"
	end
	local signe = if n < 0 then "-" else ""
	n = math.abs(n)
	if n < 1000 then
		return signe .. decimal(math.floor(n * 10 + 0.5) / 10, if n < 100 then 1 else 0)
	end
	local rang = math.floor(math.log10(n) / 3)
	local x = n / 10 ^ (3 * rang)
	if x >= 999.95 then -- 999 950 s'écrit 1 M et non 1 000 K
		rang += 1
		x /= 1000
	end
	return signe .. decimal(x, decimales or (if x < 100 then 1 else 0)) .. " " .. suffixe(rang)
end

-- Distance affichée : « 8,4 m », « 1,25 km » au-delà de 1 000 m
function Nombres.distance(metres: number): string
	if metres >= 1000 then
		return decimal(metres / 1000, 2) .. " km"
	end
	return decimal(metres, 1) .. " m"
end

-- Clé entière d'un classement de distances : centimètres, puis un logarithme au-delà de 2^50 cm (entiers exacts)
Nombres.LIMITE_CM = 2 ^ 50
function Nombres.cleDistance(metres: number): number
	local cm = math.floor(math.max(metres, 0) * 100)
	if cm < Nombres.LIMITE_CM then
		return cm
	end
	-- au-delà : la limite, plus le logarithme du dépassement (×1000 pour garder l'ordre fin)
	return Nombres.LIMITE_CM + math.floor(math.log10(cm / Nombres.LIMITE_CM) * 1000)
end

return Nombres
