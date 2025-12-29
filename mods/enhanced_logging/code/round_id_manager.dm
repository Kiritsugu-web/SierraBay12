// Enhanced Logging System - Round ID Manager
// Generates sequential round IDs via MySQL AUTO_INCREMENT or timestamp fallback

/proc/generate_round_id()
	// Try MySQL database connection first
	if(sqlenabled && dbcon && dbcon.IsConnected())
		return generate_round_id_from_database()

	// Fallback to timestamp format if DB unavailable
	return generate_round_id_from_timestamp()

/proc/generate_round_id_from_database()
	try
		// Insert new round into database with AUTO_INCREMENT
		var/DBQuery/query_insert = dbcon.NewQuery(
			"INSERT INTO rounds (start_datetime, map_name, server_port, legacy_game_id) VALUES (NOW(), :map, :port, :legacy_id)"
		)

		// Build safe query with parameters
		var/map_name = GLOB.using_map ? GLOB.using_map.name : "unknown"
		var/safe_map = dbcon.Quote(map_name)
		var/safe_legacy = dbcon.Quote(game_id)

		// Execute with proper escaping
		query_insert.sql = "INSERT INTO rounds (start_datetime, map_name, server_port, legacy_game_id) VALUES (NOW(), [safe_map], [world.port], [safe_legacy])"

		if(!query_insert.Execute())
			log_debug("Enhanced Logging: Failed to insert round into database: [query_insert.ErrorMsg()]")
			return generate_round_id_from_timestamp()

		// Get the AUTO_INCREMENT ID
		var/DBQuery/query_id = dbcon.NewQuery("SELECT LAST_INSERT_ID() as round_id")
		if(!query_id.Execute())
			log_debug("Enhanced Logging: Failed to get LAST_INSERT_ID: [query_id.ErrorMsg()]")
			return generate_round_id_from_timestamp()

		if(query_id.NextRow())
			GLOB.round_id = "[query_id.item[1]]"  // Convert to string
			log_misc("Enhanced Logging: Round ID [GLOB.round_id] generated from database")
			return GLOB.round_id

		log_debug("Enhanced Logging: No row returned from LAST_INSERT_ID()")
		return generate_round_id_from_timestamp()

	catch
		log_debug("Enhanced Logging: Exception during database round ID generation")
		return generate_round_id_from_timestamp()

/proc/generate_round_id_from_timestamp()
	// Format: "2025-12-29 14.30.15"
	// Using dots instead of colons to avoid filesystem issues on Windows
	GLOB.round_id = time2text(world.realtime, "YYYY-MM-DD hh.mm.ss")
	log_misc("Enhanced Logging: Round ID '[GLOB.round_id]' generated from timestamp (database unavailable)")
	return GLOB.round_id
