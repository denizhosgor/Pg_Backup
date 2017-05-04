#!/bin/bash

#DEGISKENLER
#------------
 bugun=`date +"%Y%m%d"`

#TANIMLAMALARIN ALINMASI
#========================
 #AYAR DOSYASI TANIMLARI
 #-----------------------
  ConfFile=$1
  GondermeTipi=$2
  YedekRootDir=$3
  YedekKlaAdi=$4
  YedekDBKlaAdi=$5

   function ConfigDeger(){
     awk ' /'$@'/ {print $3;exit} ' $ConfFile
   }


#BACKUP KLASORUNUN GONDERILMESI
#===============================
 function GondermeSekli (){
   case $GondermeTipi in
     Scp )
          Kullanici=$(ConfigDeger Kullanici)
          BaglantIP=$(ConfigDeger BaglantIP)
          ScpPort=$(ConfigDeger ScpPort)

          echo `date +"%r"` "  Scp ile karsi tarafa baglaniliyor." >> $LogFilePath
          ssh -p $ScpPort $Kullanici@$BaglantIP '
           #Karsi tarafda klasor olusturma
           if [ ! -d $YedekKlaAdi ]; then
              mkdir $YedekKlaAdi
	   fi'

          echo `date +"%r"` "  Backup Scp ile gonderiliyor." >> $LogFilePath
          scp -r -P $ScpPort $YedekRootDir/$YedekKlaAdi/$bugun/ $Kullanici@$BaglantIP:$YedekKlaAdi/
          echo `date +"%r"` "  Gonderme islemi tamamlandi." >> $LogFilePath

          ssh -p $ScpPort $Kullanici@$BaglantIP '
           #Karsi tarafda yetkilendirme islemi
           if [ $(cat /etc/passwd | grep postgres | cut -d ':' -f1) == "postgres" ]; then
              chown -R postgres:postgres $YedekKlaAdi/$bugun/$YedekDBKlaAdi
           fi'
          ;;

     Ftp )
          ServerIP=$(ConfigDeger ServerIP)
          FtpPort=$(ConfigDeger FtpPort)
          UserID=$(ConfigDeger UserID)
          Password=$(ConfigDeger Password)

          (
            echo "user $UserID $Password"
            echo "binary"
            echo "prompt"

            echo "mkdir $YedekKlaAdi"

            echo "cd $YedekKlaAdi"
            echo "mput $YedekRootDir/$YedekKlaAdi/$bugun/*.*"
            echo "bye"
           ) | ftp -n $ServerIP $ftp_Port
          ;;
   esac
 }

 GondermeSekli # Fonksiyon cagriliyor.
