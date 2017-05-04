#!/bin/bash

#KUTUPHANE
#===========
 source Lib/parametre_finder.lib
 source Lib/colors.lib

 verbose=$1
 Komut=$2

#echo $verbose " " $Ekle
#HEADERS
#===========
 case $Komut in
   Ekle)
	if grep -q $(ConfigDeger RootDirPath) $CrontabPath; then
	   if [[ "$verbose" == "v" ]]; then printf ${YELLOW}"\n\n\t Pg_Backup run.sh gorev tanimi komutu zaten mevcut."${NC}; fi
	else
	   if [[ "$verbose" == "v" ]]; then printf ${YELLOW}"\n\n\t Crontab dosyasina kayit islemi tamamlandi."${NC}; fi

	   echo "" >> $CrontabPath
	   echo "#!: Pg_Backup Gorev Tanimi  !!! Onemli bu aciklama satirini kaldirmayin" >> $CrontabPath
	   echo -e "0 3    * * *   root    cd $RootDirPath && ./run.sh" >> $CrontabPath
	   echo "##!:" >> $CrontabPath
	fi
	;;
   Sil)
	if grep -q $(ConfigDeger RootDirPath) $CrontabPath; then
           satir_no=$(grep -n -o -m 1 '#!:' $CrontabPath | cut -d ':' -f1)
           satir_son=$(grep -n -o -m 1 '##!:' $CrontabPath | cut -d ':' -f1)

	   sed -i.backup "$satir_no,$satir_son d" $CrontabPath
	   if [[ "$verbose" == "v" ]]; then printf ${YELLOW}"\n\n\t Gorev tanimi crontab dan silindi."${NC}; fi
	else
	   if [[ "$verbose" == "v" ]]; then printf ${YELLOW}"\n\n\t Crontab da silinecek bir gorev tanimi yok."${NC}; fi
	fi
	;;
 esac
