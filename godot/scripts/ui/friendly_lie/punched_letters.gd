class_name PunchedLetters
extends Control

# Five columns, with each row stored as a five-bit mask.
const GLYPHS := {
 "A": [14,17,17,31,17,17,17], "G": [14,17,16,23,17,17,15],
 "K": [17,18,20,24,20,18,17], "L": [16,16,16,16,16,16,31],
 "N": [17,25,21,19,17,17,17], "P": [30,17,17,30,16,16,16],
 "S": [15,16,16,14,1,1,30], "U": [17,17,17,17,17,17,14],
 "W": [17,17,17,21,21,21,10], "Y": [17,17,10,4,4,4,4],
 "O": [14,17,17,17,17,17,14], "M": [17,27,21,21,17,17,17],
 "E": [31,16,16,30,16,16,31], "H": [17,17,17,31,17,17,17],
 "T": [31,4,4,4,4,4,4], "I": [14,4,4,4,4,4,14],
 "D": [30,17,17,17,17,17,30], "R": [30,17,17,30,20,18,17]
}
var letters: String

func _init(value: String) -> void:
 letters = value
 custom_minimum_size = Vector2(letters.length() * 9, 11)
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 tooltip_text = value

func _draw() -> void:
 for index in letters.length():
  var rows: Array = GLYPHS.get(letters[index], [])
  for row in rows.size():
   for column in 5:
    if rows[row] & (1 << (4 - column)):
     draw_circle(Vector2(index * 9 + column * 1.5 + 1, row * 1.5 + 1), 0.65, FriendlyLook.PAPER)
