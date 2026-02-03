#!/bin/bash

# ======================================
# Linux System Health Checker Script
# Author: Dhruv Shetty
# Description:
# This script collects system health information
# like uptime, memory usage, disk usage,
# CPU load, and logged-in users.
# ======================================

# Create a timestamped report file
REPORT="health_report_$(date +%F_%H-%M-%S).txt"
WARN_DISK=80
CRIT_DISK=90
EXIT_STATUS=0

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
