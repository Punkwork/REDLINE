extends RefCounted
## Icons and colours for cards, Rustlers, corporations, CAPS and Ghostware.
##
## Every icon is white line art at res://assets/icons/<folder>/<id>.svg (folders in data/visuals.json),
## tinted with a colour from data/visuals.json. In the editor the SVGs are imported as textures;
## in headless runs (tests) they're rasterised at runtime, so no import step is needed.
##
##     var icons = Icons.new(db)
##     var tex: Texture2D = icons.texture("cap", "zero_day")
##     var col: Color = icons.cap_color("zero_day")

const ICON_ROOT := "res://assets/icons/"
const RASTER_SCALE := 1.0      ## SVGs are 64×64; TextureRects scale them down

var db
var visuals: Dictionary
var _cache := {}               ## path -> Texture2D (or null if missing)


func _init(game_data) -> void:
	db = game_data
	visuals = db.raw.get("visuals", {})


## Path of the icon for an id in a category ("card_type", "rustler", "corporation", "cap", "ghostware").
func icon_path(category: String, id: String) -> String:
	var folder: String = visuals.get("icon_folders", {}).get(category, category)
	return "%s%s/%s.svg" % [ICON_ROOT, folder, id.to_lower().replace(" ", "_")]


## The icon texture, or null if the file doesn't exist.
func texture(category: String, id: String) -> Texture2D:
	var path := icon_path(category, id)
	if _cache.has(path):
		return _cache[path]
	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path)
	elif FileAccess.file_exists(path):
		var img := Image.new()
		if img.load_svg_from_string(FileAccess.get_file_as_string(path), RASTER_SCALE) == OK:
			tex = ImageTexture.create_from_image(img)
	_cache[path] = tex
	return tex


# ------------------------------------------------------------------ colours

func _hex(section: String, id: String, fallback := "d8dee9") -> Color:
	return Color(str(visuals.get(section, {}).get(id, {}).get("color", fallback)))


func card_type_color(card_type: String) -> Color:
	return _hex("card_types", card_type)


func owner_color(owner: String) -> Color:
	return _hex("owners", owner)


func owner_edge(owner: String) -> String:
	return str(visuals.get("owners", {}).get(owner, {}).get("edge", "plain"))


func owner_label(owner: String) -> String:
	return str(visuals.get("owners", {}).get(owner, {}).get("label", owner.to_upper()))


func rustler_color(rustler_id: String) -> Color:
	return owner_color(rustler_id)


func corporation_color(corp_id: String) -> Color:
	return _hex("corporations", corp_id)


func rarity_color(rarity: String) -> Color:
	return _hex("rarities", rarity)


func cap_color(cap_id: String) -> Color:
	return rarity_color(str(db.caps.get(cap_id, {}).get("rarity", "common")))


## Ghostware colour: ORIGIN takes its Rustler's colour, a corporation set its corporation's colour,
## anything with a drawback is red, the rest use the general pool colour.
func ghostware_color(ghostware_id: String) -> Color:
	var g: Dictionary = db.ghostware.get(ghostware_id, {})
	var pool := str(g.get("pool", "general"))
	if g.has("drawback"):
		return _hex("ghostware_pools", "drawback")
	if pool == "origin":
		for rid in db.rustlers:
			if db.rustlers[rid].get("origin_ghostware", "") == ghostware_id:
				return rustler_color(rid)
	if db.corporations.has(pool):
		return corporation_color(pool)
	return _hex("ghostware_pools", pool, "b8c0ff")


# ------------------------------------------------------------------ widgets

## A tinted icon sized for a UI row.
func icon_rect(category: String, id: String, color: Color, px: int = 24) -> TextureRect:
	var r := TextureRect.new()
	r.texture = texture(category, id)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(px, px)
	r.size = Vector2(px, px)
	r.self_modulate = color
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r
