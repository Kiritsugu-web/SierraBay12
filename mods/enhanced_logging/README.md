# Enhanced Logging System

**Модернизированная система логирования для SierraBay12**

## Описание

Enhanced Logging System заменяет старую систему логирования с криптичными hex ID раундов на современную систему с последовательными номерами раундов и множественными специализированными лог-файлами.

### Основные возможности

- ✅ **Последовательные Round ID**: Раунды нумеруются как `round-1`, `round-2`, `round-3` через MySQL AUTO_INCREMENT
- ✅ **Timestamp Fallback**: Если БД недоступна, используется формат `round-2025-12-29 14.30.15`
- ✅ **14+ специализированных лог-файлов** вместо одного game.log
- ✅ **Обратная совместимость**: все записи дублируются в game.log
- ✅ **Модульная архитектура**: легко включить/отключить через global_modpacks.dm

## Структура логов

### С MySQL (рекомендуется)
```
data/logs/
└── 2025/
    └── 12/
        └── 29/
            ├── round-1/
            │   ├── game.log         # Все события (для совместимости)
            │   ├── admin.log        # Админские действия
            │   ├── attack.log       # Атаки и урон
            │   ├── access.log       # Логин/логаут
            │   ├── say.log          # IC речь
            │   ├── ooc.log          # OOC чат
            │   ├── whisper.log      # Шёпот
            │   ├── emote.log        # Эмоции
            │   ├── adminchat.log    # Админ-чат
            │   ├── adminwarn.log    # Предупреждения админов
            │   ├── vote.log         # Голосования
            │   ├── debug.log        # Отладка
            │   ├── signals.log      # Сигналы (Sierra-specific)
            │   └── computer.log     # Команды компьютеров
            ├── round-2/
            └── round-3/
```

### Без MySQL (timestamp формат)
```
data/logs/
└── 2025/
    └── 12/
        └── 29/
            ├── round-2025-12-29 14.30.15/
            │   └── (те же лог-файлы)
            └── round-2025-12-29 16.45.32/
```

## Установка

### 1. Включен по умолчанию

Мод автоматически включен в `mods/global_modpacks.dm`. Если вы хотите его отключить:

```dm
// В mods/global_modpacks.dm - закомментируйте строку:
// #include "enhanced_logging/_enhanced_logging_includes.dm"
```

### 2. Настройка MySQL (опционально, но рекомендуется)

Для использования последовательных Round ID нужно:

#### Шаг 1: Импортируйте SQL схему
```bash
mysql -u your_user -p your_database < mods/enhanced_logging/sql/enhanced_logging_schema.sql
```

Это создаст таблицу `rounds` с AUTO_INCREMENT полем `round_id`.

#### Шаг 2: Настройте dbconfig.txt
```
# config/dbconfig.txt
SQL_ENABLED
address localhost
port 3306
feedback_database your_database
feedback_login your_user
feedback_password your_password
```

Мод автоматически попробует использовать MySQL при запуске сервера. Если подключение не удастся, система автоматически переключится на timestamp формат.

## Принцип работы

### Round ID Generation

1. **При старте сервера** вызывается `generate_round_id()`
2. **Если MySQL доступна**:
   - Вставляет новую запись в `rounds` table
   - Получает AUTO_INCREMENT ID (1, 2, 3...)
   - Устанавливает `GLOB.round_id`
3. **Если MySQL недоступна**:
   - Генерирует timestamp: `2025-12-29 14.30.15`
   - Устанавливает `GLOB.round_id`
4. Старый hex ID сохраняется в `GLOB.legacy_game_id` для миграции

### Multi-File Logging

Каждая категория логов имеет свою процедуру:
- `log_admin(text)` → `admin.log` + `game.log`
- `log_attack(text)` → `attack.log` + `game.log`
- `log_say(text)` → `say.log` + `game.log`
- И т.д.

Все записи **дублируются** в `game.log` для обратной совместимости с внешними инструментами.

## Категории логов

### Базовые логи (5 файлов)
- `game.log` - Общие игровые события
- `admin.log` - Админские действия
- `attack.log` - Атаки и урон
- `access.log` - Логин/логаут/доступ
- `runtime.log` - Runtime ошибки (обрабатывается отдельно через world.log)

### Чат логи (4 файла)
- `say.log` - IC речь
- `ooc.log` - OOC чат
- `whisper.log` - Шёпот
- `emote.log` - Эмоции

### Админские логи (3 файла)
- `adminchat.log` - Админ-чат
- `adminwarn.log` - Предупреждения админов
- `vote.log` - Голосования

### Технические логи (3 файла)
- `debug.log` - Отладочные сообщения
- `signals.log` - Сигналы (Sierra-specific feature)
- `computer.log` - Команды компьютеров

## Backwards Compatibility

### Для внешних скриптов
Все записи **дублируются** в `game.log`, поэтому старые парсеры логов продолжат работать.

### Для кода сервера
- `game_id` теперь содержит friendly Round ID
- `GLOB.legacy_game_id` содержит старый hex ID
- Все существующие `log_*()` процедуры работают как раньше

## Примеры использования

### В коде сервера
```dm
// Логирование работает так же, как и раньше:
log_admin("Admin [key_name(usr)] spawned [obj]")
log_attack("[attacker] attacked [victim] with [weapon]")
log_say("[key_name(src)] said: [message]")

// Теперь каждое сообщение идёт в специализированный лог И в game.log
```

### Просмотр логов
```bash
# Последний раунд
ls -lt data/logs/2025/12/29/ | head -1

# Содержимое раунда
ls data/logs/2025/12/29/round-15/

# Просмотр атак
cat data/logs/2025/12/29/round-15/attack.log

# Просмотр админских действий
cat data/logs/2025/12/29/round-15/admin.log
```

## Troubleshooting

### Round ID всегда timestamp формат
**Проблема**: Round ID имеет вид `2025-12-29 14.30.15` вместо `1`, `2`, `3`

**Решения**:
1. Проверьте настройку MySQL в `config/dbconfig.txt`
2. Убедитесь что таблица `rounds` существует в БД
3. Проверьте логи сервера на сообщения вида "Enhanced Logging: Failed to connect to database"

### Лог-файлы не создаются
**Проблема**: В папке раунда нет специализированных логов

**Решения**:
1. Убедитесь что мод включен в `mods/global_modpacks.dm`
2. Проверьте что rust_g библиотека установлена (`librust_g.so` или `rust_g.dll`)
3. Проверьте права доступа на директорию `data/logs/`

### Дублирование записей в game.log
**Это норма!** Все записи специально дублируются в `game.log` для обратной совместимости.

## SQL Query Examples

### Статистика раундов
```sql
SELECT
    COUNT(*) as total_rounds,
    MIN(start_datetime) as first_round,
    MAX(start_datetime) as last_round,
    map_name,
    COUNT(*) as rounds_per_map
FROM rounds
GROUP BY map_name;
```

### Последние 10 раундов
```sql
SELECT round_id, start_datetime, end_datetime, map_name, server_port
FROM rounds
ORDER BY start_datetime DESC
LIMIT 10;
```

### Поиск раунда по legacy ID
```sql
SELECT round_id, start_datetime, map_name
FROM rounds
WHERE legacy_game_id = '321b5966';
```

## Изменения core кода

### Файл: `code/game/world.dm`
- **Процедура:** `/world/proc/SetupLogs()`
- **Изменения:**
  - Добавлена генерация round ID перед созданием директории
  - Сохранение legacy hex ID в `GLOB.legacy_game_id`
  - Использование `GLOB.round_id` вместо `game_id` для названия папки
  - Вызов `initialize_enhanced_logs()` для создания всех лог-файлов
- **Маркеры:** `[SIERRA-EDIT]` и `[SIERRA-ADD]` с ID `ENHANCED_LOGGING`

## Технические детали

- **Язык**: DM (Dream Maker)
- **Зависимости**: rust_g (для file I/O), MySQL (опционально)
- **Производительность**: Минимальное влияние (<100ms при инициализации)
- **Кодировка**: UTF-8 (поддержка русского текста)
- **Совместимость**: BYOND 516+

## Авторы

- **SierraBay12 Team**
- Основано на системе логирования из [Shiptest](https://github.com/shiptest-ss13/Shiptest)

## Лицензия

GPL-3.0 (как и основной проект SierraBay12)
