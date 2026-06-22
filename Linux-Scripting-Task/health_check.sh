#!/bin/bash

# Script Name: health_check.sh
# Purpose: System health monitoring
# Checks:
# 1. Disk usage
# 2. Memory usage
# 3. Docker service status
# 4. Logs output to timestamped file
# 5. Returns exit code 1 if disk usage exceeds 80%

# Log file with timestamp

LOGFILE="health_check_$(date +%Y%m%d_%H%M%S).log"


# Check log file creation
if ! touch "$LOGFILE"
then
    echo "Cannot create log file"
    exit 1
fi


echo "System Health Check" > "$LOGFILE"
echo "Time: $(date)" >> "$LOGFILE"
echo "------------------------" >> "$LOGFILE"


# 1. Check Disk Usage

echo "Disk Usage:" >> "$LOGFILE"

if df -h >> "$LOGFILE"
then
    echo "Disk check completed" >> "$LOGFILE"
else
    echo "Disk check failed" >> "$LOGFILE"
fi


DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "" >> "$LOGFILE"
echo "Current Disk Usage: ${DISK_USAGE}%" >> "$LOGFILE"


# 2. Check Memory Usage

echo "" >> "$LOGFILE"
echo "Memory Usage:" >> "$LOGFILE"

if free -h >> "$LOGFILE"
then
    echo "Memory check completed" >> "$LOGFILE"
else
    echo "Memory check failed" >> "$LOGFILE"
fi


# 3. Check Docker Service

echo "" >> "$LOGFILE"

if systemctl is-active --quiet docker
then
    echo "Docker Status: Running" >> "$LOGFILE"
else
    echo "Docker Status: Not Running" >> "$LOGFILE"
fi


# 4. Check Disk Usage Limit

if [ "$DISK_USAGE" -gt 80 ]
then
    echo "Disk usage is above 80%" >> "$LOGFILE"
    exit 1
else
    echo "Disk usage is normal" >> "$LOGFILE"
    exit 0
fi
