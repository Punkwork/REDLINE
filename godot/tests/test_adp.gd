extends SceneTree

func _initialize() -> void:
 var failures := 0
 for row in [[0,0,false,0.0], [19,0,false,0.0], [20,0,false,0.2], [29,0,false,0.2+0.4*9.0/19.0], [39,0,false,0.6], [4,1,false,0.2], [39,1,false,0.6], [20,1,true,0.8], [20,2,false,1.0], [20,3,false,1.0]]:
  if not is_equal_approx(AtomicDecoPunk.target(row[0],row[1],row[2]), row[3]):
   push_error("Unexpected bleed for %s" % str(row)); failures += 1
 for row in [[0.0,false,0.0],[0.1,false,0.15625],[0.4,false,1.0],[0.0,true,1.0]]:
  if not is_equal_approx(AtomicDecoPunk.ease_weight(row[0],row[1]), row[2]):
   push_error("Unexpected easing for %s" % str(row)); failures += 1
 for row in [[20,0.2],[29,0.2+0.4*9.0/19.0],[39,0.6]]:
  if not is_equal_approx(AtomicDecoPunk.reveal(AtomicDecoPunk.target(row[0],0,false)), row[1]):
   push_error("Unexpected hostile reveal for %s" % str(row)); failures += 1
 print("ADP: 17 checks, %d failures" % failures)
 quit(int(failures > 0))
