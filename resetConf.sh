#!/bin/bash
source ./Lib/pathfinder.lib

echo -e "\n"
echo "      |--------- DIKKAT ----------|"
echo "      |                           |"
echo "      | Ayarlari sifirlama islemi |"
echo "      |                           |"
echo "      |---------------------------|"
echo -e "\n"
echo "   Ayarlari gercekten sifirlamak istiyor musunuz ? (E/H)"
  read cevap

 if [[ "$cevap" == "E" ]] || [[ "$cevap" == "e" ]]; then
  #DIGERLERI
   sed -i 's/Script_FirstRun = H/Script_FirstRun = IlkCalistirma/' $ConfFile
#   sed -i 's/FirstRun="H"/FirstRun="E"/' Lib/pathfinder.lib
  #KUTUPHANE Dosya Ici Yollari
   sed -i 's,'"ConfFile='$ConfFile'"',ConfFile="Conf/backup.config",' Lib/pathfinder.lib
   sed -i 's,'"ConfFile='$ConfFile'"',ConfFile="ConfPages/backup.config",' Lib/parametre_finder.lib
  #SOURCE Dosya Ici Yollari
   sed -i 's,'"source $(ConfigDeger LibDirPath)/parametre_finder.lib"',source Lib/parametre_finder.lib,' $ScriptsDirPath/backup_dir.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/parametre_finder.lib"',source Lib/parametre_finder.lib,' $ScriptsDirPath/backup_pg.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/parametre_finder.lib"',source Lib/parametre_finder.lib,' $ScriptsDirPath/crontab.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/parametre_finder.lib"',source Lib/parametre_finder.lib,' $ScriptsDirPath/system.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/parametre_finder.lib"',source Lib/parametre_finder.lib,' $ScriptsDirPath/test.sh
  #RENK
   sed -i 's,'"source $(ConfigDeger LibDirPath)/colors.lib"',source Lib/colors.lib,' Lib/function_finder.lib
   sed -i 's,'"source $(ConfigDeger LibDirPath)/colors.lib"',source Lib/colors.lib,' $ScriptsDirPath/test.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/colors.lib"',source Lib/colors.lib,' $ScriptsDirPath/crontab.sh
  #FUNCTION
   sed -i 's,'"source $(ConfigDeger LibDirPath)/function_finder.lib"',source Lib/function_finder.lib,' $ScriptsDirPath/backup_dir.sh
   sed -i 's,'"source $(ConfigDeger LibDirPath)/function_finder.lib"',source Lib/function_finder.lib,' $ScriptsDirPath/backup_pg.sh
  #DOSYA Yollari
   sed -i 's,'"LogFilePath = $(ConfigDeger LogFilePath)"','"LogFilePath = LogDosyasiYolu"',' $ConfFile
   sed -i 's,'"ErrLogFilePath = $(ConfigDeger ErrLogFilePath)"','"ErrLogFilePath = ErrorLogDosyasiYolu"',' $ConfFile
   sed -i 's,'"SystemLogFilePath = $(ConfigDeger SystemLogFilePath)"','"SystemLogFilePath = SystemInfoDosyasiYolu"',' $ConfFile
   sed -i 's,'"TarDirLogFilePath = $(ConfigDeger TarDirLogFilePath)"','"TarDirLogFilePath = TarDosyasiYolu"',' $ConfFile
  #KLASOR Yollari
   sed -i 's,'"LogFileDir = $(ConfigDeger LogFileDir)"','"LogFileDir = LogDosyasiKlasoru"',' $ConfFile
   sed -i 's,'"RootDirPath = $(ConfigDeger RootDirPath)"','"RootDirPath = Pg_Backup"',' $ConfFile
   sed -i 's,'"ScriptsDirPath = $(ConfigDeger ScriptsDirPath)"','"ScriptsDirPath = BinScript"',' $ConfFile
   sed -i 's,'"LibDirPath = $(ConfigDeger LibDirPath)"','"LibDirPath = Kutuphane"',' $ConfFile
   sed -i 's,'"ConfDirPath = $(ConfigDeger ConfDirPath)"','"ConfDirPath = ConfPages"',' $ConfFile
#   echo "Cevap : $cevap"
  echo -e "\n !!! NOT : \n Dosya yollarinin adreslendirinin varsayılana dondurulmesi islemi bitti.\n Tekrar düzenlemek icin './run.sh' calistirin.\n\n"
 else
   echo "  Varsayilana geri dondurme islemi iptal edildi."
 fi
