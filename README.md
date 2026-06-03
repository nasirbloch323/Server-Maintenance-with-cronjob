
Automating Server Maintenance Tasks
with Cronjobs
🎯 Objective
The objective of this guide is to automate essential server maintenance tasks using
cronjobs on Linux-based systems.
Industry Scenario
As a DevOps engineer at a company managing a SaaS web application on Linux servers, your
goal is to automate key system maintenance tasks to ensure reliability, performance, and
minimal manual effort. These tasks include:
● ✅ Regular database backups
● ✅ Log file rotation
● ✅ Disk space monitoring with alerting
● ✅ Temporary files cleanup
To achieve this, we'll use cronjobs, which allow scheduled execution of scripts and commands
on Linux-based systems.
📌 Task 1: Understanding Cron and Crontab
🧠 What Are They?
● cron: A time-based job scheduler for running tasks automatically in the background.
● crontab: A file that contains the list of commands to be executed on a schedule defined
using the cron syntax.
🗂️ Types of Crontabs
● User Crontab:
Edit using: crontab -e
Miseacademy
Used for personal scheduled tasks.
● System-Wide Crontab:
Located at /etc/crontab or in /etc/cron.* directories
Used for system-level scheduling.
🕒 Cron Schedule Format
* * * * * /path/to/command
| | | | |
| | | | └── Day of the Week (0–6, Sunday=0)
| | | └──── Month (1–12)
| | └────── Day of the Month (1–31)
| └──────── Hour (0–23)
└────────── Minute (0–59)
🛠️ Task 2: Automate Daily Database Backups
📘 Scenario
Take a backup of the database every day at 2:00 AM, save it in /backups, and delete backups
older than 7 days.
🔧 Step 1: Create the Script
File: file_backup.sh
#!/bin/bash
# === CONFIGURATION ===
SOURCE_DIR="file.db" # Directory you want to back up
BACKUP_DIR="$HOME/backups" # Where to store the
backups
TIMESTAMP=$(date +%F-%H-%M) # e.g., 2025-06-12-14-30
BACKUP_NAME="documents-$TIMESTAMP.tar.gz" # Backup filename
# === CREATE BACKUP ===
Miseacademy
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"
# === CLEANUP OLD BACKUPS (older than 7 days) ===
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -delete
echo "Backup completed: $BACKUP_DIR/$BACKUP_NAME"
🛡️ Make It Executable
chmod +x file_backup.sh
📅 Step 2: Add to Crontab
● Using this command to open a : crontab -e
0 2 * * * file_backup.sh >> /var/log/file_backup.log 2>&1
Explanation:
● 0 2 * * *: Runs daily at 2:00 AM
● >> /var/log/file_backup.log 2>&1: Appends output and errors to log
📂 Task 3: Weekly Log File Rotation
📘 Scenario
App logs grow fast. Rotate them weekly on Sunday at 3:00 AM to prevent disk bloat.
🔧 Step 1: Use Logrotate Tool
Command:
/usr/sbin/logrotate /etc/logrotate.conf
Miseacademy
● logrotate handles rotating, compressing, and deleting logs per rules in
/etc/logrotate.conf.
📅 Step 2: Add to Crontab
0 3 * * 0 /usr/sbin/logrotate /etc/logrotate.conf
Command Purpose
/usr/sbin/logrotate Run the logrotate tool
/etc/logrotate.conf Main configuration file that defines how
logs should be managed
Explanation:
● 0 3 * * 0: Runs at 3:00 AM every Sunday (0 = Sunday)
💾 Task 4: Disk Space Monitoring and Alerts
📘 Scenario
Check disk space every 6 hours and send email alert if it exceeds 80% usage.
🔧 Step 1: Create the Script
File: check_disk.sh
#!/bin/bash
THRESHOLD=80
USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g') # Get disk
usage %
Miseacademy
if [ "$USAGE" -gt "$THRESHOLD" ]; then
echo "Disk usage critical: $USAGE%"
fi
🛡️ Make It Executable
chmod +x check_disk.sh
📅 Step 2: Add to Crontab
0 */6 * * * /check_disk.sh
Explanation:
● */6: Every 6 hours
● mail -s: Sends alert email (ensure mailx is installed)
🧹 Task 5: Clean Temporary Files
📘 Scenario
Automatically clean files older than 1 day from /tmp every night at midnight.
📅 Add to Crontab
0 0 * * * find /tmp -type f -mtime +1 -delete
Explanation:
● find /tmp: Searches /tmp
● -type f: Targets files
● -mtime +1: Modified more than 1 day ago
● -delete: Deletes them
Miseacademy
✅ Conclusion: Why Automate with Cronjobs?
Automating routine system tasks using cronjobs is a foundational DevOps skill that ensures:
● ✅ Reliability – Critical tasks like backups and monitoring run consistently without
human error.
● ✅ Efficiency – Frees up time by handling repetitive operations like log rotation and
temp file cleanup.
● ✅ Proactive Monitoring – Early warnings for disk space issues help prevent outages.
● ✅ System Hygiene – Regular cleanup keeps servers optimized and reduces storage
costs.
By implementing these cron-based automations, you ensure your Linux-based infrastructure
runs smoothly, securely, and predictably — forming the backbone of a stable SaaS environment.
