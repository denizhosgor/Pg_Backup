#!/bin/bash

#TANIMLAMALARIN ALINMASI
#========================
 #AYAR DOSYASI TANIMLARI
 #-----------------------
  ConfFile=$ConfDir'/backup.config'

   function ConfigDeger(){
     awk ' /'$@'/ {print $3;exit} ' $ConfFile
   }

 #AYAR DOSYASI TANIM DEGISKENLERI
 #--------------------------------
   #PROGRAMIN YOLLARI ve KLASOR ISIMLERI
   #*************************************
     ScriptsDir=$(ConfigDeger ScriptsDir)

#CRON JOB OLUSTURMA
#===================
 ./$ScriptsDir/crontab.sh $ConfFile



groupadd ftpaccess
useradd -m PgSqlBackup -g ftpaccess -s /usr/sbin/nologin -u 1005



##YUKLENECEKLER
# lsscsi
