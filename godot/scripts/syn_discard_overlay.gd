extends Control
class_name SynDiscardOverlay

# Modal SyN hand selector. Call begin_selection(hand, amount, callback).
# callback receives Array[int] of selected original hand indices.
var _hand: Array = []
var _required := 0
var _selected: Array[int] = []
var _callback: Callable
var _cards: GridContainer
var _count_label: Label
var _commit_button: Button

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_STOP
    visible = false

    var dim := ColorRect.new()
    dim.color = Color(0.025, 0.035, 0.055, 0.91)
    dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    dim.mouse_filter = Control.MOUSE_FILTER_STOP
    add_child(dim)

    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(center)

    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(660, 280)
    center.add_child(panel)
    var stack := VBoxContainer.new()
    stack.add_theme_constant_override("separation", 14)
    panel.add_child(stack)

    var heading := Label.new()
    heading.text = "SyN // SELECT CARDS TO DISCARD"
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.add_theme_font_size_override("font_size", 24)
    stack.add_child(heading)

    _count_label = Label.new()
    _count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stack.add_child(_count_label)

    _cards = GridContainer.new()
    _cards.columns = 4
    stack.add_child(_cards)

    _commit_button = Button.new()
    _commit_button.text = "COMMIT DISCARD"
    _commit_button.pressed.connect(_commit)
    stack.add_child(_commit_button)

func begin_selection(hand: Array, amount: int, on_commit: Callable) -> void:
    _hand = hand.duplicate()
    _required = min(max(0, amount), _hand.size())
    _selected.clear()
    _callback = on_commit
    visible = true
    _render_cards()

func _render_cards() -> void:
    for child in _cards.get_children():
        child.queue_free()
    for index in range(_hand.size()):
        var card := Button.new()
        var entry = _hand[index]
        card.text = str(entry.get("name", "Card") if entry is Dictionary else entry)
        card.custom_minimum_size = Vector2(145, 94)
        card.toggle_mode = true
        card.button_pressed = _selected.has(index)
        card.disabled = not _selected.has(index) and _selected.size() >= _required
        card.modulate = Color(0.35, 1.0, 0.72) if _selected.has(index) else Color(0.86, 0.88, 0.94)
        card.pressed.connect(_toggle.bind(index))
        _cards.add_child(card)
    _count_label.text = "SELECT %d / %d" % [_selected.size(), _required]
    _commit_button.disabled = _selected.size() != _required

func _toggle(index: int) -> void:
    if _selected.has(index):
        _selected.erase(index)
    elif _selected.size() < _required:
        _selected.append(index)
    _render_cards()

func _commit() -> void:
    if _selected.size() != _required:
        return
    var selection := _selected.duplicate()
    visible = false
    _callback.call(selection)
