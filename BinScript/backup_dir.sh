#!/bin/bash

#KUTUPHANE
#===========
 source Lib/parametre_finder.lib
 source Lib/function_finder.lib

 #BOS DIZI
 #--------
   TarDirListIcerik=()
   i=0

   echo -e "" >> $LogFilePath
   echo -e "KLASOR YEDEGININ ALINMASI " >> $LogFilePath
   echo -e "==========================" >> $LogFilePath
   echo -e "* NOT Ayrintili dokumu '$TarDirLogPath' dosyasindan inceleyebilirsiniz." >> $LogFilePath

   echo -e "" >> $TarDirLogFilePath
   echo -e "KLASORLERIN SIKISTIRILMASI" >> $TarDirLogFilePath
   echo -e "==========================" >> $TarDirLogFilePath

   printf ${CYAN}"  Klasorlerin Yedeklenmesi\n"
   #Diziye kaydedilen Listenin karsisina denk gelen degerler "(etc opt home) vs" diziye kaydediliyor.
   for TarDirList in $(ConfigDizi YedekAlKla)
    do
      TarDirListIcerik+=($TarDirList)
   done

   for sistemKlasorAdi in  ${TarDirListIcerik[@]}
    do

      echo `date +"%r"` " : $sistemKlasorAdi klasorunun yedeginin aliniyor." >> $LogFilePath
     # !!!!
     #$(echo $sistemKlasorAdi|sed -r 's/\//_/g').tar.gz ile 'var/log' veya 'var/www' gibi gelen tanimlar 'var_log, var_www' olarak degistiriliyor.
     #==========>
      tar -zcvf $BckRootDir/$SvrNameDir/$bugun/$DirImage/$(echo $sistemKlasorAdi|sed -r 's/\//_/g').tar.gz /$sistemKlasorAdi 2>>$ErrLogFilePath  >> $TarDirLogFilePath
       i=$(($i + 1))
          if [[ "$verbose" == "v" ]]; then
            sleep 0.1
            ProgressBar ${i} ${#TarDirListIcerik[@]} dir
          fi
   done

