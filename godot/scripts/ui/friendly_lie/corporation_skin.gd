class_name CorporationSkin
extends Resource
## VIS-001: presentation data only; no card, ICE, or corporation rules.
@export var corporation := "HALCYON"
@export var app_name := "halcyon home"
@export var ground := Color("#EAF4F0")
@export var accent := Color("#7FD8BE")
@export var deep := Color("#17785F")
@export var extra := Color("#FFE3D3")
@export var secondary := Color("#C9D7FF")
@export var ink := Color("#1B2230")
@export var radius := 24
@export var header_style := ""
@export var background: Texture2D
@export var hostile_background: Texture2D
@export var font: Font
@export var medium_font: Font
@export var bold_font: Font
@export var plaque_ground := FriendlyLook.ENAMEL
@export var plaque_ink := FriendlyLook.SLATE
@export var plaque_accent := FriendlyLook.SERVICE_TEAL
@export var plaque_muted := FriendlyLook.MUTED_INK
@export var mascot_shells: Dictionary = {}
@export var cracking_copy := "Is everything okay? We're just checking on you."
@export var strike_title := "We see you."
@export var strike_copy := "HALCYON has located you. We've added something to help us keep in touch."
