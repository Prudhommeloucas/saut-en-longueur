-- Caméra : le champ de vision s'élargit avec la vitesse ; elle recule pendant le vol au-dessus du sable.
return {
	FOV_BASE = 70,
	FOV_MAX = 100,
	RECUL_VOL = 24, -- studs : distance minimale de la caméra pendant le vol (T-102)
	RECUL_RAPIDITE = 3, -- vitesse à laquelle elle recule puis revient
}
