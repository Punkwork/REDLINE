class_name IceLane
extends Control
## CAS-001 C07 (ARCH-V2-003): the row of ICE panels. Reconciles by ICE reference instead of
## rebuilding (Build 12 rebuilt every refresh): a panel keeps its node, focus and art when its ICE
## rotates, gets hit or shifts index because Black ICE arrived on the left. Fits 1, 2 or 3 ICE by
## scaling panels down to the lane width (keys stay ≥ 44 px at three ICE); one ICE stays centred.

signal break_requested(ice_ref: Dictionary, sub: int, pick_uid: int)
signal target_chosen(ice_ref: Dictionary)
var targeting := false

func set_targeting(on: bool) -> void:
	targeting = on
	for p in _panels: p.set_targetable(on)

const PANEL_SCENE := preload("res://scenes/architecture_v2/IcePanel.tscn")

var layout: IcePanelLayout
var inspector: KeyInspector
var drop_check: Callable
var reduced_motion := false
@export var gap := 24.0

var _panels: Array = []   # IcePanel, in current ICE order

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if layout == null: layout = IcePanelLayout.load_default()
	resized.connect(_arrange)

func panels() -> Array:
	return _panels.duplicate()

func panel_for(ice_ref: Dictionary) -> IcePanel:
	for p in _panels:
		if is_same(p.ice_ref, ice_ref): return p
	return null

func sync(models: Array) -> void:
	var next: Array = []
	for m in models:
		var p := panel_for(m.ref)
		if p == null:
			p = PANEL_SCENE.instantiate()
			p.setup(layout, inspector)
			p.drop_check = drop_check
			p.reduced_motion = reduced_motion
			p.break_requested.connect(func(r, s, u): break_requested.emit(r, s, u))
			p.target_chosen.connect(func(r): target_chosen.emit(r))
			add_child(p)
		p.name = "Ice_%d_%s" % [int(m.index), String(m.id)]
		next.append(p)
	for p in _panels:
		if not next.has(p):
			remove_child(p); p.queue_free()
	_panels = next
	# Three ICE use the taller compact panel (ARCH-V2-003p): large avatar, keys below, keys ≥ 44 px.
	var compact := _panels.size() >= 3
	for n in _panels.size():
		move_child(_panels[n], n)
		_panels[n].set_compact(compact)
		_panels[n].set_model(models[n])
	_arrange()

func _arrange() -> void:
	var n := _panels.size()
	if n == 0 or layout == null: return
	var psz := layout.size_of(n >= 3)
	var pw := psz.x
	var ph := psz.y
	var k := minf(1.0, minf((size.x - (n - 1) * gap) / (n * pw), size.y / ph))
	var total := n * pw * k + (n - 1) * gap
	var x0 := (size.x - total) / 2.0
	for i in n:
		var p: IcePanel = _panels[i]
		p.scale = Vector2(k, k)
		p.position = Vector2(x0 + i * (pw * k + gap), (size.y - ph * k) / 2.0)

## ARCH-V2-007a: one continuous room behind all the windows. The image is fitted to cover the lane
## (keeping its aspect); each panel gets the part of it that lies behind its rectangle.
func set_room(friendly: Texture2D, hostile: Texture2D, reveal: float) -> void:
	if friendly == null:
		for p in _panels: p.set_room(null, null, Rect2(), 0.0)
		return
	var img := Vector2(friendly.get_width(), friendly.get_height())
	var k := maxf(size.x / img.x, size.y / img.y)
	var shown := img * k                          # the image's size on the lane
	var off := (shown - size) / 2.0                # how much is cropped each side
	for p in _panels:
		var r := Rect2(p.position, p.size * p.scale)
		var uv := Rect2((r.position + off) / shown, r.size / shown)
		p.set_room(friendly, hostile, uv, reveal)

