#!/bin/bash
saniye=`date +"%s"`

bugun=`date +"%Y%m%d"`
dun=`date -d @$(($saniye-86400)) +"%Y%m%d"`           # Dunnun tarihini yazdirma
birhftonce=`date -d @$(($saniye-604800)) +"%Y%m%d"`   # Bir hafta onceki tarihin bulunmasi
birayonce=`date -d @$(($saniye-2419200)) +"%Y%m%d"`   # Bir ay onceki tarih (30 gun uzerinden)
dongu_sayi=0

#TANIMLAMALARIN ALINMASI
#========================
 #GONDERILEN DEGISKENLER
  ConfFile=$1
  YedekRootDir=$2 #"/mnt/BackupDisk" #$2
  YedekKlaAdi=$3 #"DevelopmentBackup" #$3
  KlasorYeri=$4 #"HariciDisk" #$4
  SaklamaTipi=$5
  LogFilePath=$6

#FONKSIYONLAR
#=============
 function KayitYeriTercihi(){
   if [ "$KlasorYeri" == "YerelKlasor" ]; then
      diskBosAlanBoyut=$(df | grep -w / | awk '{print$4;exit}')
   elif [ "$KlasorYeri" == "HariciDisk" ]; then
      diskBosAlanBoyut=$(df | grep -w $YedekRootDir | awk '{print $4;exit}')
   fi
 }

 echo "" >> $LogFilePath
 echo "KAYIT SILME ISLEMLERI" >> $LogFilePath
 echo "======================" >> $LogFilePath

 function EnSonKayitSil(){
   backupBoyutu=$(du -s $YedekRootDir/$YedekKlaAdi/$dun | awk '{print $1;exit}')

  #Disk bos alan boyutu, backup dosyasi boyutundan buyuk olana kadar dongu calisiyor.
   until [ $diskBosAlanBoyut > $backupBoyutu ]; do
     ensonkayit=$(ls -1 $YedekRootDir/$YedekKlaAdi | awk '{print $1; exit}')
     rm -fr $YedekRootDir/$YedekKlaAdi/$ensonkayit

     dongu_sayi=$dongu_sayi+1
     echo -n "  $dongu_Sayi) $ensonkayit tarihli kayit yer olmadigi icin silindi." >> $LogFilePath

     KayitYeriTercihi  #Fonksiyon
   done
 }

 #Silme isleminin yapilmasi
  case $SaklamaTipi in
   H )
     #Hafta da bir
      if [ -d $YedekRootDir/$YedekKlaAdi/$birhftonce ]; then
         rm -fr $YedekRootDir/$YedekKlaAdi/$birhftonce
	 echo -n " Bir hafta onceki $birhftonce tarihli kayit silindi." >> $LogFilePath
      fi
     ;;
   A )
     #Ayda Bir
      if [ -d $YedekRootDir/$YedekKlaAdi/$birayonce ]; then
         rm -fr $YedekRootDir/$YedekKlaAdi/$birayonce
         echo -n " Bir ay onceki $birayonce tarihli kayit silindi." >> $LogFilePath

      fi
     ;;
   DB )
     #Disk Durumuna Gore
      KayitYeriTercihi	#Fonksiyon
      EnSonKayitSil	#Fonksiyon
     ;;
  esac
