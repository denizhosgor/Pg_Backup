#!/bin/bash

#KUTUPHANE
#===========
 source Lib/parametre_finder.lib
 source Lib/function_finder.lib

#TANIMLAMALARIN ALINMASI
#========================
 #DEGISKENLER
 #------------
   bugunsayi=`date +"%u"`        # Haftanin gunlerinin sayisal degeri "1 2 3 4 5 6 7" haftanin 7 gunu
   bugunsayisal=`date +"%d"`
   _end=$(( $(sudo -i -u postgres psql -c 'SELECT oid, datname FROM pg_database' | grep '(' | cut -d ' ' -f1 | cut -d '(' -f2) - 1)) # 'function_finder.lib' ile baglantili
 #BOS DIZILER
 #------------
   PostData_dizi=()
   PgDbListe=()

#POSTGRESQL BILGILERININ SISTEMDEN OGRENILMESI
#==============================================
 #POSTGRESQL ve POSTGIS VERSIYON OGRENME
 #---------------------------------------
   satir_no=$(grep -n -o -m 1 '#!:' $ConfFile | cut -d ':' -f1)
   satir_son=$(grep -n -o -m 1 '##!:' $ConfFile | cut -d ':' -f1)
   bas=$(($satir_no+1))
   son=$(($satir_son-1))

   if [[ $(($son-$bas)) -ne -1 ]]; then sed -i "$bas,$son d" $ConfFile; fi

   for PgDbListe in $(locate /etc/*postgresql.conf)
    do
      PgDbListeIcerik+=($PgDbListe)
    done

   for (( i=0; i<${#PgDbListeIcerik[@]}; i++ ))
    do
      DB_Klasor_Yolu=$(awk ' /'data_directory'/ {print $3;exit} ' ${PgDbListeIcerik[$i]} | tr "'" " " | sed -r 's/ //g')
      DB_Hba_Yolu=$(awk ' /'hba_file'/ {print $3;exit} ' ${PgDbListeIcerik[$i]} | tr "'" " " | sed -r 's/ //g')
      DB_Ident_Yolu=$(awk ' /'ident_file'/ {print $3;exit} ' ${PgDbListeIcerik[$i]} | tr "'" " " | sed -r 's/ //g')
      DB_ListenAdr=$(awk ' /'listen_addresses'/ {print $3;exit} ' ${PgDbListeIcerik[$i]})
      DB_Port=$(awk ' /'port'/ {print $3;exit} ' ${PgDbListeIcerik[$i]})
      DB_Ver=$(cat $DB_Klasor_Yolu/PG_VERSION)
      DB_Status=$(service postgresql@$DB_Ver-main status | grep 'Active:' | awk '{print $2}')

      sed -i 's,^##!:,'"   PG_VERSION_$i = $DB_Ver"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    Pg_Status_$i = $DB_Status"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgDbKlasoru_$i = $DB_Klasor_Yolu"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgConfDosyasi_$i = ${PgDbListeIcerik[$i]}"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgHbaDosyasi_$i = $DB_Hba_Yolu"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgIdentDosyasi_$i = $DB_Ident_Yolu"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgDbAdres_$i = $DB_ListenAdr"'\n&,' $ConfFile
      sed -i 's,^##!:,'"    PgDbPort_$i = $DB_Port"'\n&,' $ConfFile

      if [[ $i -ne $((${#PgDbListeIcerik[@]} - 1)) ]]; then sed -i 's,^##!:,\n&,' $ConfFile; fi
   done

 #POSTGRESQL BACKUP ALMA SECENEKLERININ BELIRLENMESI
 #---------------------------------------------------
   function PostgresqlYedekAl(){
     #BOS DIZI
     #*********
      BackupSecenekListIcerik=()
      SecenekListIcerik=()

      #Conf dosyasindaki "Backup Alma Secenekleri" okunuyor. Diziye kaydediliyor.
      for BackupSecenekList in $(cat $ConfFile | grep ';' | cut -d ';' -f2 | cut -d ' ' -f1)
       do
         BackupSecenekListIcerik+=($BackupSecenekList)
      done

      #Diziye kaydedilen Listenin karsisina denk gelen degerler "(1 2 3) vs" diziye kaydediliyor.
      for SecenekList in ${BackupSecenekListIcerik[$Bck_Secim]}
       do
         SecenekListIcerik+=($(ConfigDizi $SecenekList))
      done

      #Degerler "(Haftanin gunleri)" burada ayristirilarak backupin alinip alinmayacagi belirleniyor.
      for (( i=0; i<${#SecenekListIcerik[@]}; i++ ))
       do
        if [ $(expr length ${SecenekListIcerik[$i]}) -eq 2 ]; then #Gelen degerin karakter sayisi bulunuyor ve kosullar ile karsilastiriliyor.
            if [ "$bugunsayisal" == "${AyinGunu_dizi[$i]}" ]; then
                Bck_Sonuc="YEDEK-AL"
	    fi
	else
            if [ "$bugunsayi" == "${SecenekListIcerik[$i]}" ]; then
            	Bck_Sonuc="YEDEK-AL"
            fi
        fi
      done
   }

 #POSTGRESQL TABLOLARININ ISIMLERININ OGRENILMESI
 #------------------------------------------------
  # Postgresql Database listesini almak icin kullanilan for dongusu
  # -i ile postgres dizininde oturum aciliyor "su -l postgres" gibi.
  # awk ile basilan ilk kolonu aliyor.
  # sed ile alinan bilgiler arasinda gerekli olmayan bilgiler temizleniyor.
   for PostDataList in $(sudo -i -u postgres psql --list | awk '{print $1}' | sed '/|/d' | sed -e 's/-//g' | sed '/+/d' | sed '/List/d' | sed '/Name/d' | sed '/:/d' | sed '/template0/d' | sed '/(/d')
    do
      PostData_dizi+=($PostDataList)        # Postgresql Database listesinin tutuldugu dizi
    done

 #VERSIYONA GORE DATABASE TABLOLARININ BACKUP ALMA KODLARI
 #---------------------------------------------------------
   function Postgis1415(){
    #POSTGIS 1.4 ve 1.5 ICIN YEDEK ALMA KODU
    #****************************************
     # -i  : kullanicinin ev dizininde oturum acmak icin
     # -Fc : Format  c:custom d:directory t:tar p:palin text
     # en sona da database ismini yaziyoruz.
       for (( i=0; i<${#PostData_dizi[@]}; i++ ))
        do
          echo `date +"%r"` ": ${PostData_dizi[$i]} DATABASE Backup i aliniyor." >> $LogFilePath
          sudo -i -u postgres pg_dump -Fc "${PostData_dizi[$i]} > $BckRootDir/$SvrNameDir/$bugun/$Database/$DB_Ver/$bugun-${PostData_dizi[$i]}.backup"

	  if [[ "$verbose" == "v" ]]; then
	    sleep 0.1
	    printf ${CYAN}"  PostgreSQL Database\n"
	    ProgressBar $((${i} +1)) ${_end} pg
	  fi
        done
   }

   function Postgis2021(){
    #POSTGIS 2.0 ve 2.1 ICIN YEDEK ALMA KODU
    #****************************************
     # -i  : kullanicinin ev dizininde oturum acmak icin
     # -Fc : Format  c:custom d:directory t:tar p:palin text
     # -b  : buyuk objelerin tutulmasi gibi bir sey
     # -v  : verbose olan biteni gosteriyor
     # -f  : alinacak olan backup in yolunu ve adini belirliyorsun.
     # en sona da database ismini yaziyoruz.
       for (( i=0; i<${#PostData_dizi[@]}; i++ ))
        do
          echo `date +"%r"` ": ${PostData_dizi[$i]} DATABASE Backup i aliniyor." >> $LogFilePath
          sudo -i -u postgres pg_dump -Fc -b -f "$BckRootDir/$SvrNameDir/$bugun/$Database/$DB_Ver/$bugun-${PostData_dizi[$i]}.backup" ${PostData_dizi[$i]}

          if [[ "$verbose" == "v" ]]; then
	    sleep 0.1
	    printf ${CYAN}"  PostgreSQL Database\n"
	    ProgressBar $((${i} +1)) ${_end} pg
	  fi
        done
   }

   function PostgisVersiyonSec(){
    i=0
    # Birden fazla db oldugunda ve statusleri active ise yedegini alacak
    while [[ "$(ConfigDeger Pg_Status_$i)" == "active" ]]; do
      PostgisVersiyon=$(dpkg-query -l | grep "postgresql-$DB_Ver-postgis-[[:digit:]]" | awk '{print $2;exit}' | cut -d '-' -f4)
      mkdir -p $BckRootDir/$SvrNameDir/$bugun/$Database/$DB_Ver
      chown -R postgres:postgres $BckRootDir/$SvrNameDir/$bugun/$Database/$DB_Ver

      case $PostgisVersiyon in
        1.4 )
           Postgis1415 #Fonksiyonu Cagiriyoruz
           ;;
        1.5 )
           Postgis1415 #Fonksiyonu Cagiriyoruz
           ;;
        2.0 )
           Postgis2021 #Fonksiyonu Cagiriyoruz
           ;;
        2.1 )
           Postgis2021 #Fonksiyonu Cagiriyoruz
           ;;
        2.2 )
           Postgis2021 #Fonksiyonu Cagiriyoruz
           ;;
       esac
    i=$(($i+1))
    done
   }

#POSTGRESQL DATABASE ININ YEDEGININ ALINMASI
#===========================================
  PostgresqlYedekAl #Fonksiyonu Cagiriyoruz.
  if [ "$Bck_Sonuc" == "YEDEK-AL" ] ; then      # Fonksiyondan gelen degerin buradaki "YEDEK-AL" degeri ile karsilastirilmasi
    echo -e "" >> $LogFilePath
    echo -e "POSTGRESQL DATABASE NIN YEDEGININ ALINMASI " >> $LogFilePath
    echo -e "===========================================" >> $LogFilePath
        PostgisVersiyonSec   #Fonksiyonu Cagiriyoruz.
    echo -e "" >> $LogFilePath
    echo `date +"%r"` ": Backup alma islemi tamamlandi." >> $LogFilePath
    echo -e "" >> $LogFilePath
  fi
