#!/bin/bash
#SISTEM BILGILERININ OGRENILMESI ICIN KULLANILIYOR

#KUTUPHANE
#===========
 source Lib/parametre_finder.lib

#BILGILERI SISTEMDEN TOPARLANMASI
#=================================
 #SUNUCU BILGILERININ OGRENILMESI
 #-------------------------------
   Sunucu_Adi=$(hostname)
   Sunucu_Domain=$(hostname -d)
   Sunucu_Fqdn=$(hostname -f)
   Sunucu_Ip=$(hostname -i)

 #ISLETIM SISTEMI BILGILERI
 #-------------------------
   #SAGLAYICI FIRMA
   #****************
     dagitim_firma=$(lsb_release -i | awk '{print $3}')

   #DAGITIM TANIM
   #*************
     dagitim_tanim=$(lsb_release -d | awk {'printf ("%1s %1s %1s\n", $2, $3, $4)'})

   #DAGITIM NUMARASI
   #****************
     dagitim_no=$(lsb_release -r | awk '{print $2}')

   #DAGITIM CODENAME
   #****************
     dagitim_codename=$(lsb_release -c | awk '{print $2}')

   #CEKIRDEK
   #*********
     cekirdek_versiyon=$(ls -halS /boot/vm* | awk '{printf ("\t%1s %1s %2s %1s %1s\n\t\t"), $9, $8, $7, $6, $5}')

   #KOMUT IMAJ DOSYASI
   #******************
     komut_imaj=$( ls -halS /boot/init* | awk '{printf ("\t%1s %1s %2s %1s %1s\n\t\t"), $9, $8, $7, $6, $5}')

   #DISK UUID
   #*********
     disk_uuid=$(blkid | awk '{printf ("  %1s %1s %1s\n"), $1, $2, $3}')

   #32 BIT or 64 BIT
   #*****************
     dagitim_bit=$(uname -m)
      function BitDegeri(){
        case $dagitim_bit in
         i386 )
                 echo -e "  Dagitim Bit      : 32 Bit\n" >> $SystemLogFilePath
                 ;;
         i686 )
                 echo -e "  Dagitim Bit      : 32 Bit\n" >> $SystemLogFilePath
                 ;;
         x86_64 )
                 echo -e "  Dagitim Bit      : 64 Bit\n" >> $SystemLogFilePath
                 ;;
        esac
      }

   #FSTAB DOSYASI ICERIGI
   #*********************
    # "/etc/fstab" icindeki bilgileri okuyor.
    # Ilk kisimda ki "!" isareti degildir, "^" isareti satir basindaki karakteri belirtmektedir. Ekrana ilk karakteri "#" isaretinin olmayan satirlari yazdiriyor.
    # Ikinci kisimda "awk" nin iki adet suslu parantezi vardir.
    #  Birinci suslu parentez "BEGIN"ne aittir.
    #   "BEGIN" icinde iki adet "printf" parantezi var ve bunlar ";" ile ayrilmistir.
    #       Ayrica "%-41s" ile ifade edilen yazilan yazinin ne tarafa dayali olacagini ve kendinden sonra gelecek olan karakter arasindaki boslugu ifade ediyor.
    #       "-" isareti sola dayali oldugunu belli eder. Eger bu isaret olmasaydi saga dayali olacakti.
    #       "s" string ifadeler icin. "\t" tab boslugu anlamina gelmektedir.
    #       "\n" bir alt satira geciriyor.
    #   Birincisi kendimizin ekledigi bilgiyi iceriyor. Ikinci kisimda kendimizin ekledigi bolum fakat ayirac gibi kullanilmistir.
    # Ikinci suslu parantez de "|" ile ayrilan ilk kisimdan gelen veriyi sirali yazdirmak icin kullaniliyor.
     fstab_info=$(awk '! /^#/' /etc/fstab | awk 'BEGIN { printf ("%-41s\t %-20s\t %-1s\t %-30s\t %-1s\t %-1s\n"),"File System", "Mount Point", "Type", "Options", "Dump", "Pass"; printf ("  %-41s\t %-20s\t %-1s\t %-30s\t %-1s\t %-1s\n"),"-----------", "-----------", "----", "-------", "----", "----";} {printf ("  %-41s\t %-20s\t %-1s\t %-30s\t %-1s\t %-1s\n"), $1, $2, $3, $4, $5, $6}')

 #DISK KULLANIM BILGISI
 #---------------------
  disk_diskBosAlan=$(df -h | awk '! /File/'| awk 'BEGIN { printf ("%-15s\t %6s\t %6s\t %6s\t %6s\t %-1s\n"),"File System", "Size", "Used", "Avail", "Use%", "Mounted on";} { printf("    %-15s\t %6s\t %6s\t %6s\t %6s\t %-1s\n"), $1, $2, $3, $4, $5, $6}')

 #DATABASE BILGILERININ OGRENILMESI
 #---------------------------------
    DB_Ayarlar_Yolu=$(find / -name "postgresql.conf")
    DB_Klasor_Yolu=$(awk ' /'data_directory'/ {print $3;exit} ' $DB_Ayarlar_Yolu)
    DB_Hba_Yolu=$(awk ' /'hba_file'/ {print $3;exit} ' $DB_Ayarlar_Yolu)
    DB_Ident_Yolu=$(awk ' /'ident_file'/ {print $3;exit} ' $DB_Ayarlar_Yolu)

  #dpkg-query -l | grep "postgresql-[[:digit:]]" | grep -v "[[:digit:]]-[[:alpha:]]" -m 1 | awk '{print $2;exit}' | cut -d '-' -f2
  #  DB_Ver=$(dpkg-query -l | grep "postgresql-" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,3); }')
    DB_Ver=$(psql -V | egrep -o '[0-9]{1,}\.[0-9]{1,}')
  #  DB_Ver_Uzn=$(dpkg-query -l | grep "postgresql-" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1)
    DB_Ver_Uzn=$(psql -V | awk '{print $NF}')
    PostgisVersiyon=$(dpkg-query -l | grep "postgresql-$DB_Ver-postgis" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,3); }')
    PostgisVersiyon_Uzn=$(dpkg-query -l | grep "postgresql-$DB_Ver-postgis" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,5); }')
    PgRouteVersiyon_Uzn=$(dpkg-query -l | grep "postgresql-$DB_Ver-pgrouting" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,5); }')

    DB_ListenAdr=$(awk ' /'listen_addresses'/ {print $3;exit} ' $DB_Ayarlar_Yolu)
    DB_Port=$(awk ' /'port'/ {print $3;exit} ' $DB_Ayarlar_Yolu)

    DatabaseListesi=$(sudo -i -u postgres psql -c 'SELECT oid, datname FROM pg_database')
     if [ "$PostgisVersiyon_Uzn" == "" ]; then
      PostgisVersiyon_Uzn="Postgis versiyonu yuklu degil."
     fi

     if [ "$PgRouteVersiyon_Uzn" == "" ]; then
      PgRouteVersiyon_Uzn="PgRoute versiyonu yuklu degil."
     fi
#=================================

#BILGILERIN DOSYAYA YAZILMASI
#=============================
 #KLASOR ve DOSYANIN OLUSTURULMASI
 #---------------------------------
   touch $SystemLogFilePath

 #SUNUCU BILGILERI
 #----------------
   echo "" >> $SystemLogFilePath
   echo -e "SUNUCU BILGILERI" >> $SystemLogFilePath
   echo -e "=================================" >> $SystemLogFilePath
   echo -e " Sunucu Adi : $Sunucu_Adi" >> $SystemLogFilePath
   echo -e " Domain Adi : $Sunucu_Domain" >> $SystemLogFilePath
   echo -e " FQDN       : $Sunucu_Fqdn" >>$SystemLogFilePath
   echo -e " Ip Adresi  : $Sunucu_Ip" >> $SystemLogFilePath
   echo -e "=================================" >> $SystemLogFilePath
   echo -e "" >> $SystemLogFilePath

 #ISLETIM SISTEMI BILGILERI
   echo -e "ISLETIM SISTEMI BILGILERI" >> $SystemLogFilePath
   echo -e "==========================" >> $SystemLogFilePath
   echo -e " ISLETIM SISTEMI" >> $SystemLogFilePath
   echo -e " ----------------" >> $SystemLogFilePath
   echo -e "  Saylayici Firma  : $dagitim_firma" >> $SystemLogFilePath
   echo -e "  Dagitim Tanim    : $dagitim_tanim" >> $SystemLogFilePath
   echo -e "  Dagitim Versiyon : $dagitim_no" >> $SystemLogFilePath
   echo -e "  Dagitim Kodismi  : $dagitim_codename" >> $SystemLogFilePath
   BitDegeri # Fonksiyon Cagiriliyor
   echo -e " CEKIRDEK BILGILERI" >> $SystemLogFilePath
   echo -e " -------------------" >> $SystemLogFilePath
   echo -e "  Kernel Versiyon : $cekirdek_versiyon" >> $SystemLogFilePath
   echo -e "  Komut Dosyasi   : $komut_imaj" >> $SystemLogFilePath
   echo -e " DISK UUID " >> $SystemLogFilePath
   echo -e " ----------" >> $SystemLogFilePath
   echo -e "$disk_uuid\n" >> $SystemLogFilePath
   echo -e " FSTAB DOSYASI" >> $SystemLogFilePath
   echo -e " --------------" >> $SystemLogFilePath
   echo -e "  $fstab_info\n" >> $SystemLogFilePath
   echo -e "" >> $SystemLogFilePath

 #DATABASE BILGILERI
 #------------------
   echo -e "DATABASE BILGILERI" >> $SystemLogFilePath
   echo -e "=================================" >> $SystemLogFilePath
   echo -e "  Database Ayar Dosyasi Yolu : $DB_Ayarlar_Yolu" >> $SystemLogFilePath
   echo -e "  Database Klasor Yolu       : $DB_Klasor_Yolu" >> $SystemLogFilePath
   echo -e "  Database Pg_hba Yolu       : $DB_Hba_Yolu" >> $SystemLogFilePath
   echo -e "  Database Pg_Ident Yolu     : $DB_Ident_Yolu" >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e "  PostgreSQL Versiyon : $DB_Ver_Uzn" >> $SystemLogFilePath
   echo -e "  Postgis Versiyon    : $PostgisVersiyon_Uzn" >> $SystemLogFilePath
   echo -e "  Pgroute Versiyon    : $PgRouteVersiyon_Uzn" >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e "  Database Adres      : $DB_ListenAdr" >> $SystemLogFilePath
   echo -e "  Database Port       : $DB_Port" >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e "  Database Adlari ve Klasor Numaralari" >> $SystemLogFilePath
   echo -e "  -------------------------------------" >> $SystemLogFilePath
   echo -e "  Not: Database klasorunun icinde bulunan base klasoru altindaki numarali" >> $SystemLogFilePath
   echo -e "       klasorlerin hangi database e ait oldugunu gosteren tablo" >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e "$DatabaseListesi" >> $SystemLogFilePath
   echo -e " " >> $SystemLogFilePath
   echo -e "=================================" >> $SystemLogFilePath
#=============================

#DISK BILGILERININ ALINMASI
#==========================
  echo "" >> $SystemLogFilePath
  echo -e "   DISK KULLANIM ALANI" >> $SystemLogFilePath
  echo -e "   ---------------------" >> $SystemLogFilePath
  echo -e "    $disk_diskBosAlan" >> $SystemLogFilePath
  echo -e "" >> $SystemLogFilePath

 # "du" disk usage komutu
 # "-h" : Mb yada Kb cinsinden yazilmasini sagliyor.
 # "-s" : sadece toplam boyutu gosteriyor.
  echo -e "BACKUP ALINACAK KLASORLERIN BOYUTU" >> $SystemLogFilePath
  echo -e "==================================" >> $SystemLogFilePath
    du -hs /opt/ >> $SystemLogFilePath
    du -hs /etc/ >> $SystemLogFilePath
    du -hs /var/ >> $SystemLogFilePath
    du -hs /home/ >> $SystemLogFilePath
  echo -e "==================================" >> $SystemLogFilePath
