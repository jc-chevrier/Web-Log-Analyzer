#!/bin/bash

# Script d'analyse du fichier des logs d'accès d'Apache.

logFilePath="/var/log/apache2/access.log"
logs=()
index=0
while read line; do
 IPAddressClient=$(echo $line | grep -o -E "^([0-9]{1,3}\.){3}[0-9]{1,3}")
 timestamp=$(echo $line | grep -o -E "\[[^ ]+" | sed "s/\[//g")

 logs[$index, 0]=$IPAddressClient
 logs[index, 1]=$timestamp

 echo "Adresse IP Client = [${logs[$index, 0]}], timestamp = [${logs[$index, 1]}]"

 index=$((index + 1))
done < $logFilePath
