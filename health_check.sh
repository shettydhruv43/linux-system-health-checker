#!/bin/bash
VERSION="1.1.0"

WARN_DISK=80
CRIT_DISK=90
OUTPUT_DIR="."
EXIT_STATUS=0
show_help() {
  echo "Linux System Health Checker (v$VERSION)"
  echo "Usage: ./health_check.sh [options]"
  echo ""
  echo "Options:"
  echo "  -w, --warn <percent>     Disk warning threshold (default: 80)"
  echo "  -c, --crit <percent>     Disk critical threshold (default: 90)"
  echo "  -o, --output <dir>       Output directory for report"
  echo "  -h, --help               Show this help message"
  echo ""
  echo "Exit codes:"
  echo "  0 OK"
  echo "  1 WARNING"
  echo "  2 CRITICAL"
  echo "  3 UNKNOWN"
}

# ======================================
# Linux System Health Checker Script
# Author: Dhruv Shetty
# Description:
# This script collects system health information
# like uptime, memory usage, disk usage,
# CPU load, and logged-in users.
# ======================================

# Create a timestamped report file
TIMESTAMP=$(date +"%F_%H-%M-%S")

# -------- Argument Parsing --------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -w|--warn) WARN_DISK="$2"; shift 2 ;;
    -c|--crit) CRIT_DISK="$2"; shift 2 ;;
    -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; echo "Use --help"; exit 3 ;;
  esac
done

# Validate thresholds
if ! [[ "$WARN_DISK" =~ ^[0-9]+$ ]] || ! [[ "$CRIT_DISK" =~ ^[0-9]+$ ]]; then
  echo "WARN and CRIT must be numbers."
  exit 3
fi

if (( WARN_DISK >= CRIT_DISK )); then
  echo "WARN must be less than CRIT."
  exit 3
fi

mkdir -p "$OUTPUT_DIR"
REPORT="${OUTPUT_DIR}/health_report_${TIMESTAMP}.txt"



echo "======================================"
echo "     Linux System Health Report"
echo "======================================"
echo "Generated on: $(date)"
echo ""

# Check system uptime information
echo "----- SYSTEM UPTIME -----" >> $REPORT
uptime >> $REPORT
echo ""

# Chcek memory usage
echo "----- MEMORY USAGE -----" >> $REPORT
free -h >> $REPORT
echo ""

# Check disk usage of mounted filesystems (with thresholds)
echo "----- DISK USAGE -----" >> $REPORT
df -P -h | awk 'NR==1 || $1 ~ "^/dev"' >> $REPORT
echo "" >> $REPORT

# Disk threshold checks
while read -r fs size used avail use mount; do
  usage=${use%\%}

  if (( usage >= CRIT_DISK )); then
    echo "CRITICAL: $mount is at ${usage}% used" >> $REPORT
    EXIT_STATUS=2
  elif (( usage >= WARN_DISK )) && (( EXIT_STATUS < 2 )); then
    echo "WARNING: $mount is at ${usage}% used" >> $REPORT
    EXIT_STATUS=1
  fi
done < <(df -P -h | awk 'NR>1 && $1 ~ "^/dev"')

echo "" >> $REPORT


# Capture CPU load and running processes
echo "----- CPU LOAD -----" >> $REPORT
top -bn1 | head -n 5 >> $REPORT
echo ""

# List currently logged-in users
echo "----- LOGGED-IN USERS -----" >> $REPORT
who >> $REPORT
echo ""

exit $EXIT_STATUS
