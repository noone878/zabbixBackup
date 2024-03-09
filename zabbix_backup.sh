
# This script was written by: Septian Al Rizki
# https://github.com/noone878

#!/bin/bash

# Source Zabbix direktori 
backup_directories1=("/etc/zabbix")

# Source Web direktori
backup_directories2=("/etc/apache2")

# Source Shared direktori
backup_directories3=("/usr/share/zabbix")

# Doc direktori 
backup_directories4=("/usr/share/doc/zabbix-web-service" "/usr/share/doc/zabbix-sql-scripts" "/usr/share/doc/zabbix-server-mysql" "/usr/share/doc/zabbix-release" "/usr/share/doc/zabbix-frontend-php" "/usr/share/doc/zabbix-apache-conf" "/usr/share/doc/zabbix-agent2")

# Destinations Backup Zabbix
backup_locations1=("/opt/zabbix-backup/zabbix-config")

# Destinations Backup  Web
backup_locations2=("/opt/zabbix-backup/web-config")

# Destinations Backup  Shared
backup_locations3=("/opt/zabbix-backup/share/zabbix")

# Destinations Backup  Doc
backup_locations4="/opt/zabbix-backup/share/doc"
Zabbix_Docs="zabbix_docs_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"


# Information MySQL
local_user="mysql_user"
local_password="mysql_password"
database_name="database_name"


# Destinations Backup DB
backup_locations=("/opt/zabbix-backup/database")

# Similar Name DB
similar_name="zabbix"

# Create name backup with timestamp
backup_file="$backup_locations/zabbix_mysql_$(date +\%Y\%m\%d_\%H\%M\%S).sql"


# Back up the MySQL database from a remote server using mysqldump
mysqldump -h localhost -u "$local_user" -p"$local_password" "$database_name" > "$backup_file"

# Show messages based on backup success
if [ $? -eq 0 ]; then
    echo "Backup database $database_name successfully saved on: $backup_file"
else
    echo "Backup database $database_namee failed"
fi

# Zabbix Config
for ((i=0; i<${#backup_directories1[@]}; i++)); do
    # Create backup file name with timestamp
    zabbix_config="${backup_locations1[$i]}/zabbix_config_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Do a backup using tar
    tar -czf "$zabbix_config" "${backup_directories1[$i]}"

    # show message based on backup success
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories1[$i]} successfully saved on: $zabbix_config"
    else
        echo "Backup untuk ${backup_directories1[$i]} failed"
    fi
done


# Zabbix Web
for ((i=0; i<${#backup_directories2[@]}; i++)); do
    # Create backup file name with timestamp
    zabbix_apache2="${backup_locations2[$i]}/zabbix_apache2_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Do a backup using tar
    tar -czf "$zabbix_apache2" "${backup_directories2[$i]}"

    # show message based on backup success
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories2[$i]} successfully saved on: $zabbix_apache2"
    else
        echo "Backup untuk ${backup_directories2[$i]} failed"
    fi
done


# Zabbix Shared
for ((i=0; i<${#backup_directories3[@]}; i++)); do
    # Create backup file name with timestamp
    zabbix_shared="${backup_locations3[$i]}/zabbix_shared_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Do a backup using tar
    tar -czf "$zabbix_shared" "${backup_directories3[$i]}"

    # show message based on backup success
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories3[$i]} successfully saved on: $zabbix_shared"
    else
        echo "Backup untuk ${backup_directories3[$i]} failed"
    fi
done

# Zabbix Docs
# Create backup file name with timestamp
for ((i=0; i<${#backup_directories4[@]}; i++)); do
  # Add files to archive
  tar -rf "$backup_locations4/$Zabbix_Docs" "${backup_directories4[$i]}"
done

# show message based on backup succes
echo "successfully saved on: $backup_locations4/$Zabbix_Docs"

# Find and delete backup files that are more than 7 days old, except zabbix_backup.sh and directories
find /opt/zabbix-backup/* -type f -mtime +7 ! -name "zabbix_backup.sh" -exec rm {} \;

