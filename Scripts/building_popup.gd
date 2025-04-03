extends PanelContainer

@onready var name_label = $MarginContainer/VBoxContainer/Name
@onready var level_label = $MarginContainer/VBoxContainer/Level
@onready var building_stats = $MarginContainer/VBoxContainer/StatContainer/BuildingStats
@onready var weapon_stats = $MarginContainer/VBoxContainer/StatContainer/WeaponStats
@onready var target_mode = $MarginContainer/VBoxContainer/TargetMode
@onready var close_button = $MarginContainer/VBoxContainer/TargetMode/TargetModeMenu/CloseButton
@onready var health_button = $MarginContainer/VBoxContainer/TargetMode/TargetModeMenu/HealthButton
@onready var shield_button = $MarginContainer/VBoxContainer/TargetMode/TargetModeMenu/ShieldButton
@onready var upgrade_button = $MarginContainer/VBoxContainer/ButtonContainer/UpgradeButton

var building : Building = null

signal sell_button_pressed(building : Building)
signal upgrade_button_pressed(building : Building)

func setup():
	name_label.text = building.tag.to_upper()
	level_label.text = "Level " + str(building.level+1)
	
	building_stats.text = get_building_stats()
	
	if weapon_stats != null:
		if !building.is_weapon:
			weapon_stats.queue_free()
		else:
			weapon_stats.text = get_weapon_stats()
	
	if target_mode != null:
		if !building.is_weapon or !building.weapon is AutoWeapon:
			target_mode.queue_free()
		else:
			match building.weapon.mode:
				building.weapon.target_modes.CLOSET:
					close_button.button_pressed = true
				building.weapon.target_modes.HEALTH:
					health_button.button_pressed = true
				building.weapon.target_modes.SHIELD:
					shield_button.button_pressed = true
	
	if building.level < Data.MAX_LEVEL:
		upgrade_button.tooltip_text = "Currency Cost: " + str(Data.cost[building.tag]["currency"][building.level+1]) + "\n" + "Gem Cost: " + str(Data.cost[building.tag]["ore"][building.level+1])
	else:
		upgrade_button.tooltip_text = "Max Level"

func get_building_stats():
	var ret_string = ""
	
	if building.max_hp > 0:
		ret_string += "Health: " + str(building.max_hp) + "\n"
	if building.max_charge > 0:
		ret_string += "Max Charge: " + str(building.max_charge) + "\n"
	if building.charge_rate > 0:
		ret_string += "Charge Rate: " + str(building.charge_rate) + "/s\n"
	elif building.charge_rate < 0:
		ret_string += "Charge Cost: " + str(building.charge_rate) + "/s\n"
	if building.mine_rate > 0:
		ret_string += "Mine Speed: " + str(building.mine_rate) + "/s\n"
	
	return ret_string

func get_weapon_stats():
	var ret_string = ""
	var weapon = building.weapon
	
	if not weapon is ContinousAutoWeapon:
		if weapon.damage_val > 0:
			ret_string += "Damage: " + str(weapon.damage_val) + "\n"
		if weapon.charge_cost > 0:
			ret_string += "Charge per Fire: " + str(weapon.charge_cost) + "\n"
		if weapon is AutoWeapon:
			if weapon.range > 0:
				ret_string += "Range: " + str(weapon.range) + "\n"
			if weapon.cooldown > 0:
				ret_string += "Cooldown: " + str(weapon.cooldown) + "\n"
			if weapon.ammo_amount > 0:
				ret_string += "Ammo: " + str(weapon.ammo_amount) + "\n"
	else:
		if weapon.damage_val > 0:
			ret_string += "Damage: " + str(weapon.damage_val) + "/s\n"
		if weapon.charge_cost > 0:
			ret_string += "Charge per Second: " + str(weapon.charge_cost) + "/s\n"
		if weapon.range > 0:
			ret_string += "Range: " + str(weapon.range) + "\n"
		if weapon.cooldown > 0:
			ret_string += "Cooldown: " + str(weapon.cooldown) + "\n"
		if weapon.attack_duration > 0:
			ret_string += "Attack Duration: " + str(weapon.attack_duration) + "\n"
	
	return ret_string

func _input(event):
	if event is InputEventMouseMotion:
		var global_mouse_position = get_global_mouse_position()
		var max_x = global_position.x + size.x * 1.1
		var min_x = global_position.x - size.x * 0.1
		var max_y = global_position.y + size.y * 1.1
		var min_y = global_position.y - size.y * 0.1
		if global_mouse_position.x <= min_x or global_mouse_position.x >= max_x or global_mouse_position.y <= min_y or global_mouse_position.y >= max_y: 
			queue_free()

func _on_upgrade_button_pressed():
	emit_signal("upgrade_button_pressed", building)
	setup()

func _on_sell_button_pressed():
	emit_signal("sell_button_pressed", building)


func _on_close_button_pressed():
	if building.is_weapon and building.weapon is AutoWeapon:
		building.weapon.mode = building.weapon.target_modes.CLOSET

func _on_health_button_pressed():
	if building.is_weapon and building.weapon is AutoWeapon:
		building.weapon.mode = building.weapon.target_modes.HEALTH

func _on_shield_button_pressed():
	if building.is_weapon and building.weapon is AutoWeapon:
		building.weapon.mode = building.weapon.target_modes.SHIELD
