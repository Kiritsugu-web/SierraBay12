// Enhanced Logging System - Logging Procedures Extension
// Extends core logging procedures to write to specialized log files
// All procedures call parent ..() and then add specialized file writing

// Core Logging Procedures

/proc/log_admin(text)
	. = ..()  // Call parent (writes to game.log in old system)
	if(GLOB.world_admin_log)
		rustg_log_write_formatted(GLOB.world_admin_log, "ADMIN: [text]")

/proc/log_attack(text)
	. = ..()
	if(GLOB.world_attack_log)
		rustg_log_write_formatted(GLOB.world_attack_log, "ATTACK: [text]")

/proc/log_access(text)
	. = ..()
	if(GLOB.world_access_log)
		rustg_log_write_formatted(GLOB.world_access_log, "ACCESS: [text]")

/proc/log_game(text)
	. = ..()
	// game.log уже записывается родителем через game_log() в core

// Chat Logging Procedures

/proc/log_say(text)
	. = ..()
	if(GLOB.world_say_log)
		rustg_log_write_formatted(GLOB.world_say_log, "SAY: [text]")

/proc/log_ooc(text)
	. = ..()
	if(GLOB.world_ooc_log)
		rustg_log_write_formatted(GLOB.world_ooc_log, "OOC: [text]")

/proc/log_whisper(text)
	. = ..()
	if(GLOB.world_whisper_log)
		rustg_log_write_formatted(GLOB.world_whisper_log, "WHISPER: [text]")

/proc/log_emote(text)
	. = ..()
	if(GLOB.world_emote_log)
		rustg_log_write_formatted(GLOB.world_emote_log, "EMOTE: [text]")

// Admin Logging Procedures

/proc/log_adminsay(text)
	. = ..()
	if(GLOB.world_adminchat_log)
		rustg_log_write_formatted(GLOB.world_adminchat_log, "ADMINSAY: [text]")

/proc/log_adminwarn(text)
	. = ..()
	if(GLOB.world_adminwarn_log)
		rustg_log_write_formatted(GLOB.world_adminwarn_log, "ADMINWARN: [text]")

/proc/log_vote(text)
	. = ..()
	if(GLOB.world_vote_log)
		rustg_log_write_formatted(GLOB.world_vote_log, "VOTE: [text]")

// Technical Logging Procedures

/proc/log_debug(text)
	. = ..()  // Parent already writes to game.log and calls to_debug_listeners
	if(GLOB.world_debug_log)
		rustg_log_write_formatted(GLOB.world_debug_log, "DEBUG: [text]")

/proc/log_signal(text)
	. = ..()
	if(GLOB.world_signal_log)
		rustg_log_write_formatted(GLOB.world_signal_log, "SIGNALS: [text]")

/proc/log_computer_command(text)
	. = ..()
	if(GLOB.world_computer_log)
		rustg_log_write_formatted(GLOB.world_computer_log, "COMPUTER_COMMAND: [text]")
