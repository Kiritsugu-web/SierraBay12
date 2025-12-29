// Enhanced Logging System - Modpack Singleton
// Modernizes the logging system with sequential round IDs and multi-file logs

/singleton/modpack/enhanced_logging
	name = "Enhanced Logging System"
	desc = "Модернизирует систему логирования с последовательными ID раундов и множественными специализированными лог-файлами"
	author = "SierraBay12 Team"

/singleton/modpack/enhanced_logging/pre_initialize()
	// Validation phase - check if rust_g is available
	. = ..()  // Call parent
	if(.)
		return .  // Return error from parent if any

	if(!fexists("./librust_g.so") && !fexists("./rust_g.dll"))
		log_error("Enhanced Logging: rust_g library not found! Logging system requires rust_g.")
		return "rust_g library not found"

	log_misc("Enhanced Logging: Pre-initialization checks passed")

/singleton/modpack/enhanced_logging/initialize()
	// Setup phase - this runs during world initialization
	. = ..()  // Call parent

	// Note: Actual log initialization happens in SetupLogs() override

	if(GLOB.round_id)
		log_misc("Enhanced Logging: Round ID '[GLOB.round_id]' generated successfully")
	else
		log_warning("Enhanced Logging: Round ID not generated yet - will be initialized in SetupLogs()")

	if(sqlenabled && dbcon && dbcon.IsConnected())
		log_misc("Enhanced Logging: Database mode ENABLED - using sequential round IDs")
	else
		log_misc("Enhanced Logging: Database mode DISABLED - using timestamp-based round IDs")

/singleton/modpack/enhanced_logging/post_initialize()
	// Final setup phase after other mods
	. = ..()  // Call parent

	var/log_count = 0

	// Count initialized log files
	if(GLOB.world_game_log) log_count++
	if(GLOB.world_admin_log) log_count++
	if(GLOB.world_attack_log) log_count++
	if(GLOB.world_access_log) log_count++
	if(GLOB.world_say_log) log_count++
	if(GLOB.world_ooc_log) log_count++
	if(GLOB.world_whisper_log) log_count++
	if(GLOB.world_emote_log) log_count++
	if(GLOB.world_adminchat_log) log_count++
	if(GLOB.world_adminwarn_log) log_count++
	if(GLOB.world_vote_log) log_count++
	if(GLOB.world_debug_log) log_count++
	if(GLOB.world_signal_log) log_count++
	if(GLOB.world_computer_log) log_count++

	log_debug("Enhanced Logging: [log_count] specialized log files initialized")

	if(log_count > 0)
		log_misc("Enhanced Logging: System fully operational")
	else
		log_warning("Enhanced Logging: No log files initialized - check configuration")
