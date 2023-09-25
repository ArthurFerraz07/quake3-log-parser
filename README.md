# Quake 3 log parser

## Pre-requisites
- Docker 23.0.5
- Dockr Compose 2.17.3

## Usage
- Clone this repository
- [optional] For custom logs, paste your log file in input/tmp folder
- [optional] For custom logs, creates a .env with LOG_FILE variable to set your log file name with the tmp path (e.g. LOG_FILE=tmp/your_lo.txt)
- Run `docker-compose up` to start the application

## Output
The "runner" application will print on runner logs the following messages:

```txt
"[2023-09-25 16:30:58 +0000] - Starting reading log file..."
"[2023-09-25 16:30:58 +0000] - Finished reading log file"
"[2023-09-25 16:30:58 +0000] - Starting proccessing report..."
"[2023-09-25 16:30:58 +0000] - Report proccessed successfully"
"[2023-09-25 16:30:58 +0000] - ----" # 100 * "-"
"[2023-09-25 16:30:58 +0000] - {{REPORT AS JSON}}"
"[2023-09-25 16:30:58 +0000] - ----" # 100 * "-"
```

The json report will be available on cache with the key "report".

### Report
The report is a JSON with the following structure:

```json
{
  "players_rank": [
    {
      "score": 4,
      "player": "player1"
    },
    {
      "score": 3,
      "player": "player2"
    }
  ],
  "games": [
    {
      "game_1": {
        "total_kills": 7,
        "kills": {
          "player1": 4,
          "player2": 3,

        },
        "players": [
          "player2",
          "player1",
        ]
      }
    }
  ],
  "kills_by_means": [
    {
      "game_1": {
        "MOD_SHOTGUN": 2,
        "MOD_GAUNTLET": 1,
        "MOD_UNKNOWN": 4
      }
    }
  ]
}
```


### Example
```json
{
  "players_rank": [
    {
      "score": 4,
      "player": "joao"
    },
    {
      "score": 3,
      "player": "maria"
    },
    {
      "score": 2,
      "player": "ligia"
    },
    {
      "score": 2,
      "player": "dayana"
    },
    {
      "score": 2,
      "player": "arthur"
    },
    {
      "score": 0,
      "player": "georgia"
    }
  ],
  "games": [
    {
      "game_1": {
        "total_kills": 33,
        "kills": {
          "maria": 3,
          "arthur": 2,
          "georgia": 0,
          "joao": 4,
          "dayana": 2,
          "ligia": 2
        },
        "players": [
          "maria",
          "arthur",
          "georgia",
          "joao",
          "ligia",
          "dayana"
        ]
      }
    }
  ],
  "kills_by_means": [
    {
      "game_1": {
        "MOD_SHOTGUN": 13,
        "MOD_GAUNTLET": 11,
        "MOD_UNKNOWN": 9
      }
    }
  ]
}

```


## Running tests
- Clone this repository
- Go to the project folder
- Run `bundle install`
- Run `bundle exec rspec -f d`

## Architecture

Clean architecture was used to build this application. The main idea is to separate the application in layers, where each layer has a specific responsibility. The layers are:
- Domain: Models containing the enterprise rules 
- Application: Use cases that orchestrate the application flow
- Adapters: Services that interact with external services (e.g. cache, message broker, I/O). Workers and daemons are also included in this layer, because they are responsible provide a way to external services interact with the application
- Runners (UI): User interface that runs the application

### Domain
The domain layer contains the following models:
- Game: Represents a game
- Player: Represents a player
- Kill: Represents a kill
- LogLine: Represents a log line

### Application
The application layer contains the following use cases:
- application.rb: The application singleton class that represents the application execution
- ReadLogFile: Reads the log file and publish each line on a message broker
- MessageBroker: Receives a message from a message broker and orchestrate the actions to process it
- ProcessKill: Receives a LogLine model and process it (parse raw kill, register kill on cache, trigger report generation)
- ParseRawKill: Parses a raw kill line and returns a Kill model
- RegistryKill: Receives a Kill model and register it on cache
- ProccessReport: Collect data from cache and generate a report

### Adapters
- CacheService: Adapter for Redis
- MessageBrokerService: Adapter for RabbitMQ
- LoggerService: Adapter for STDOUT
- FileService: Adapter for file I/O
- ProccessKillWorker: Worker that receives a message from a message broker and send it to ProcessKill use case
- ProccessReportWorker: Worker that receives a message from a message broker and send it to ProccessReport use case
- ReadLogFileWorker: Worker that call ReadLogFile use case
- MessageBrokerDaemon: Daemon that receives a message from a message broker and send it to MessageBroker use case

### Runners (UI)
Basically the runners are the entry points of the application. They are responsible to start the application (and the connect on )

- config.rb: Application configuration (environment variables, libraries, cache and message broker connections, import application files)
- runner.rb: Application runner. Read the log file and publish each line on a message broker
- message_broker.rb: Message broker runner. Receives a message from a message broker and orchestrate the actions to process it

