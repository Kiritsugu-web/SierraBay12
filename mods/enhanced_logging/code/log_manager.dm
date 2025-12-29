// Enhanced Logging System - Log Manager
// Handles initialization and management of multiple specialized log files

/proc/initialize_enhanced_logs()
	if(!GLOB.log_directory)
		log_debug("Enhanced Logging: Cannot initialize - log_directory not set!")
		return FALSE

	var/log_base = GLOB.log_directory

	// Initialize core log files
	GLOB.world_game_log = "[log_base]/game.log"
	GLOB.world_admin_log = "[log_base]/admin.log"
	GLOB.world_attack_log = "[log_base]/attack.log"
	GLOB.world_access_log = "[log_base]/access.log"

	// Initialize chat log files
	GLOB.world_say_log = "[log_base]/say.log"
	GLOB.world_ooc_log = "[log_base]/ooc.log"
	GLOB.world_whisper_log = "[log_base]/whisper.log"
	GLOB.world_emote_log = "[log_base]/emote.log"

	// Initialize admin log files
	GLOB.world_adminchat_log = "[log_base]/adminchat.log"
	GLOB.world_adminwarn_log = "[log_base]/adminwarn.log"
	GLOB.world_vote_log = "[log_base]/vote.log"

	// Initialize technical log files
	GLOB.world_debug_log = "[log_base]/debug.log"
	GLOB.world_signal_log = "[log_base]/signals.log"
	GLOB.world_computer_log = "[log_base]/computer.log"

	// Write headers to all log files
	start_log(GLOB.world_game_log, "Game Events")
	start_log(GLOB.world_admin_log, "Admin Actions")
	start_log(GLOB.world_attack_log, "Combat & Damage")
	start_log(GLOB.world_access_log, "Access & Authentication")
	start_log(GLOB.world_say_log, "IC Speech")
	start_log(GLOB.world_ooc_log, "OOC Chat")
	start_log(GLOB.world_whisper_log, "Whispers")
	start_log(GLOB.world_emote_log, "Emotes")
	start_log(GLOB.world_adminchat_log, "Admin Chat")
	start_log(GLOB.world_adminwarn_log, "Admin Warnings")
	start_log(GLOB.world_vote_log, "Voting")
	start_log(GLOB.world_debug_log, "Debug Messages")
	start_log(GLOB.world_signal_log, "Signals")
	start_log(GLOB.world_computer_log, "Computer Commands")

	log_misc("Enhanced Logging: Initialized 14 log files in [log_base]")
	return TRUE

/proc/start_log(filepath, category_name = "Log")
	if(!filepath)
		return FALSE

	// Write header with round information
	rustg_log_write_formatted(filepath, "========================================")
	rustg_log_write_formatted(filepath, "  [category_name]")
	rustg_log_write_formatted(filepath, "  Round ID: [GLOB.round_id]")
	rustg_log_write_formatted(filepath, "  Started: [time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]")
	if(GLOB.using_map)
		rustg_log_write_formatted(filepath, "  Map: [GLOB.using_map.name]")
	rustg_log_write_formatted(filepath, "  Port: [world.port]")
	if(GLOB.legacy_game_id)
		rustg_log_write_formatted(filepath, "  Legacy ID: [GLOB.legacy_game_id]")
	rustg_log_write_formatted(filepath, "========================================")

	return filepath
