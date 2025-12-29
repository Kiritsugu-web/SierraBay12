-- Enhanced Logging System - MySQL Schema
-- Creates the rounds table for sequential round ID tracking

CREATE TABLE IF NOT EXISTS `rounds` (
  `round_id` INT(11) NOT NULL AUTO_INCREMENT,
  `start_datetime` DATETIME NOT NULL,
  `end_datetime` DATETIME DEFAULT NULL,
  `map_name` VARCHAR(64) DEFAULT NULL,
  `server_port` INT(11) DEFAULT NULL,
  `legacy_game_id` VARCHAR(16) DEFAULT NULL COMMENT 'Original hex-based game_id for migration tracking',
  PRIMARY KEY (`round_id`),
  KEY `start_datetime` (`start_datetime`),
  KEY `map_name` (`map_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sequential round ID tracking for enhanced logging';

-- Optional: Create index for faster legacy_game_id lookups during migration
CREATE INDEX `idx_legacy_game_id` ON `rounds` (`legacy_game_id`);
