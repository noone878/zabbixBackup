#!/bin/bash

# Zabbix direktori 
backup_directories1=("/etc/zabbix")

# Web direktori
backup_directories2=("/etc/apache2")

# Shared direktori
backup_directories3=("/usr/share/zabbix")

# Doc direktori 
backup_directories4=("/usr/share/doc/zabbix-web-service" "/usr/share/doc/zabbix-sql-scripts" "/usr/share/doc/zabbix-server-mysql" "/usr/share/doc/zabbix-release" "/usr/share/doc/zabbix-frontend-php" "/usr/share/doc/apache-conf" "/usr/share/doc/zabbix-agent2")

# Daftar lokasi destinasi Zabbix
backup_locations1=("/opt/zabbix-backup/zabbix-config")

# Daftar lokasi destinasi Web
backup_locations2=("/opt/zabbix-backup/web-config/apache2")

# Daftar lokasi destinasi Shared
backup_locations3=("/opt/zabbix-backup/shared/zabbix")

# Daftar lokasi destinasi Doc
backup_locations4=("/opt/zabbix-backup/shared/doc")

# Informasi koneksi MySQL
db_user="root"
db_password="varni0nz4bb1x"
db_name="zabbix"
db_host="172.17.4.40"

# Informasi koneksi SSH
ssh_user="zabbix"
ssh_password="varnionzabbix"

# Lokasi destinasi untuk backup
backup_location=("/opt/zabbix-backup/database")

# Nama yang mirip yang akan dicocokkan
similar_name="zabbix"

# Buat nama file backup untuk database dengan timestamp
backup_file="$backup_location/zabbix_mysql_$(date +\%Y\%m\%d_\%H\%M\%S).sql"

# Kombinasikan variabel-variabel untuk perintah SSH
SSH_CMD="sshpass -p '$ssh_password' ssh -o StrictHostKeyChecking=no $ssh_user@$db_host"

# Lakukan backup MySQL database dari server remote menggunakan mysqldump melalui SSH
$SSH_CMD "mysqldump -u $db_user -p $db_password -h $db_host $db_name" > "$backup_file"

# ssh zabbix@${db_host} "mysqldump -u $db_user -p $db_password -h $db_host $db_name" > "$backup_file"

# Tampilkan pesan berdasarkan keberhasilan backup
if [ $? -eq 0 ]; then
    echo "Backup database $db_name dari host $db_host berhasil disimpan di: $backup_file"
else
    echo "Backup database $db_name dari host $db_host gagal"
fi


# Zabbix Config
for ((i=0; i<${#backup_directories1[@]}; i++)); do
    # Buat nama file backup dengan timestamp
    zabbix_config="${backup_locations1[$i]}/Zabbix_Config_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Lakukan backup menggunakan tar
    tar -czf "$zabbix_config" "${backup_directories1[$i]}"

    # Tampilkan pesan berdasarkan keberhasilan backup
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories1[$i]} berhasil disimpan di: $zabbix_config"
    else
        echo "Backup untuk ${backup_directories1[$i]} gagal"
    fi
done

# Zabbix Web
for ((i=0; i<${#backup_directories2[@]}; i++)); do
    # Buat nama file backup dengan timestamp
    zabbix_apache2="${backup_locations2[$i]}/Zabbix_Apache2_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Lakukan backup menggunakan tar
    tar -czf "$zabbix_apache2" "${backup_directories2[$i]}"

    # Tampilkan pesan berdasarkan keberhasilan backup
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories2[$i]} berhasil disimpan di: $zabbix_apache2"
    else
        echo "Backup untuk ${backup_directories2[$i]} gagal"
    fi
done

# Zabbix Shared
for ((i=0; i<${#backup_directories3[@]}; i++)); do
    # Buat nama file backup dengan timestamp
    zabbix_shared="${backup_locations3[$i]}/Zabbix_Shared_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Lakukan backup menggunakan tar
    tar -czf "$zabbix_shared" "${backup_directories3[$i]}"

    # Tampilkan pesan berdasarkan keberhasilan backup
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories3[$i]} berhasil disimpan di: $zabbix_shared"
    else
        echo "Backup untuk ${backup_directories3[$i]} gagal"
    fi
done

# Zabbix Docs
for ((i=0; i<${#backup_directories4[@]}; i++)); do
    # Buat nama file backup dengan timestamp
    zabbix_doc="${backup_locations4[$i]}/Zabbix_Docs_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

    # Lakukan backup menggunakan tar
    tar -czf "$zabbix_doc" "${backup_directories4[$i]}"

    # Tampilkan pesan berdasarkan keberhasilan backup
    if [ $? -eq 0 ]; then
        echo "Backup untuk ${backup_directories4[$i]} berhasil disimpan di: $zabbix_doc"
    else
        echo "Backup untuk ${backup_directories4[$i]} gagal"
    fi
done