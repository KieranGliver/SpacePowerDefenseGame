extends Area2D


@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage, direction, knockback)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0:
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1:
					pass
				2:
					if area.has_method("tempDisable"):
						area.tempDisable()
			
			if area.has_method("enemy_hit"):
				area.enemy_hit()
			
			var damage = get_overlapping_areas().reduce(sum_area_damage, 0)
			var direction = area.global_position.direction_to(global_position)
			var knockback = 0
			if not area.get("knockback") == null:
				knockback = area.knockback
			
			emit_signal("hurt", damage, knockback, direction)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)

func sum_area_damage(accum, area):
	if area.get("damage") != null: 
		return accum + area.damage 
	return accum
