#!/bin/bash

echo "======================================"
echo "     Linux System Health Report"
echo "======================================"
echo "Generated on: $(date)"
echo ""

echo "----- SYSTEM UPTIME -----"
uptime
echo ""

echo "----- MEMORY USAGE -----"
free -h
echo ""

echo "----- DISK USAGE -----"
df -h
echo ""

echo "----- CPU LOAD -----"
top -bn1 | head -n 5
echo ""

echo "----- LOGGED-IN USERS -----"
who
echo ""
