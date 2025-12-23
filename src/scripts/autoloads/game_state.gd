extends Node
## GameState autoload singleton
## Manages global game state including unlocked levels, stars, and player options

# Level progression data
var levels_data: Dictionary = {}  # Format: { "level_id": { "stars": [bool, bool, bool, bool], "unlocked": bool } }
var total_stars: int = 0

# Player options
var master_volume: float = 1.0
var music_volume: float = 0.8
var sfx_volume: float = 1.0
var show_timer: bool = true

# Save file path
const SAVE_FILE_PATH = "user://game_save.json"


func _ready() -> void:
	print("GameState initialized")
	load_game()


## Initialize a level's data if it doesn't exist
func initialize_level(level_id: String) -> void:
	if not levels_data.has(level_id):
		levels_data[level_id] = {
			"stars": [false, false, false, false],  # [completion, statue_3star, statue_2star, time_star]
			"unlocked": false,
			"best_statues": 999,  # Track best statue count
			"best_time": 999.0    # Track best time
		}


## Unlock a specific level
func unlock_level(level_id: String) -> void:
	initialize_level(level_id)
	levels_data[level_id]["unlocked"] = true
	save_game()


## Check if a level is unlocked
func is_level_unlocked(level_id: String) -> bool:
	if not levels_data.has(level_id):
		return false
	return levels_data[level_id]["unlocked"]


## Update stars for a level
## star_index: 0 = completion, 1 = statue 3-star, 2 = statue 2-star, 3 = time star
func award_star(level_id: String, star_index: int) -> void:
	initialize_level(level_id)
	if not levels_data[level_id]["stars"][star_index]:
		levels_data[level_id]["stars"][star_index] = true
		total_stars += 1
		save_game()


## Update level completion with statue count and time
func complete_level(level_id: String, statues_used: int, time_taken: float, 
					statue_thresholds: Array, time_threshold: float) -> Dictionary:
	initialize_level(level_id)
	
	var result = {
		"new_stars": [],
		"total_stars_for_level": 0
	}
	
	# Award completion star (always awarded)
	if not levels_data[level_id]["stars"][0]:
		award_star(level_id, 0)
		result["new_stars"].append(0)
	
	# Update best statue count
	if statues_used < levels_data[level_id]["best_statues"]:
		levels_data[level_id]["best_statues"] = statues_used
	
	# Award statue-based stars
	# statue_thresholds should be [3_star_threshold, 2_star_threshold]
	if statue_thresholds.size() >= 2:
		# 3-star threshold (most restrictive)
		if statues_used <= statue_thresholds[0]:
			if not levels_data[level_id]["stars"][1]:
				award_star(level_id, 1)
				result["new_stars"].append(1)
		
		# 2-star threshold
		if statues_used <= statue_thresholds[1]:
			if not levels_data[level_id]["stars"][2]:
				award_star(level_id, 2)
				result["new_stars"].append(2)
	
	# Update best time
	if time_taken < levels_data[level_id]["best_time"]:
		levels_data[level_id]["best_time"] = time_taken
	
	# Award time star
	if time_taken <= time_threshold:
		if not levels_data[level_id]["stars"][3]:
			award_star(level_id, 3)
			result["new_stars"].append(3)
	
	# Count total stars for this level
	for star in levels_data[level_id]["stars"]:
		if star:
			result["total_stars_for_level"] += 1
	
	save_game()
	return result


## Get total stars earned across all levels
func get_total_stars() -> int:
	return total_stars


## Get stars for a specific level
func get_level_stars(level_id: String) -> Array:
	if levels_data.has(level_id):
		return levels_data[level_id]["stars"]
	return [false, false, false, false]


## Save game data to file
func save_game() -> void:
	var save_data = {
		"levels_data": levels_data,
		"total_stars": total_stars,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"show_timer": show_timer
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved successfully")
	else:
		print("Error saving game: ", FileAccess.get_open_error())


## Load game data from file
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No save file found, starting fresh")
		# Unlock the first level by default
		unlock_level("level_1_1")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var save_data = json.data
			levels_data = save_data.get("levels_data", {})
			total_stars = save_data.get("total_stars", 0)
			master_volume = save_data.get("master_volume", 1.0)
			music_volume = save_data.get("music_volume", 0.8)
			sfx_volume = save_data.get("sfx_volume", 1.0)
			show_timer = save_data.get("show_timer", true)
			print("Game loaded successfully")
		else:
			print("Error parsing save file")
	else:
		print("Error loading game: ", FileAccess.get_open_error())


## Reset all game data (for debugging)
func reset_all_data() -> void:
	levels_data.clear()
	total_stars = 0
	unlock_level("level_1_1")
	save_game()
	print("All game data reset")
