extends Sprite2D

class_name Weapon

const SPRITE_ROTATION_OFFSET = deg_to_rad(90.0)

@export var damage_val: float = 0.0
@export var charge_cost: float = 0.0


var building_owner : Building = null

func setup(tag: String, level: int = 0):
	var weapon_name = tag
	var weapon_stats = Data.weapon_stats[weapon_name][level]
	
	if weapon_stats:
		damage_val = weapon_stats["damage"]
		charge_cost = weapon_stats["charge"]
		
		if self is AutoWeapon:
			self.cooldown = weapon_stats["cooldown"]
			self.range = weapon_stats["range"]
			
			if self is HitscanAutoWeapon:
				self.attack_speed = weapon_stats["attack_speed"]
				self.ammo_amount = weapon_stats["ammo"]
			elif self is ContinousAutoWeapon:
				self.attack_duration = weapon_stats["attack_duration"]
	
func enhance_weapon():
	damage_val *= Data.ENHANCEMENT_MULTI
	charge_cost *= Data.ENHANCEMENT_MULTI
	
	if self is AutoWeapon:
		self.cooldown *= Data.ENHANCEMENT_MULTI
		self.range *= Data.ENHANCEMENT_MULTI
		
		if self is HitscanAutoWeapon:
			self.attack_speed /= Data.ENHANCEMENT_MULTI
			self.ammo_amount *= Data.ENHANCEMENT_MULTI
		elif self is ContinousAutoWeapon:
			self.attack_duration *= Data.ENHANCEMENT_MULTI

func revert_enhance_weapon():
	damage_val /= Data.ENHANCEMENT_MULTI
	charge_cost /= Data.ENHANCEMENT_MULTI
	
	if self is AutoWeapon:
		self.cooldown /= Data.ENHANCEMENT_MULTI
		self.range /= Data.ENHANCEMENT_MULTI
		
		if self is HitscanAutoWeapon:
			self.attack_speed *= Data.ENHANCEMENT_MULTI
			self.ammo_amount /= Data.ENHANCEMENT_MULTI
		elif self is ContinousAutoWeapon:
			self.attack_duration /= Data.ENHANCEMENT_MULTI

