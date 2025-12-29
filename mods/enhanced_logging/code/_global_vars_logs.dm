// Enhanced Logging System - Global Variables
// Defines global variables for all specialized log files

// Round ID variables
GLOBAL_VAR(round_id)          // Friendly round ID (sequential number or timestamp)
GLOBAL_VAR(legacy_game_id)    // Original hex ID for backwards compatibility

// Core log files (5 files)
GLOBAL_VAR(world_game_log)    // General game events
GLOBAL_VAR(world_admin_log)   // Admin actions
GLOBAL_VAR(world_attack_log)  // Combat and damage
GLOBAL_VAR(world_access_log)  // Login/logout/access
// Note: world_runtime_log handled by world.log in core

// Chat log files (4 files)
GLOBAL_VAR(world_say_log)     // IC speech
GLOBAL_VAR(world_ooc_log)     // OOC chat
GLOBAL_VAR(world_whisper_log) // Whispers
GLOBAL_VAR(world_emote_log)   // Emotes

// Admin log files (3 files)
GLOBAL_VAR(world_adminchat_log)  // Admin chat
GLOBAL_VAR(world_adminwarn_log)  // Admin warnings
GLOBAL_VAR(world_vote_log)       // Voting

// Technical log files (3 files)
GLOBAL_VAR(world_debug_log)      // Debug messages
GLOBAL_VAR(world_signal_log)     // Signals (Sierra-specific feature)
GLOBAL_VAR(world_computer_log)   // Computer commands
