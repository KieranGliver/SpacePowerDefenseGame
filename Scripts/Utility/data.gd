extends Node

enum hex_ids {BLANK, WIRE, BATTERY, GENERATOR, MINIGUN, SNIPER, LASER, MANUAL}

var cost = [0, 5, 50, 100, 50, 100, 150, 50]

const TILE_MAP_LAYER = 0
const TILE_MAP_ATLAS_ID = 0

const BASIC_ENEMY = preload("res://Scenes/Enemy/BasicEnemy.tscn")
const SHIELD_ENEMY = preload("res://Scenes/Enemy/ShieldedEnemy.tscn")
const TANK_ENEMY = preload("res://Scenes/Enemy/SlowEnemy.tscn")
const PROJECTILE_ENEMY = preload("res://Scenes/Enemy/ProjectileEnemy.tscn")

var weapon_stats = {
	"minigun": {
		"damage": 3.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
	},
	"sniper": {
		"damage": 10.0,
		"charge": 20.0,
		"range": 500.0,
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
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
	}
}

var wave_data = [
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
