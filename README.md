Linux System Health Checker (Bash)

This project is a Bash-based Linux system health monitoring tool.
It helps system administrators and IT support engineers quickly
check the current health of a Linux system.


## Features

- Displays system uptime
- Shows memory usage
- Shows disk usage for mounted filesystems
- Detects disk usage risks with configurable thresholds:
  - WARNING at 80%
  - CRITICAL at 90%
- Displays CPU load
- Lists currently logged-in users
- Generates timestamped health reports
- Returns monitoring-friendly exit codes for automation

## Command-line Options

- `-w, --warn <percent>`: Disk warning threshold (default: 80)
- `-c, --crit <percent>`: Disk critical threshold (default: 90)
- `-o, --output <dir>`: Output directory for reports (default: current directory)
- `-h, --help`: Show help menu

## Usage

Make the script executable:
```bash
chmod +x health_check.sh

Run with default settings:

./health_check.sh


Show help menu:

./health_check.sh --help


Run with custom disk thresholds:

./health_check.sh --warn 70 --crit 85


Save reports to a specific directory:

./health_check.sh --output reports

##Automation with cron

This script is designed to be automation-ready and can be scheduled using cron.

Example: run the health check every hour and save reports to a directory:

''''bash
0 * * * * /path/to/linux-system-health-checker/health_check.sh --output /path/to/reports
