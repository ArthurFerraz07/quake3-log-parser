# Quake 3 log parser

## Pre-requisites


## Usage


## Output
### Format
### Example



## Running tests



## Architecture


"Application is running!"
"Started at: 2023-09-25 11:29:10 -0300"
"[1695652150] - Starting reading log file..."
"[1695652157] - Finished reading log file"
"[1695652173] - Starting proccessing report..."
"[1695652174] - Report proccessed successfully"

times = [1695652150,
1695652157,
1695652173,
1695652174]

times.each { |time| p Time.at(time) }
