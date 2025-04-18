extends Control

class_name UiManager

@onready var gm = $"../../GM"

enum ui_id {START, WIN, WAVE, LOSE, CURRENCY, ORE, HEX}
const ui_atlas = ["start", "win", "wave", "lose", "currency", "ore", "hex"]

var ui = {}

const BUILDING_POPUP_PREFAB = preload("res://Scenes/UI/Overlay/building_popup.tscn")
const HEX_ICON_PREFAB = preload("res://Scenes/UI/hex_icon.tscn")

var building_popup: Node
var hex_icon: Node

func _ready():
	setup_ui_dictionary()

func setup_ui_dictionary():
	ui = {
	ui_atlas[ui_id.START]: $StartButton,
	ui_atlas[ui_id.WIN]: $WinLabel,
	ui_atlas[ui_id.WAVE]: $WaveLabel,
	ui_atlas[ui_id.LOSE]: $LoseLabel,
	ui_atlas[ui_id.CURRENCY]: $ResourceUI/CurrenyLabel,
	ui_atlas[ui_id.ORE]: $ResourceUI/OreLabel,
	ui_atlas[ui_id.HEX]: $HexMenu
}

func update_visiblity(val: bool, ui_tag: String):
	ui[ui_tag].visible = val

func _on_gm_currency_changed():
	ui[ui_atlas[ui_id.CURRENCY]].set_text(str(Data.currency))

func _on_gm_ore_changed():
	ui[ui_atlas[ui_id.ORE]].set_text(str(int(Data.ore)))

func _on_gm_wave_changed():
	ui[ui_atlas[ui_id.WAVE]].text = "Wave " + str(Data.wave_number+1)

func _on_hex_menu_button_pressed(button):
	cleanup_hex_icon()
	gm.start_placement(button)

func create_popup(tile_pos):
	building_popup = BUILDING_POPUP_PREFAB.instantiate()
	building_popup.global_position = get_global_mouse_position()
	add_child(building_popup)
	building_popup.building = Methods.find_building(tile_pos)
	building_popup.connect("sell_button_pressed", _on_sell_button_pressed)
	building_popup.connect("upgrade_button_pressed", _on_upgrade_button_pressed)
	building_popup.setup()
	await get_tree().process_frame
	
	var screen_size = get_viewport_rect().size
	var popup_size = building_popup.get_rect().size
	
	building_popup.position.x = clamp(building_popup.position.x, 0, screen_size.x - popup_size.x)
	building_popup.position.y = clamp(building_popup.position.y, 0, screen_size.y - popup_size.y)
	return


func _on_sell_button_pressed(building: Building):
	building.queue_free()
	building_popup.queue_free()
	Data.currency += int(Data.cost[building.tag]["currency"][building.level]*0.7)
	Data.currency += int(Data.cost[building.tag]["ore"][building.level]*0.7)
	_on_gm_currency_changed()
	gm.power_systems = gm.tile_map.find_connections()

func _on_upgrade_button_pressed(building: Building):
	if building.level < Data.MAX_LEVEL:
		if Data.cost[building.tag]["currency"][building.level+1] <= Data.currency and Data.cost[building.tag]["ore"][building.level+1] <= Data.ore:
			building.setup(building.level+1)
			Data.currency -= Data.cost[building.tag]["currency"][building.level]
			Data.ore -= Data.cost[building.tag]["ore"][building.level]
			_on_gm_currency_changed()
			_on_gm_ore_changed()

func create_hex_icon(hex_id: int):
	hex_icon = HEX_ICON_PREFAB.instantiate()
	hex_icon.hex_id = hex_id
	hex_icon.frame = hex_id
	add_child(hex_icon)

func cleanup_popup():
	if building_popup != null:
		building_popup.queue_free()
	building_popup = null

func cleanup_hex_icon():
	if hex_icon != null:
		hex_icon.queue_free()
	hex_icon = null
