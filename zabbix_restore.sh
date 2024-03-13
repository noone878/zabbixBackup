#!/bin/bash

# Information Connection MySQL
db_user="mysql_user"
db_password="mysql_password"
db_name="mysql_database"

# Backup Directory
# DB
backup_directoryDB="/opt/zabbix-backup/database"
# Zabbix
backup_directory1="/opt/zabbix-backup/zabbix-config"
# Web-Config
backup_directory2="/opt/zabbix-backup/web-config"
# Shared
backup_directory3="/opt/zabbix-backup/share/zabbix"
# Docs
backup_directory4="/opt/zabbix-backup/share/doc"

# Find New Latest Backup DB
latest_database_backupDB=$(ls -t "$backup_directoryDB"zabbix_mysql_* | head -n 1)

# Find New Latest Backup Folder
# Zabbix
latest_folder_backup1=$(ls -t "$backup_directory1"/zabbix_config_*.tar.gz | head -n 1)
# Web
latest_folder_backup2=$(ls -t "$backup_directory2"/zabbix_apache2_*.tar.gz | head -n 1)
# Shared
latest_folder_backup3=$(ls -t "$backup_directory3"/zabbix_shared_*.tar.gz | head -n 1)
# Docs
latest_folder_backup4=$(ls -t "$backup_directory4"/zabbix_docs_*.tar.gz | head -n 1)


# Check DB / folder Found it?
if [ -z "$latest_database_backupDB" ] || [ -z "$latest_folder_backup1" ] || [ -z "$latest_folder_backup2" ] || [ -z "$latest_folder_backup3" ] || [ -z "$latest_folder_backup4" ]; then
    echo "Cannot find the latest database backup file or folder."
    exit 1
fi

# restore database
mysql -u "$db_user" -p"$db_password" "$db_name" < "$latest_database_backupDB"

# Check the success of the restore
restore_status=$?

# Display a message based on the success of the database restore
if [ $restore_status -eq 0 ]; then
    echo "Restore database $db_name dari $latest_database_backupDB success"
else
    echo "Restore database $db_name dari $latest_database_backupDB fail"
    echo "Information Error:"
    mysql -u "$db_user" -p"$db_password" "$db_name" < "$latest_database_backupDB" 2>&1 | sed 's/^/  /'  # Displays error details with indentation
    exit $restore_status
fi

# restore folder
# Zabbix
restore_destination1="/etc/"
tar -xzf "$latest_folder_backup1" -C "$restore_destination1"
# Web
restore_destination2="/etc/"
tar -xzf "$latest_folder_backup2" -C "$restore_destination2"
# Web
restore_destination3="/usr/share/"
tar -xzf "$latest_folder_backup3" -C "$restore_destination3"
# Docs
restore_destination4=("/usr/share/doc/" "/usr/share/doc/" "/usr/share/doc/" "/usr/share/doc/ "/usr/share/doc/ "/usr/share/doc/" "/usr/share/doc/")

tar -xvpf "$latest_folder_backup4" -C "$restore_destination4"

# Show a message based on successful folder restore
if [ $? -eq 0 ]; then
    echo "Restore folder from $latest_folder_backup1 success in-$restore_destination1"
else
    echo "Restore folder from $latest_folder_backup1 fail"
fi
if [ $? -eq 0 ]; then
    echo "Restore folder from $latest_folder_backup2 success in-$restore_destination2"
else
    echo "Restore folder from $latest_folder_backup2 fail"
fi
if [ $? -eq 0 ]; then
    echo "Restore folder from $latest_folder_backup3 success in-$restore_destination3"
else
    echo "Restore folder from $latest_folder_backup3 fail"
fi

# Docs
for latest_folder_backup4 in "${latest_folder_backups4[@]}"; do
    for restore_destination4 in "${restore_destinations4[@]}"; do
        # restore folder
        tar -xzf "$latest_folder_backup4" -C "$restore_destination4"

        # Show a message based on successful folder restore
        if [ $? -eq 0 ]; then
            echo "Restore folder from $latest_folder_backup4 success in-$restore_destination4"
        else
            echo "Restore folder from $latest_folder_backup4 fail in-$restore_destination4"
        fi
    done
done
