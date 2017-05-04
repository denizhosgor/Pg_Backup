#!/bin/bash

#KUTUPHANE
#===========
 source Lib/parametre_finder.lib
 source Lib/colors.lib

 verbose=$1

#HEADERS
#===========
 headerTest="\t${YELLOW}%-30s ${GREEN}%-8s ${NC}\n"
 headerTestH="\t${YELLOW}%-30s ${RED}%-8s ${NC}\n"

 echo "" >> $LogFilePath
 echo -e "KONTROLLER" >> $LogFilePath
 echo -e "===========" >> $LogFilePath

# HARICI DISK TAKILI MI
#======================
 if [[ "$BckRootDir" == "$(mount | grep $BckRootDir | awk '{print $3}')" ]] && [[ "$KlasorYeri" == "HariciDisk" ]]; then
    if [[ "$verbose" == "v" ]]; then printf "$headerTest" "Usb Disk takili" "[ OK ]"; fi
    echo -e " Usb Disk takili \t[ OK ]" >> $LogFilePath
 else
    printf "$headerTestH" "Usb Disk takili" "[ HATA ]"
    echo -e " Usb Disk takili \t[ HATA ]" >> $LogFilePath
    hata=1
 fi

# KLASOR YOLLARI KONTROLU
#=========================
# 'DirListIcerik' Arrayi ve 'ConfigDizi' fonksiyonu "parametre_finder.lib" dosyasini kaynak olarak gosterdigimizden data oradan geliyor.

 for (( i=0; i<${#DirListIcerik[@]}; i++ ))
  do
    read "${DirListIcerik[$i]}" <<< "${DirListIcerik[$i]}"
    if [[ -d $BckRootDir/$SvrNameDir/$bugun/${DirListIcerik[$i]} ]]; then
       if [ $(($i+1)) -eq ${#DirListIcerik[@]} ]; then
	   if [[ "$verbose" == "v" ]]; then printf "$headerTest" "Klasor yollari" "[ OK ]"; fi
	   echo -e " Klasor yollari \t[ OK ]" >> $LogFilePath
       fi
    else
       printf  "$headerTestH" "Klasor yollari" "[ HATA ]"
       echo -e " Klasor yollari \t[ HATA ]" >> $LogFilePath
       hata=1
    fi
 done

echo " "

#CIKIS KOMUTU
if [[ $hata -eq 1 ]]; then exit 1; fi
