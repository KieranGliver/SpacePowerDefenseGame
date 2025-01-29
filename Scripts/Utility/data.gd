extends Node

var wave_number:int = 0
var currency: int = 0
var ore: float = 0

enum hex_ids {BLANK, ORE, HEART, WIRE, BATTERY, GENERATOR, MINER, ENHANCER, MINIGUN, SNIPER, LASER, MANUAL}

const hex_name = ["blank", "ore", "heart", "wire", "battery", "generator", "miner", "enhancer", "minigun", "sniper", "laser", "manual"]

const cost = {
	"wire": [5, 5, 5],
	"battery": [50, 50, 50],
	"generator": [50, 50, 50],
	"miner": [50, 50, 50],
	"enhancer": [50, 50, 50],
	"minigun": [50, 50, 50],
	"sniper": [50, 50, 50],
	"laser": [50, 50, 50],
	"manual": [50, 50, 50]
}

const TILE_MAP_LAYER = 0
const TILE_MAP_ATLAS_ID = 0

const BASIC_ENEMY = preload("res://Scenes/Enemy/BasicEnemy.tscn")
const SHIELD_ENEMY = preload("res://Scenes/Enemy/ShieldedEnemy.tscn")
const TANK_ENEMY = preload("res://Scenes/Enemy/SlowEnemy.tscn")
const PROJECTILE_ENEMY = preload("res://Scenes/Enemy/ProjectileEnemy.tscn")

const building_stats = {
	"heart": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"wire": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"battery": [
		{ # level 1
			"health": 10,
			"max_charge": 50,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 50,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 50,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"generator": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 5,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 0,
			"charge_rate": 5,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 0,
			"charge_rate": 5,
			"mine_rate": 0
		}
	],
	"miner": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": -2,
			"mine_rate": 1
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 0,
			"charge_rate": -2,
			"mine_rate": 1
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 0,
			"charge_rate": -2,
			"mine_rate": 1
		}
	],
	"enhancer": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"minigun": [
		{ # level 1
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"sniper": [
		{ # level 1
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"laser": [
		{ # level 1
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"manual": [
		{ # level 1
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 10,
			"max_charge": 10,
			"charge_rate": 0,
			"mine_rate": 0
		}
	]
}



const weapon_stats = {
	"manual": [
		{ # Level 1
		"damage": 10.0,
		"charge": 20.0
		},
		{ # Level 2
		"damage": 10.0,
		"charge": 20.0
		},
		{ # Level 3
		"damage": 10.0,
		"charge": 20.0
		}
	],
	"minigun": [
		{ # Level 1
		"damage": 3.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
		},
		{ # Level 2
		"damage": 3.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
		},
		{ # Level 3
		"damage": 3.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
		}
	],
	"sniper": [
		{ # Level 1
		"damage": 10.0,
		"charge": 20.0,
		"range": 500.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
		},
		{ # Level 2
		"damage": 10.0,
		"charge": 20.0,
		"range": 500.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
		},
		{ # Level 3
		"damage": 10.0,
		"charge": 20.0,
		"range": 500.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
		}
	],
	"laser": [
		{ # Level 1
		"damage": 1.0,
		"charge": 1.0,
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
		},
		{ # Level 2
		"damage": 1.0,
		"charge": 1.0,
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
		},
		{ # Level 3
		"damage": 1.0,
		"charge": 1.0,
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
		}
	]
}

const wave_data = [
	[ # Wave 1: Basic enemies - 0 to 60s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 2: Lots of Basic Enemies - 60 to 120s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 5,
			"enemy_spawn_delay": 3
		}
	],
	[ # Wave 3: Tank enemies - 120 to 180s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 4: Tank + Basic enemies - 180 to 240s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
	],
	[ # Wave 5: Shield Enemies - 240s to 300s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		}
	],
	[ # Wave 6: Shield and Tank Enemies - 300 to 360s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		}
	],
	[ # Wave 7 Shield, Tank, and Basic enemies - 360s to 420s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		}
	],
	[ # Wave 8: ALOT of basic enemies - 420 to 480s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 10,
			"enemy_spawn_delay": 3
		}
	],
	[ # Wave 9: Projectile enemies - 480 to 540s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": PROJECTILE_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 10: Projectile and Basic enemies - 540s to 600s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 5,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": PROJECTILE_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 11 Shield and Tank enemies - 600s to 660s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		}
	],
	[ # Wave 12 Shield and Projectile enemies - 660s to 720s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": PROJECTILE_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 13 Projectile, Shield, Tank, and Basic enemies - 720s to 780s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": PROJECTILE_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	]
]
