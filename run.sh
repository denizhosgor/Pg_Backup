#!/bin/bash
# CORE

#KAYNAKLAR
#==========
 # Programin ilk defa calistirilmasi durumunda gerekli dosya yollarinin kaydedilmesi ve degiskenlerin tanimlanmasi
 source ./Lib/pathfinder.lib

 verbose=$1

#TANIMLAMALAR
#=============
 #DIZI TANIMLARI
 #---------------
  DirList=()
  DirListIcerik=()

 #FONKSIYONLAR
 #-------------
  function ConfigDeger(){
    sed 's/^ *//g' $ConfFile | grep -v '^#' | grep -v '^;' | cut -d '#' -f1 | grep -v -e '^[[:space:]]*$' | awk ' /'$@'/ {print $3;exit} '
  }

  function ConfigDizi(){
    awk '/'$@'/' $ConfFile | cut -d '(' -f2 | cut -d ')' -f1
  }

#DOSYA ve KLASOR OLUSTURMA/KONTROL
#==================================
 #Diziye kaydedilen Listenin karsisina denk gelen degerler "(Logs DataBase ServerImage) vs" diziye kaydediliyor.
  for DirList in $(ConfigDizi MiscDir)
   do
     DirListIcerik+=($DirList)
   done

  for (( i=0; i<${#DirListIcerik[@]}; i++ ))
   do
     read "${DirListIcerik[$i]}" <<< "${DirListIcerik[$i]}"		# Belirlenen Klasor isimlerinin degisken olarak adlandirilmasi degiskene atanmasi
     mkdir -p $BckRootDir/$SvrNameDir/$bugun/${DirListIcerik[$i]}	# Yedek alinacak klasorlerin olusturulmasi
     if [[ "${DirListIcerik[$i]}" == "$Logs" ]]; then 			# "Logs" klasorunun ismi farkli ise degiskeninde ismi tanimlanan degerle ayni olmak zorunda.
	touch $LogFilePath						# Log dosyasinin olusturulmasi
  	echo -e "KLASOR OLUSTUR ISLEMLERI" >> $LogFilePath
	echo -e "=========================" >> $LogFilePath
     fi
     echo -e " $BckRootDir/$SvrNameDir/$bugun/${DirListIcerik[$i]} klasoru olusturuldu." >> $LogFilePath
   done


#TEST SCRIPT
#====================
 $ScriptsDirPath/test.sh v BckRootDir SvrNameDir KlasorYeri LogFilePath

 #Hata Sorgu
 #----------
  hata=$?
  if [[ $hata -eq 1 ]]; then
     if [[ "$verbose" == "v" ]]; then printf "\n\t Mevcut hata yuzunden yedek alma islemi gerceklestirilemedi." && exit; else echo " Mevcut hata yuzunden yedek alma islemi gerceklestirilemedi." >> $LogFilePath && exit; fi
  else
     if [[ "$verbose" == "v" ]]; then printf "\n\t Butun kontrollerden gecti yedek alma islemi basliyor." else echo " Butun kontrollerden gecti yedek alma islemi basliyor." >> $LogFilePath; fi
  fi

#SISTEM BILGILERININ TOPLANMASI
#===============================
 if [ ! -f $SystemLogFilePath ]; then
    touch $SystemLogFilePath
    $ScriptsDirPath/system.sh SystemLogFilePath
 fi

#BACKUP ALMA
#================
 #DATABASE
 #---------
  if [ "$DataBase_Yedek" == "E" ]; then
     if [ -d $BckRootDir/$SvrNameDir/$bugun/$Database ]; then  chown -R postgres:postgres $BckRootDir/$SvrNameDir/$bugun/$Database; fi 
    export verbose
     $ScriptsDirPath/backup_pg.sh Bck_Secim BckRootDir SvrNameDir Database LogFilePath
  else
    echo -e "DATABASE" >> $LogFilePath
    echo -e "=========" >> $LogFilePath
    echo -e "  PostgreSQL DataBase yedek alma aktif degil." >> $LogFilePath
  fi

 #KLASOR BACKUP
 #--------------
  if [ "$Klasor_Yedek" == "E" ]; then
     export verbose
     $ScriptsDirPath/backup_dir.sh BckRootDir SvrNameDir DirImage LogFilePath ErrLogFilePath TarDirLogFilePath
  else
    echo -e "KLASOR YEDEKLENMESI" >> $LogFilePath
    echo -e "====================" >> $LogFilePath
    echo -e "  Klasor yedek alimi aktif degil." >> $LogFilePath
  fi

 #IMAGE BACKUP
 #-------------
  echo -e "" >> $LogFilePath
  echo -e "SUNUCU IMAJ YEDEGININ ALINMASI " >> $LogFilePath
  echo -e "===============================" >> $LogFilePath

  if [ "$Image_Yedek" == "E" ]; then
    # 4. Seviye "ServerImageDir"
   echo "if ici"

  else
    echo "Sunucu imaj alma islemi aktif degil." >> $LogFilePath
  fi

#DOSYA TRANSFER ISLEMLERI
#=========================
 echo -e "" >> $LogFilePath
 echo -e "TRANSFER ISLEMLERI " >> $LogFilePath
 echo -e "===================" >> $LogFilePath

# $ScriptsDirPath/test.sh

 if [[ "$GondermeTipi" != "Local" ]]; then
   $ScriptsDirPath/transfer.sh $ConfFile $GondermeTipi $BckRootDir $SvrNameDir $Database
 else
   echo -e " Local kayit yapildigi icin transfer gerceklestirilmedi." >> $LogFilePath
 fi


#SILME ISLEMLERI
#================
#  $ScriptsDirPath/sil.sh $ConfFile $BckRootDir $SvrNameDir $KlasorYeri $SaklamaTipi $LogFilePath

#MAIL GONDERME ISLEMLERI
#========================



#BAGLANTI TEST ISLEMLERI
#========================
#  $ScriptsDirPath/test.sh
