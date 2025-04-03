extends Node

var wave_number:int = 0
var currency: int = 0
var ore: float = 0

enum hex_ids {BLANK, ORE, HEART, WIRE, BATTERY, GENERATOR, MINER, ENHANCER, MINIGUN, SNIPER, LASER, MANUAL}

const hex_name = ["blank", "ore", "heart", "wire", "battery", "generator", "miner", "enhancer", "minigun", "sniper", "laser", "manual"]

const MAX_LEVEL = 2
const ENHANCEMENT_MULTI = 2.0

const cost = {
	"heart": {"currency":[0, 100, 200], "ore":[0, 0, 50]},
	"wire": {"currency":[5, 10, 25], "ore":[0, 0, 0]},
	"battery": {"currency":[25, 100, 200], "ore":[0, 0, 0]},
	"generator": {"currency":[50, 75, 100], "ore":[0, 5, 20]},
	"miner": {"currency":[75, 125, 200], "ore":[0, 0, 0]},
	"enhancer": {"currency":[50, 50, 50], "ore":[20, 5, 5]},
	"minigun": {"currency":[50, 100, 150], "ore":[0, 0, 10]},
	"sniper": {"currency":[75, 100, 125], "ore":[0, 5, 15]},
	"laser": {"currency":[75, 125, 150], "ore":[0, 0, 10]},
	"manual": {"currency":[50, 75, 125], "ore":[0, 5, 15]}
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
			"health": 25,
			"max_charge": 20,
			"charge_rate": 5,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 50,
			"max_charge": 40,
			"charge_rate": 10,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 100,
			"max_charge": 80,
			"charge_rate": 20,
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
			"health": 20,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"battery": [
		{ # level 1
			"health": 20,
			"max_charge": 50,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 40,
			"max_charge": 100,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 80,
			"max_charge": 300,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"generator": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 10,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 0,
			"charge_rate": 30,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 0,
			"charge_rate": 60,
			"mine_rate": 0
		}
	],
	"miner": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": -5,
			"mine_rate": 0.05
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 0,
			"charge_rate": -7.5,
			"mine_rate": 0.1
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 0,
			"charge_rate": -15,
			"mine_rate": 0.5
		}
	],
	"enhancer": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": -10,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 0,
			"charge_rate": -5,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 0,
			"charge_rate": -2,
			"mine_rate": 0
		}
	],
	"minigun": [
		{ # level 1
			"health": 10,
			"max_charge": 15,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 30,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 60,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"sniper": [
		{ # level 1
			"health": 10,
			"max_charge": 40,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 60,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 80,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"laser": [
		{ # level 1
			"health": 10,
			"max_charge": 20,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 20,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 40,
			"charge_rate": 0,
			"mine_rate": 0
		}
	],
	"manual": [
		{ # level 1
			"health": 10,
			"max_charge": 0,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 2
			"health": 20,
			"max_charge": 30,
			"charge_rate": 0,
			"mine_rate": 0
		}, 
		{ # level 3
			"health": 40,
			"max_charge": 60,
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
		"damage": 15.0,
		"charge": 15.0
		},
		{ # Level 3
		"damage": 20.0,
		"charge": 10.0
		}
	],
	"minigun": [
		{ # Level 1
		"damage": 5.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 4
		},
		{ # Level 2
		"damage": 7.0,
		"charge": 10.0,
		"range": 300.0,
		"cooldown": 2.0,
		"attack_speed": 0.25,
		"ammo": 4
		},
		{ # Level 3
		"damage": 10.0,
		"charge": 15.0,
		"range": 300.0,
		"cooldown": 1.0,
		"attack_speed": 0.20,
		"ammo": 6
		}
	],
	"sniper": [
		{ # Level 1
		"damage": 40.0,
		"charge": 40.0,
		"range": 500.0,
		"cooldown": 7.5,
		"attack_speed": 1.0,
		"ammo": 1
		},
		{ # Level 2
		"damage": 60.0,
		"charge": 60.0,
		"range": 600.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
		},
		{ # Level 3
		"damage": 80.0,
		"charge": 80.0,
		"range": 700.0,
		"cooldown": 3.0,
		"attack_speed": 1.0,
		"ammo": 2
		}
	],
	"laser": [
		{ # Level 1
		"damage": 5.0,
		"charge": 2.5,
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
		},
		{ # Level 2
		"damage": 10.0,
		"charge": 5.0,
		"range": 400.0,
		"cooldown": 2.0,
		"attack_duration": 15.0,
		},
		{ # Level 3
		"damage": 30,
		"charge": 10.0,
		"range": 400.0,
		"cooldown": 0.0,
		"attack_duration": 15.0,
		}
	]
}


const wave_data = [
	[ # Wave 1: Basic enemies - 0 to 60s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 30,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 2: Lots of Basic Enemies - 60 to 120s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 5
		}
	],
	[ # Wave 3: Tank enemies - 120 to 180s
		{
			"time_start": 30,
			"time_end": 60,
			"enemy": BASIC_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 4
		},
		{
			"time_start": 0,
			"time_end": 50,
			"enemy": TANK_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 10
		},
		{
			"time_start": 40,
			"time_end": 50,
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
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 30,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 4
		},
	],
	[ # Wave 6: Shield and Tank Enemies - 300 to 360s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 2,
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
			"enemy_num": 4,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 6
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
			"enemy_spawn_delay": 2
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
			"enemy_num": 10,
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
			"enemy_num": 2,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 4,
			"enemy_spawn_delay": 4
		}
	],
	[ # Wave 12 Shield and Projectile enemies - 660s to 720s
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 4,
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
			"enemy_num": 10,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": TANK_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 0,
			"time_end": 60,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 3,
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
