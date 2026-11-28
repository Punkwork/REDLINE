class_name UplinkRoom
extends Control
## UPLINK-SPEC-001: the Black Market Uplink room (visual placement: UI Design Bible, "UPLINK-SPEC-001 —
## Visual placement recovery", designer reconfirmed 2026-11-28). The painted room is
## BG_NODE_UPLINK_UNDERWORLD.png, unchanged (UI-IDENTITY-001); the inventory sits in it:
##   * eight cards, four columns by two rows, on the recessed back wall;
##   * three CAPS upright side by side in a three-slot capacitor/fuse bank, mid-right under the cards;
##   * three Ghostware medallions (aged green housing, brass rims) lower right under the CAPS;
##   * the cash register is where a purchase is confirmed (it lights and rings up the price);
##   * the security grille on the right, marked with a medical cross, is the CORTEX-only Clinic;
##   * the upper-left CRT (formerly WIPE) does nothing: WIPE is not an Uplink service (Core Rules §8.3).
## Presentation only: every rule, price and transaction is UplinkVisit / UplinkContract on the Game.
## Positions are fitted to the artwork for designer review, not locked coordinates.

signal leave_requested

const REF := Vector2(1600, 1000)                     ## the background's own size
const BG := "res://assets/concept/backgrounds/BG_NODE_UPLINK_UNDERWORLD.png"
const CARD_SCALE := 0.94
const CARD_ORIGIN := Vector2(452, 92)                ## top-left card, back wall
const CARD_GAP := Vector2(14, 44)                    ## room for the price tag under each row
const FUSE_BANK := Rect2(792, 588, 252, 214)         ## mid-right, under the cards
const GHOST_ROW := Rect2(792, 818, 252, 92)          ## lower right, under the CAPS
const REGISTER := Rect2(1092, 440, 222, 176)         ## the painted cash register
const CLINIC := Rect2(1336, 60, 250, 530)            ## the painted security grille
const LEDGER := Rect2(452, 920, 320, 56)             ## CRED and deck, on the floor edge
const LEAVE := Rect2(1352, 920, 200, 56)

const ENAMEL := Color("#3E5A46")
const ENAMEL_DARK := Color("#26382C")
const TARNISH := Color("#8C8A70")
const BRASS := Color("#B08A4A")
const TAG := Color("#E9DDB8")
const INK := Color("#2A1D0E")

var game: Game
var stage: Control
var inspector: KeyInspector
var card_views: Array = []      # CardView, shelf order
var card_tags: Array = []       # Label
var cap_slots: Array = []       # CapSlot
var ghost_slots: Array = []     # GhostSlot
var register: RegisterSpot
var cred_label: Label
var deck_label: Label
var dialog: PanelContainer
var flash_t := 0.0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var back := ColorRect.new(); back.color = Color.BLACK; back.set_anchors_preset(Control.PRESET_FULL_RECT); add_child(back)
	stage = Control.new(); stage.name = "Stage"; stage.size = REF; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	var bg := TextureRect.new(); bg.name = "Room"; bg.texture = load(BG); bg.size = REF
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(bg)
	_build_cards()
	_build_fuse_bank()
	_build_ghostware()
	register = RegisterSpot.new(); register.name = "Register"; register.position = REGISTER.position; register.size = REGISTER.size
	stage.add_child(register)
	var clinic := ClinicSpot.new(); clinic.name = "Clinic"; clinic.position = CLINIC.position; clinic.size = CLINIC.size
	clinic.pressed.connect(_open_clinic)
	stage.add_child(clinic)
	_build_ledger()
	inspector = KeyInspector.new(); inspector.name = "Inspector"; add_child(inspector)
	for cv in card_views: cv.inspector = inspector
	for s in cap_slots + ghost_slots: s.inspector = inspector
	clinic.inspector = inspector
	get_viewport().size_changed.connect(_fit)
	_fit()

func _fit() -> void:
	var vp := get_viewport_rect().size
	var k := minf(vp.x / REF.x, vp.y / REF.y)
	stage.scale = Vector2(k, k)
	stage.position = (vp - REF * k) / 2.0

func attach(g: Game) -> void:
	game = g
	refresh()

func _build_cards() -> void:
	var sz := CardView.BASE * CARD_SCALE
	for k in 8:
		var cv := CardView.new(); cv.name = "Offer%d" % k
		cv.draggable = false
		cv.size = sz; cv.custom_minimum_size = sz
		cv.position = CARD_ORIGIN + Vector2((k % 4) * (sz.x + CARD_GAP.x), (k / 4) * (sz.y + CARD_GAP.y))
		var idx := k
		cv.pressed.connect(func(_u): _buy_card(idx))
		stage.add_child(cv)
		card_views.append(cv)
		var tag := _tag(Rect2(cv.position + Vector2(sz.x * 0.18, sz.y + 6), Vector2(sz.x * 0.64, 26)))
		tag.name = "Price%d" % k
		card_tags.append(tag)

func _tag(r: Rect2) -> Label:
	var l := Label.new()
	l.position = r.position; l.size = r.size
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_font_override("font", VasTokens.FONT_PLAQUE); l.add_theme_font_size_override("font_size", 18)
	l.add_theme_color_override("font_color", INK)
	var sb := StyleBoxFlat.new(); sb.bg_color = TAG; sb.set_corner_radius_all(3); sb.border_color = Color("#7A6A48"); sb.set_border_width_all(1)
	sb.shadow_color = Color(0, 0, 0, 0.45); sb.shadow_size = 3; sb.shadow_offset = Vector2(1, 2)
	l.add_theme_stylebox_override("normal", sb)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(l)
	return l

func _build_fuse_bank() -> void:
	var bank := FuseBank.new(); bank.name = "CapFuseBank"; bank.position = FUSE_BANK.position; bank.size = FUSE_BANK.size
	stage.add_child(bank)
	var w := (FUSE_BANK.size.x - 40.0) / 3.0
	for k in 3:
		var s := CapSlot.new(); s.name = "CapOffer%d" % k
		s.position = FUSE_BANK.position + Vector2(20 + k * w, 18)
		s.size = Vector2(w, FUSE_BANK.size.y - 30)
		var idx := k
		s.pressed.connect(func(): _buy_cap(idx))
		stage.add_child(s)
		cap_slots.append(s)

func _build_ghostware() -> void:
	var w := GHOST_ROW.size.x / 3.0
	for k in 3:
		var s := GhostSlot.new(); s.name = "GhostOffer%d" % k
		s.position = GHOST_ROW.position + Vector2(k * w, 0)
		s.size = Vector2(w, GHOST_ROW.size.y)
		stage.add_child(s)
		ghost_slots.append(s)

func _build_ledger() -> void:
	var box := PanelContainer.new(); box.name = "Ledger"; box.position = LEDGER.position; box.size = LEDGER.size
	var sb := StyleBoxFlat.new(); sb.bg_color = Color("#14100C", 0.88); sb.border_color = BRASS; sb.set_border_width_all(2); sb.set_corner_radius_all(6)
	sb.content_margin_left = 14; sb.content_margin_right = 14
	box.add_theme_stylebox_override("panel", sb)
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 22); box.add_child(row)
	cred_label = _readout(VasTokens.AMBER); row.add_child(cred_label)
	deck_label = _readout(VasTokens.IVORY); row.add_child(deck_label)
	stage.add_child(box)
	var leave := _styled(Button.new(), 26); leave.name = "Leave"; leave.text = "LEAVE"; leave.position = LEAVE.position; leave.size = LEAVE.size
	leave.pressed.connect(func(): leave_requested.emit())
	stage.add_child(leave)

## Brass-rimmed key, matching the ledger plate.
static func _styled(b: Button, px := 22) -> Button:
	b.add_theme_font_override("font", VasTokens.FONT_PLAQUE); b.add_theme_font_size_override("font_size", px)
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		var sb := StyleBoxFlat.new()
		sb.bg_color = {"normal": Color("#2A2018"), "hover": Color("#3A2C1E"), "pressed": Color("#1A130D"), "disabled": Color("#1E1914"), "focus": Color("#2A2018")}[st]
		sb.border_color = VasTokens.FOCUS if st == "focus" else (Color("#6A5A3A") if st == "disabled" else BRASS)
		sb.set_border_width_all(2); sb.set_corner_radius_all(6)
		sb.content_margin_left = 14; sb.content_margin_right = 14; sb.content_margin_top = 6; sb.content_margin_bottom = 6
		b.add_theme_stylebox_override(st, sb)
	b.add_theme_color_override("font_color", VasTokens.IVORY)
	b.add_theme_color_override("font_hover_color", VasTokens.AMBER)
	b.add_theme_color_override("font_disabled_color", Color("#7A6E5A"))
	return b

func _readout(col: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_override("font", VasTokens.FONT_READOUT); l.add_theme_font_size_override("font_size", 22)
	l.add_theme_color_override("font_color", col)
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l

# ----- state → view

func refresh() -> void:
	if game == null or game.uplink == null: return
	var v := game.uplink
	for k in card_views.size():
		var cv: CardView = card_views[k]
		if k >= v.cards.size():
			cv.visible = false; card_tags[k].visible = false; continue
		var c: Dictionary = v.cards[k]
		var m := VisibleStateAdapter.card_model(game, {"uid": -100 - k, "id": c.id}, "shop")
		m.playable = not c.sold and game.cred >= int(c.price)
		m.reason = "Sold." if c.sold else ("Not enough CRED (%d)." % int(c.price) if game.cred < int(c.price) else "")
		cv.set_model(m)
		cv.modulate = Color(1, 1, 1, 0.42) if c.sold else Color.WHITE
		cv.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if m.playable else Control.CURSOR_ARROW
		var tag: Label = card_tags[k]
		tag.text = "SOLD" if c.sold else ("SALE  %d CRED" % int(c.price) if c.sale else "%d CRED" % int(c.price))
		tag.add_theme_color_override("font_color", Color("#8A1F12") if c.sale and not c.sold else INK)
	for k in cap_slots.size():
		cap_slots[k].set_offer(v.caps[k] if k < v.caps.size() else {}, game.cred)
	for s in ghost_slots: s.set_offer({})
	cred_label.text = "CRED %d" % game.cred
	deck_label.text = "DECK %d" % game.run_deck.size()

func _process(delta: float) -> void:
	if flash_t > 0.0:
		flash_t = maxf(0.0, flash_t - delta)
		register.glow = flash_t / 0.9
		register.queue_redraw()

# ----- transactions (one Game call each)

func _rung(price: int) -> void:
	flash_t = 0.9
	register.last = "−%d CRED" % price
	register.queue_redraw()
	refresh()

func _buy_card(k: int) -> void:
	if game == null or game.uplink == null: return
	var price := int(game.uplink.cards[k].price)
	if game.uplink.buy_card(k): _rung(price)

func _buy_cap(k: int) -> void:
	var v := game.uplink
	if v == null or not v.can_buy_cap(k): return
	if v.cap_needs_replacement():
		_open_replace(k)
		return
	var price := int(v.caps[k].price)
	if v.buy_cap(k): _rung(price)

var _shade: ColorRect

func _close_dialog() -> void:
	if is_instance_valid(dialog): dialog.queue_free()
	if is_instance_valid(_shade): _shade.queue_free()
	dialog = null

## A modal dialog over the room (the shade swallows clicks on the shelf behind it).

func _dialog(title: String) -> VBoxContainer:
	_close_dialog()
	_shade = ColorRect.new(); _shade.name = "Shade"; _shade.color = Color(0, 0, 0, 0.45); _shade.size = REF
	_shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_shade.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: _close_dialog())
	stage.add_child(_shade)
	dialog = PanelContainer.new(); dialog.name = "UplinkDialog"
	var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1B140E", 0.96); sb.border_color = BRASS; sb.set_border_width_all(2); sb.set_corner_radius_all(8)
	sb.content_margin_left = 22; sb.content_margin_right = 22; sb.content_margin_top = 16; sb.content_margin_bottom = 16
	dialog.add_theme_stylebox_override("panel", sb)
	var v := VBoxContainer.new(); v.add_theme_constant_override("separation", 12); dialog.add_child(v)
	var t := Label.new(); t.text = title; t.add_theme_font_override("font", VasTokens.FONT_PLAQUE); t.add_theme_font_size_override("font_size", 28)
	t.add_theme_color_override("font_color", VasTokens.AMBER); v.add_child(t)
	stage.add_child(dialog)
	dialog.position = Vector2(520, 340)
	return v

func _button(parent: Control, text: String, cb: Callable, enabled := true) -> Button:
	var b := _styled(Button.new()); b.text = text; b.disabled = not enabled
	b.pressed.connect(cb)
	parent.add_child(b)
	return b

## UPLINK-SPEC-001: a full CAP rack offers a confirmed replacement; cancelling changes nothing.
func _open_replace(k: int) -> void:
	var v := _dialog("CAP RACK FULL")
	var info := Label.new(); info.text = "Replace which CAP with %s? The replaced CAP is lost." % CardDB.CAPS[game.uplink.caps[k].id].name
	info.add_theme_color_override("font_color", VasTokens.IVORY); v.add_child(info)
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 10); v.add_child(row)
	for c in game.caps:
		var uid := int(c.uid)
		var price := int(game.uplink.caps[k].price)
		_button(row, CardDB.CAPS[c.id].name, func():
			if game.uplink.buy_cap(k, uid): _rung(price)
			_close_dialog())
	_button(v, "CANCEL", _close_dialog)

## The Clinic (Core Rules §8.3): CORTEX only, quantity chosen, price shown, confirmed.
func _open_clinic() -> void:
	if game == null or game.uplink == null: return
	var v := _dialog("CLINIC")
	var info := Label.new(); info.add_theme_color_override("font_color", VasTokens.IVORY); v.add_child(info)
	var n := [mini(1, game.cortex)]
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 10); v.add_child(row)
	var confirm: Button
	var redraw := func():
		info.text = "CORTEX counters: %d.  Remove %d for %d CRED." % [game.cortex, n[0], game.uplink.clinic_price(n[0])] if game.cortex > 0 else "No CORTEX to remove."
		if confirm: confirm.disabled = not game.uplink.can_clinic(n[0])
	_button(row, "−", func(): n[0] = maxi(1, n[0] - 1); redraw.call())
	_button(row, "+", func(): n[0] = mini(game.cortex, n[0] + 1); redraw.call())
	confirm = _button(row, "REMOVE", func():
		var p: int = game.uplink.clinic_price(n[0])
		if game.uplink.clinic(n[0]): _rung(p)
		_close_dialog())
	_button(row, "CANCEL", _close_dialog)
	redraw.call()

# ----- room parts

## The three-slot capacitor / fuse bank (aged green enamel, tarnished metal), drawn behind the vials.
class FuseBank extends Control:
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var sb := StyleBoxFlat.new(); sb.bg_color = UplinkRoom.ENAMEL; sb.border_color = UplinkRoom.TARNISH; sb.set_border_width_all(4)
		sb.set_corner_radius_all(10); sb.shadow_color = Color(0, 0, 0, 0.55); sb.shadow_size = 10; sb.shadow_offset = Vector2(3, 5)
		draw_style_box(sb, r)
		draw_rect(Rect2(10, 8, size.x - 20, 6), UplinkRoom.TARNISH)                     # top bus bar
		draw_rect(Rect2(10, size.y - 16, size.x - 20, 6), UplinkRoom.TARNISH)           # bottom bus bar
		for x in [6.0, size.x - 6.0]:
			for y in [10.0, size.y - 10.0]: draw_circle(Vector2(x, y), 3.5, UplinkRoom.BRASS)

## One CAP offer: an upright vial in its socket clips, with a price tag.
class CapSlot extends HudWidgets.Explained:
	signal pressed
	var offer: Dictionary = {}
	var affordable := false
	var tex: Texture2D
	func set_offer(o: Dictionary, cred: int) -> void:
		offer = o
		affordable = not o.is_empty() and not o.sold and cred >= int(o.price)
		var id := String(o.get("id", ""))
		tex = load("res://assets/architecture_v2/caps/%s.png" % id) if id != "" and ResourceLoader.exists("res://assets/architecture_v2/caps/%s.png" % id) else null
		if o.is_empty():
			title = ""
		else:
			var d: Dictionary = CardDB.CAPS.get(id, {})
			title = String(d.get("name", id))
			lines = [String(d.get("text", "")), "SOLD." if o.sold else "%d CRED. Single use, 0 BW, any time in your turn." % int(o.price)]
			if not o.sold and not affordable: lines.append("Not enough CRED.")
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if affordable else Control.CURSOR_HELP
		queue_redraw()
	func _gui_input(e: InputEvent) -> void:
		if not affordable: return
		if (e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed) or e.is_action_pressed("ui_accept"):
			accept_event(); pressed.emit()
	func _draw() -> void:
		var tag_h := 26.0
		var socket := Rect2(size.x * 0.16, 0, size.x * 0.68, size.y - tag_h - 6)
		draw_rect(socket, UplinkRoom.ENAMEL_DARK)
		for y in [socket.position.y + 4.0, socket.end.y - 10.0]:   # the socket clips
			draw_rect(Rect2(socket.position.x - 4, y, socket.size.x + 8, 6), UplinkRoom.TARNISH)
		if tex:
			var ts := tex.get_size()
			var h := socket.size.y - 12.0
			var w := h * ts.x / ts.y
			var r := Rect2(socket.position + Vector2((socket.size.x - w) / 2.0, 6), Vector2(w, h))
			draw_texture_rect(tex, r, false, Color(1, 1, 1, 0.35) if offer.get("sold", false) else Color.WHITE)
		var tag := Rect2(4, size.y - tag_h, size.x - 8, tag_h)
		draw_rect(tag, UplinkRoom.TAG)
		draw_rect(tag, Color("#7A6A48"), false, 1.0)
		if not offer.is_empty():
			var t := "SOLD" if offer.sold else "%d CRED" % int(offer.price)
			var f := VasTokens.FONT_PLAQUE
			var tw := f.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, 17).x
			draw_string(f, tag.position + Vector2((tag.size.x - tw) / 2.0, 19), t, HORIZONTAL_ALIGNMENT_LEFT, -1, 17, UplinkRoom.INK)
		focus_ring()

## One Ghostware medallion: recessed circular housing with a brass rim. Empty until Ghostware has
## canonical records (CSA-07).
class GhostSlot extends HudWidgets.Explained:
	var offer: Dictionary = {}
	func set_offer(o: Dictionary) -> void:
		offer = o
		title = "GHOSTWARE"
		lines = ["No Ghostware in stock: Ghostware isn't sold until its records are canonical (CSA-07)."] if o.is_empty() else []
		queue_redraw()
	func _draw() -> void:
		var c := size / 2.0
		var r := minf(size.x, size.y) * 0.42
		draw_circle(c + Vector2(2, 3), r + 4, Color(0, 0, 0, 0.5))
		draw_circle(c, r + 4, UplinkRoom.BRASS)
		draw_circle(c, r, UplinkRoom.ENAMEL)
		draw_circle(c, r * 0.72, UplinkRoom.ENAMEL_DARK)
		draw_arc(c, r * 0.72, 0, TAU, 48, Color(UplinkRoom.TARNISH, 0.8), 2.0, true)
		focus_ring()

## The painted cash register: lights up and rings up the price after a purchase.
class RegisterSpot extends Control:
	var glow := 0.0
	var last := ""
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		if glow <= 0.0: return
		var c := Color(VasTokens.AMBER, 0.35 * glow)
		draw_rect(Rect2(Vector2.ZERO, size).grow(4), c, false, 4.0)
		var f := VasTokens.FONT_READOUT
		var tw := f.get_string_size(last, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x
		draw_string(f, Vector2((size.x - tw) / 2.0, -12), last, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(VasTokens.AMBER, glow))

## The Clinic: the painted security grille, marked with an enamel medical cross. Opens the Clinic.
class ClinicSpot extends HudWidgets.Explained:
	signal pressed
	func _init() -> void:
		super._init()
		title = "CLINIC"
		lines = ["Removes CORTEX counters for CRED (Core Rules §8.3). 30 CRED each; 25% off for 2 or more."]
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	func _gui_input(e: InputEvent) -> void:
		if (e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed) or e.is_action_pressed("ui_accept"):
			accept_event(); pressed.emit()
	func _draw() -> void:
		# The cross plaque, on the grille's lower rail.
		var p := Rect2(size.x * 0.36, size.y * 0.80, size.x * 0.28, size.x * 0.28)
		draw_rect(p.grow(3), UplinkRoom.TARNISH)
		draw_rect(p, Color("#E9DDB8"))
		var arm := p.size.x * 0.22
		var col := Color("#B3261E")
		draw_rect(Rect2(p.position + Vector2((p.size.x - arm) / 2.0, p.size.y * 0.16), Vector2(arm, p.size.y * 0.68)), col)
		draw_rect(Rect2(p.position + Vector2(p.size.x * 0.16, (p.size.y - arm) / 2.0), Vector2(p.size.x * 0.68, arm)), col)
		focus_ring()
