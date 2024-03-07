#!/bin/bash

# Konfigurasi Remote MySQL
remote_host="172.17.4.40"
remote_user="zabbix"
remote_password="varnionzabbix"
remote_database="zabbix"

# Konfigurasi Lokal MySQL
local_user="root"
local_password="varni0nz4bb1x"

# Direktori sumber untuk folder
# Konfigurasi direktori sumber
source_dirs=(
  "/etc/zabbix"
  "/etc/apache2"
  "/etc/apache2"
  "/usr/share/zabbix"
  "/usr/share/doc/zabbix-web-service"
  "/usr/share/doc/zabbix-sql-scripts"
  "/usr/share/doc/zabbix-server-mysql"
  "/usr/share/doc/zabbix-release"
  "/usr/share/doc/zabbix-frontend-php"
  "/usr/share/doc/apache-conf"
  "/usr/share/doc/zabbix-agent2"
  "/etc"
)

# Konfigurasi direktori tujuan
dest_dirs=(
  "/opt/zabbix-backup/zabbix-config"
  "/opt/zabbix-backup/web-config/apache2"
  "/opt/zabbix-backup/shared/zabbix"
  "/opt/zabbix-backup/shared/doc"
)

# Tanggal dan waktu
date_time=$(date +"%Y-%m-%d_%H-%M")

# Backup remote database MySQL
ssh "$remote_user@$remote_host" mysqldump -h "$remote_host" -u "$remote_user" -p"$remote_password" "$remote_database" > "$dest_dir/remote_mysql_backup_${date_time}.sql"

# Backup folder dengan nama yang cocok
for (( i=0; i<${#source_dirs[@]}; i++ )); do
  source_dir="${source_dirs[$i]}"
  dest_dir="${dest_dirs[$i]}"
  filename="${source_dir##*/}_${date_time}.tar.gz"
  tar -czf "$dest_dir/$filename" "$source_dir"
done

# Hapus arsip lama (sesuaikan dengan kebutuhan)
find "$dest_dir" -type f -mtime +7 -delete

echo "Backup selesai!"
