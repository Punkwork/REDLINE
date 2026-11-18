class_name LocalRecord
extends RefCounted

static func read(path: String) -> Dictionary:
 if not FileAccess.file_exists(path): return {}
 var data = JSON.parse_string(FileAccess.get_file_as_string(path))
 return data if data is Dictionary else {}

static func write(path: String, data: Dictionary) -> bool:
 var temp := path + ".tmp"
 var file := FileAccess.open(temp, FileAccess.WRITE)
 if file == null: return false
 file.store_string(JSON.stringify(data))
 var status := file.get_error()
 file.close()
 if status != OK: return false
 return DirAccess.rename_absolute(temp, path) == OK

static func erase(path: String) -> bool:
 return not FileAccess.file_exists(path) or DirAccess.remove_absolute(path) == OK
