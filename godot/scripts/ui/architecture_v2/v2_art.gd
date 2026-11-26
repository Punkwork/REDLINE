class_name V2Art
extends RefCounted
## VAS-ASSET-001 (ARCH-V2-003): loads the painted Architecture V2 parts at the size they are drawn.
## The parts are painted at 2–4× their on-screen size; drawing them that much smaller without
## mipmaps shimmers, and nine-slice margins would be several times too thick. Each request is
## resized once (Lanczos) to `px` reference pixels × QUALITY and cached. Missing files return null
## so callers fall back to drawn shapes. Presentation only.

const ROOT := "res://assets/architecture_v2/"
## Supersampling over reference pixels, so 1920×1080 windows (stage scale 1.25) stay crisp.
const QUALITY := 1.5

static var _cache := {}

static func image(rel: String) -> Image:
	var path := ROOT + rel
	if not ResourceLoader.exists(path): return null
	var t: Texture2D = load(path)
	if t == null: return null
	var img := t.get_image()
	if img == null: return null
	if img.is_compressed(): img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	return img

## The part scaled so its WIDTH is `w` reference pixels (height keeps the aspect).
static func tex(rel: String, w: float) -> Texture2D:
	var key := "%s@%d" % [rel, int(w)]
	if _cache.has(key): return _cache[key]
	var img := image(rel)
	var out: Texture2D = null
	if img:
		var tw := maxi(1, int(round(w * QUALITY)))
		var th := maxi(1, int(round(float(img.get_height()) * tw / img.get_width())))
		img.resize(tw, th, Image.INTERPOLATE_LANCZOS)
		out = ImageTexture.create_from_image(img)
	_cache[key] = out
	return out

## A nine-slice style box. `margins` are in the source file's pixels (MANIFEST.md); `rim` is how many
## reference pixels the left margin should occupy on screen (the others scale with it).
static func nine(rel: String, margins: Vector4, rim: float) -> StyleBoxTexture:
	var img := image(rel)
	if img == null: return null
	# StyleBoxTexture draws margins at texture-pixel size, so nine-slices are built at reference
	# scale (no supersampling); only plain stretched parts use QUALITY.
	var tex_k := rim / margins.x
	var tw := maxi(1, int(round(img.get_width() * tex_k)))
	var th := maxi(1, int(round(img.get_height() * tex_k)))
	var key := "%s#%d" % [rel, tw]
	var t: Texture2D = _cache.get(key)
	if t == null:
		img.resize(tw, th, Image.INTERPOLATE_LANCZOS)
		t = ImageTexture.create_from_image(img)
		_cache[key] = t
	var sb := StyleBoxTexture.new()
	sb.texture = t
	sb.texture_margin_left = margins.x * tex_k
	sb.texture_margin_top = margins.y * tex_k
	sb.texture_margin_right = margins.z * tex_k
	sb.texture_margin_bottom = margins.w * tex_k
	return sb

## A TextureRect showing a part stretched to `size` (reference px), aspect kept by the caller.
static func rect(rel: String, pos: Vector2, size: Vector2, node_name: String = "") -> TextureRect:
	var r := TextureRect.new()
	r.texture = tex(rel, size.x)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.position = pos
	r.size = size
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if node_name != "": r.name = node_name
	return r
