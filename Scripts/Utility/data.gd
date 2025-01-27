extends Node

enum hex_ids {BLANK, WIRE, BATTERY, GENERATOR, MINIGUN, SNIPER, LASER, MANUAL}

var cost = [0, 5, 50, 100, 50, 100, 150, 50]

const TILE_MAP_LAYER = 0
const TILE_MAP_ATLAS_ID = 0

var weapon_stats = {
	"minigun": {
		"damage": 3.0,
		"charge": 5.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
	},
	"sniper": {
		"damage": 10.0,
		"charge": 20.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
	},
	"manual": {
		"damage": 10.0,
		"charge": 20.0
	},
	"laser": {
		"damage": 1.0,
		"charge": 1.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
	}
}
