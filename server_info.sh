#!/bin/bash

 GLC="Backup_Log.txt"
#SUNUCU BILGILERININ OGRENILMESI
#================================
  Sunucu_Adi=$(hostname)
  Sunucu_Domain=$(hostname -d)
  Sunucu_Fqdn=$(hostname -f)
  Sunucu_Ip=$(hostname -i)
#================================

#DATABASE BILGILERININ OGRENILMESI
#=================================
 # Ornek : DB_Yol_Krk_Sayi=$(find / -name "pg_xlog" | wc -L | awk '{print $1 -7}')
 # Ornek : DB_Klasor_Yolu=$(find / -name "pg_xlog" | awk -v DB_Yol_Krk_Sayi=$DB_Yol_Krk_Sayi '{print substr($1,1,DB_Yol_Krk_Sayi);}')
  DB_Ayarlar_Yolu=$(find / -name "postgresql.conf")
  DB_Klasor_Yolu=$(awk ' /'data_directory'/ {print $3;exit} ' $DB_Ayarlar_Yolu)
  DB_Hba_Yolu=$(awk ' /'hba_file'/ {print $3;exit} ' $DB_Ayarlar_Yolu)
  DB_Ident_Yolu=$(awk ' /'ident_file'/ {print $3;exit} ' $DB_Ayarlar_Yolu)

  DB_Ver=$(dpkg-query -l | grep "postgresql-" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,3); }')
  DB_Ver_Uzn=$(dpkg-query -l | grep "postgresql-" -m 1 | awk '{print $3;exit}' | cut -d '-' -f1 | awk '{print substr($1,1,5); }')
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

#POSTGRESQL TABLOLARININ ISIMLERININ OGRENILMESI
#================================================
   # Postgresql Database listesini almak icin kullanilan for dongusu
   # -i ile postgres dizininde oturum aciliyor "su -l postgres" gibi.
   # awk ile basilan ilk kolonu aliyor.
   # sed ile alinan bilgiler arasinda gerekli olmayan bilgiler temizleniyor.
      for PostDataList in $(sudo -i -u postgres psql --list | awk '{print $1}' | sed '/|/d' | sed -e 's/-//g' | sed '/+/d' | sed '/List/d' | sed '/Name/d' | sed '/:/d' | sed '/template0/d' | sed '/(/d')
       do
          PostData_dizi+=($PostDataList)        # Postgresql Database listesinin tutuldugu dizi
       done
#================================================

#SUNUCU BILGILERI
#================
  echo "" >> $GLC
  echo -e "SUNUCU BILGILERI" >> $GLC
  echo -e "=================================" >> $GLC
  echo -e " Sunucu Adi : $Sunucu_Adi" >> $GLC
  echo -e " Domain Adi : $Sunucu_Domain" >> $GLC
  echo -e " FQDN       : $Sunucu_Fqdn" >>$GLC
  echo -e " Ip Adresi  : $Sunucu_Ip" >> $GLC
  echo -e "=================================" >> $GLC

#DATABASE BILGILERI
#==================
  echo "" >> $GLC
  echo -e "DATABASE BILGILERI" >> $GLC
  echo -e "=================================" >> $GLC
  echo -e "  Database Ayar Dosyasi Yolu : $DB_Ayarlar_Yolu" >> $GLC
  echo -e "  Database Klasor Yolu       : $DB_Klasor_Yolu" >> $GLC
  echo -e "  Database Pg_hba Yolu       : $DB_Hba_Yolu" >> $GLC
  echo -e "  Database Pg_Ident Yolu     : $DB_Ident_Yolu" >> $GLC
  echo -e " " >> $GLC
  echo -e "  PostgreSQL Versiyon : $DB_Ver_Uzn" >> $GLC
  echo -e "  Postgis Versiyon    : $PostgisVersiyon_Uzn" >> $GLC
  echo -e "  Pgroute Versiyon    : $PgRouteVersiyon_Uzn" >> $GLC
  echo -e " " >> $GLC
  echo -e "  Database Adres      : $DB_ListenAdr" >> $GLC
  echo -e "  Database Port       : $DB_Port" >> $GLC
  echo -e " " >> $GLC
  echo -e " " >> $GLC
  echo -e "  Database Adlari ve Klasor Numaralari" >> $GLC
  echo -e "  -------------------------------------" >> $GLC
  echo -e "  Not: Database klasorunun icinde bulunan base klasoru altindaki numarali" >> $GLC
  echo -e "       klasorlerin hangi database e ait oldugunu gosteren tablo" >> $GLC
  echo -e " " >> $GLC
  echo -e "$DatabaseListesi" >> $GLC
  echo -e " " >> $GLC
  echo -e "=================================" >> $GLC

#DISK BILGILERININ ALINMASI
#==========================
  echo "" >> $GLC
  echo -e "DISK BILGILERI" >> $GLC
  echo -e "=================================================" >> $GLC
 # "df" disk boyutu ile ilgili bilgileri veriyor.
    df -h >> $GLC
  echo -e "=================================================" >> $GLC
  echo -e "" >> $GLC

 # "du" disk usage komutu
 # "-h" : Mb yada Kb cinsinden yazilmasini sagliyor.
 # "-s" : sadece toplam boyutu gosteriyor.
  echo -e "BACKUP ALINACAK KLASORLERIN BOYUTU" >> $GLC
  echo -e "==================================" >> $GLC
    du -hs /opt/ >> $GLC
    du -hs /etc/ >> $GLC
    du -hs /var/ >> $GLC
    du -hs /home/ >> $GLC
  echo -e "==================================" >> $GLC

