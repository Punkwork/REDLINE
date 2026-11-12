extends Control

# Interactive vertical slice shell. Exact locked cards, ICE, and turn rules
# must be imported from the authoritative design manifest before certification.
const MANIFEST_PATH := "res://data/training_node.json"
var manifest: Dictionary = {}
var layer := 0
var ice_index := 0
var log_lines: Array[String] = []
var heading: Label
var status: Label
var details: RichTextLabel
var action_button: Button
var log_view: RichTextLabel

func _ready() -> void:
    var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
    if file:
        var parsed = JSON.parse_string(file.get_as_text())
        if parsed is Dictionary:
            manifest = parsed
    var outer := VBoxContainer.new()
    outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    outer.add_theme_constant_override("separation", 12)
    add_child(outer)
    heading = Label.new()
    heading.add_theme_font_size_override("font_size", 30)
    outer.add_child(heading)
    status = Label.new()
    outer.add_child(status)
    details = RichTextLabel.new()
    details.custom_minimum_size = Vector2(0, 230)
    outer.add_child(details)
    action_button = Button.new()
    action_button.pressed.connect(_advance)
    outer.add_child(action_button)
    var restart := Button.new()
    restart.text = "Restart encounter"
    restart.pressed.connect(_restart)
    outer.add_child(restart)
    log_view = RichTextLabel.new()
    log_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
    outer.add_child(log_view)
    _refresh()

func _restart() -> void:
    layer = 0
    ice_index = 0
    log_lines.clear()
    _refresh()

func _advance() -> void:
    var layers: Array = manifest.get("layers", [])
    if layer >= layers.size():
        _restart()
        return
    var ice: Array = layers[layer].get("ice", [])
    if ice_index < ice.size():
        log_lines.append("INSPECTED: " + str(ice[ice_index].get("name", "UNDEFINED")))
        ice_index += 1
    if ice_index >= ice.size():
        log_lines.append("LAYER %d inspected" % (layer + 1))
        layer += 1
        ice_index = 0
    _refresh()

func _refresh() -> void:
    heading.text = "REDLINE / TRAINING NODE"
    var layers: Array = manifest.get("layers", [])
    if layer >= layers.size():
        status.text = "Manifest inspection complete"
        details.text = "Not a combat victory. Locked encounter data and full turn mechanics are still required."
        action_button.text = "Restart"
    else:
        var entry: Dictionary = layers[layer]
        var ice: Array = entry.get("ice", [])
        status.text = "Layer %d / %d | ICE %d / %d" % [layer + 1, layers.size(), ice_index + 1, ice.size()]
        if ice_index < ice.size():
            var current: Dictionary = ice[ice_index]
            details.text = "ICE: %s\nSTR: %s\n\n%s" % [str(current.get("name", "UNDEFINED")), str(current.get("str", "UNDEFINED")), JSON.stringify(current.get("subroutines", []), "  ")]
        else:
            details.text = "No ICE defined for this layer."
        action_button.text = "Inspect next ICE"
    log_view.text = "\n".join(log_lines)
