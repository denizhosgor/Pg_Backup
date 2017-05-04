#!/bin/bash
#KAYNAKLAR
#==========
 source Lib/pathfinder.lib
 source Lib/colors.lib

#TANIMLAMALAR
#=============
 #DEGISKENLER
 #------------
  headerAd="${YELLOW}%-24s %1s ${PURPLE}%-35s ${YELLOW}%10s ${NC}\t"
  headerDatabase="${YELLOW}%-26s %1s ${PURPLE}%-35s ${YELLOW}%10s ${NC}\t"
  headerScp="${YELLOW}%-18s %1s ${PURPLE}%-35s ${YELLOW}%10s ${NC}\t"
  headerFtp="${YELLOW}%-23s %1s ${PURPLE}%-35s ${YELLOW}%10s ${NC}\t"
  headerMail="${YELLOW}%-22s %1s ${PURPLE}%-35s ${YELLOW}%10s ${NC}\t"

 #DIZILER
 #--------
  UsbListe=()
  ConfigArrayListAd=(BckServer GndServer BckRootDir SvrNameDir LogDosyAd ErrorLogAd SystemLogAd TarDirLogAd)
  ConfigArrayListDatabase=(KlasorYeri DataBase_Yedek Bck_Secim SaklamaTipi Klasor_Yedek Image_Yedek GondermeTipi)
  ConfigArrayListScp=(Kullanici BaglantIP ScpPort)
  ConfigArrayListFtp=(ServerIP FtpPort UserID Password)
  ConfigArrayListMail=(host mail_Port mailSendTo)

#FONKSIYONLAR
#=============
 function pause(){
   read -p "$*" && Secim=""
 }

 function pause2(){
   read -p "$*" && break
 }

 function Exit(){
   [[ $Cevap = [E] ]] && clear && exit
   Secim="" && break
 }

 function ConfigTanimAd(){
	case $@ in
	  BckServer)
		echo "Sunucu Adi" ;;
	  GndServer)
		echo "Depo Sunucusunun Adi" ;;
	  BckRootDir)
		echo "Usb Disk Baglama Yolu" ;;
	  SvrNameDir)
		echo "Yedek Klasor Adi"	;;
	  LogDosyAd)
		echo "Genel Log Dosyasi Adi" ;;
	  ErrorLogAd)
		echo "Hata Log Dosyasi Adi" ;;
	  SystemLogAd)
		echo "Sistem Log Dosyasi Adi" ;;
	  TarDirLogAd)
		echo "Tar Log Dosyasi Adi" ;;
	esac
 }

 function ConfigTanimDatabase(){
	case $@ in
	  KlasorYeri)
		echo "Yedek Alinancak Yer" ;;
	  DataBase_Yedek)
		echo "DB Yedek Alma Durumu" ;;
	  Bck_Secim)
		echo "Yedekleme Secimi"	;;
	  SaklamaTipi)
		echo "Database Saklama Dongusu"	;;
	  Klasor_Yedek)
		echo "Klasor Yedek Alma Durumu"	;;
	  Image_Yedek)
		echo "Imaj Alma Durumu"	;;
	  GondermeTipi)
		echo "Veri Gonderme Durumu" ;;
	esac
 }

 function ConfigTanimScp(){
        case $@ in
          Kullanici)
                echo "Kullanici Adi" ;;
          BaglantIP)
                echo "Uzak Sunucu IP" ;;
          ScpPort)
                echo "Uzak Sunucu Port" ;;
        esac
 }

 function ConfigTanimFtp(){
        case $@ in
          ServerIP)
                echo "Ftp Sunucu IP" ;;
          FtpPort)
                echo "Ftp Sunucu Port" ;;
          UserID)
                echo "Ftp Kullanici Adi" ;;
          Password)
                echo "Ftp Kullanici Sifresi" ;;
        esac
 }

 function ConfigTanimMail(){
        case $@ in
          host)
                echo "Mail Sunucu IP" ;;
          mail_Port)
                echo "Mail Sunucu Port" ;;
          mailSendTo)
                echo "Gonderen Mail Adresi" ;;
        esac
 }

 function Menu(){
  printf '\e[0m'
  printf ${GREEN}
  echo '        ____           ____             _          ____'
  echo '       |  _ \ __ _    | __ )  __ _  ___| | ___   _|  _ \'
  echo '       | |_) / _` |   |  _ \ / _` |/ __| |/ / | | | |_) |'
  echo '       |  __/ (_| |   | |_) | (_| | (__|   <| |_| |  __/           ___     ___'
  echo '       |_|   \__, |___|____/ \__,_|\___|_|\_\\__,_|_|      _  __  |_  |   / _ \'
  echo '             |___/_____|                                  | |/ / / __/ _ / // /'
  echo '                                                          |__ / /____/(_)\___/'
  echo -e "\n\n"
  printf ${LBLUE}
  echo '      __  ___'
  echo '     /  |/  /__ ___  __ __'
  echo '    / /|_/ / -_) _ \/ // /'
  echo '   /_/  /_/\__/_//_/\_,_/'
  echo " -----------------------------"
  echo ""
 #BACKUP ALMA
  printf ${PURPLE}
  echo "  P - Backup Programini Calistir"
 #AYARLAR
   if [[ "$@" != "S" ]]; then printf ${WHITE}; else printf ${WHITELBLUE}; fi
  echo "  S - Ayarlar"
  printf ${NC}
   if [[ "$@" == "S" ]]; then
      printf ${YELLOW}
      echo "    1 - Klasor ve Dosya Isimlendirmeleri"
      echo "    2 - Backup Ayarlari ve Tanimlari"
      echo "    3 - Mail Ayarlari ve Tanimlari"
      printf ${LCYAN}
      echo "    G - Geri"
      echo ""
   fi
 #TRANSFER AYARLARI
  if [[ "$@" != "M" ]]; then printf ${WHITE}; else printf ${WHITELBLUE}; fi
  echo "  M - Transfer Ayarlari"
  printf ${NC}
   if [[ "$@" == "M" ]]; then
      printf ${YELLOW}
      echo "    1 - Scp Ayarlari"
      echo "    2 - Ftp Ayarları"
      printf ${LCYAN}
      echo "    G - Geri"
      echo ""
   fi
 #USB DISK
   if [[ "$@" != "D" ]]; then printf ${WHITE}; else printf ${WHITELBLUE}; fi
  echo "  D - USB Disk Ayarlari"
  printf ${NC}
   if [[ "$@" == "D" ]]; then
      printf ${YELLOW}
      echo "    1 - Takili Usb Disk(ler)"
      echo "    2 - Baglanmis Usb Disk Var mı?"
      echo "    3 - Usb Disk Bagla"
      echo "    4 - Usb Disk Ayir"
      echo "    5 - Usb Disk Formatla"
      echo "    6 - Fstab a ekle"
      echo "    7 - Fstab dan cikar"
      printf ${LCYAN}
      echo "    G - Geri"
      echo ""
   fi
 #TEST
   if [[ "$@" != "T" ]]; then printf ${WHITE}; else printf ${WHITELBLUE}; fi
  echo "  T - Test"
  printf ${NC}
   if [[ "$@" == "T" ]]; then
      printf ${YELLOW}
      echo "    1 - Hepsi"
      echo "    2 - Local Backup"
      echo "    3 - Usb Backup"
      echo "    4 - Scp Backup"
      echo "    5 - Ftp Backup"
      echo "    6 - Mail"
      printf ${LCYAN}
      echo "    G - Geri"
      echo ""
   fi
 #GOREV
   if [[ "$@" != "J" ]]; then printf ${WHITE}; else printf ${WHITELBLUE}; fi
  echo "  J - Cronjob"
  printf ${NC}
   if [[ "$@" == "J" ]]; then
      printf ${YELLOW}
      echo "    1 - Cronjob Ekle"
      echo "    2 - Cronjob Cikar"
      printf ${LCYAN}
      echo "    G - Geri"
      echo ""
   fi
 #AYAR SIFIRLAMA
  printf ${LGREEN}
  echo "  V - Varsayilan Ayarlar"
  printf ${LRED}"\n"
  echo "  E - Cikis"
  printf ${NC}
#  printf " Seciminiz : "
 }

#MENU SECENEKLERI
#=================
 while : ; do
  clear
  Menu

  if [[ "$Secim" != [PSMDTJVE] ]]; then read -r -n 1 -s Secim;  fi
  echo -e "\n"

  case $Secim in
  #BACKUP ALMA PROGRAMI
    P)
	./run.sh v

        printf '\n\n \e[5m'
        pause '   Devam etmek icin [Enter] tusana basiniz...'
        printf '\e[0m'
	;;
  #AYARLAR MENUSU
    S)
	clear
	Menu $Secim
	while : ; do
	   read -r -n 1 -s Cevap
	   case $Cevap in
	    1)
		printf ${CYAN}"\n Isimlendirme Islemleri\n -----------------------\n"${NC}
		for (( i=0; i<${#ConfigArrayListAd[@]}; i++ ))
		 do
		   printf "$headerAd" "  $(ConfigTanimAd ${ConfigArrayListAd[$i]})" ":" "$(ConfigDeger ${ConfigArrayListAd[$i]})" "Degistirilsin mi? (E/H)"
		   while read -r -n 1 -s Cevap; do
		     if [[ $Cevap = [EeHh] ]]; then
			[[ $Cevap = [Ee] ]] && printf ${WHITE}"\n   Yeni ismi giriniz : "${RED} && \
			               while read -r GirilenDeger; do
			                 if [[ ! -z "${GirilenDeger// }" ]]; then break; else printf ${WHITERED}"   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE} ; fi
			               done && \
			               GirilenDeger=$(echo $GirilenDeger|sed -r 's/ //g') && \
			               sed -i 's,'"${ConfigArrayListAd[$i]} = $(ConfigDeger ${ConfigArrayListAd[$i]})"','"${ConfigArrayListAd[$i]} = $GirilenDeger"',' $ConfFile && \
			               printf ${GREEN}"     [ OK ]\n"${NC} && break
			[[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
	            fi
	           done
		done
		printf '\n\n \e[5m'
		pause2 '   Devam etmek icin [Enter] tusana basiniz...'
		printf '\e[0m'
		;;
	  #YEDEK alma ve BACKUP secenekleri
	    2)
		printf ${CYAN}"\n DataBase Islemleri\n -------------------\n"${NC}
	        for (( i=0; i<${#ConfigArrayListDatabase[@]}; i++ ))
	         do
		   function Tanimlama(){
		     case $@ in
			KlasorYeri)
				SecenekListe=(HariciDisk YerelKlasor)
				for (( s=0; s<${#SecenekListe[@]}; s++ )); do printf "\n\t[ $s ] - ${SecenekListe[$s]}"; done
				;;
			DataBase_Yedek|Klasor_Yedek|Image_Yedek)
				SecenekListe=(Evet Hayir)
				for (( s=0; s<${#SecenekListe[@]}; s++ )); do printf "\n\t[ $s ] - ${SecenekListe[$s]}"; done
				;;
			Bck_Secim)
				s=0
				SecenekListe=()
				printf ${LRED}"\n    '1->Pazartesi', '2->Sali', '3->Carsamba', '4->Persembe', '5->Cuma', '6->Cumartesi', '7->Pazar'\n"${NC}
				IFS=$'\r\n'
				for SecenekListe in $(cat $ConfFile | grep ';' | cut -d ';' -f2 | cut -d '#' -f1)
				 do
				    printf "\n\t[ $s ] - ${SecenekListe[*]}"
				    s=$(($s + 1))
				done
				;;
			SaklamaTipi)
				SecenekListe=(Haftalik Aylik DiskBoyutu)
				for (( s=0; s<${#SecenekListe[@]}; s++ )); do printf "\n\t[ $s ] - ${SecenekListe[$s]}"; done
				;;
			GondermeTipi)
				SecenekListe=(Local Scp Ftp)
				for (( s=0; s<${#SecenekListe[@]}; s++ )); do printf "\n\t[ $s ] - ${SecenekListe[$s]}"; done
				;;
		     esac
		   }

	           printf "$headerDatabase" "  $(ConfigTanimDatabase ${ConfigArrayListDatabase[$i]})" ":" "$(ConfigDeger ${ConfigArrayListDatabase[$i]})" "Degistirilsin mi? (E/H)"
	           while read -r -n 1 -s Cevap; do
	             if [[ $Cevap = [EeHh] ]]; then
	                [[ $Cevap = [Ee] ]] && Tanimlama ${ConfigArrayListDatabase[$i]} && \
				       printf ${WHITE}"\n   Seciminiz : "${RED} && \
                                       while read -r -n 1 GirilenDeger; do
                                         if [[ ! -z "${GirilenDeger// }" ]] && [[ $GirilenDeger =~ ^[0-9] ]]; then break; else printf ${WHITERED}"\n   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE} ; fi
                                       done && \
				       if [[ "${ConfigArrayListDatabase[$i]}" == "Bck_Secim" ]]; then
					  GirilenDeger=$GirilenDeger
				       elif [[ "${ConfigArrayListDatabase[$i]}" == "KlasorYeri" ]]; then
					  GirilenDeger=${SecenekListe[$GirilenDeger]}
				       elif [[ "${ConfigArrayListDatabase[$i]}" == "GondermeTipi" ]]; then
					  GirilenDeger=${SecenekListe[$GirilenDeger]}
                                       else
					  GirilenDeger=$(echo ${SecenekListe[$GirilenDeger]}|sed 's/\(.\{1\}\).*/\1/')
				       fi && \
                                       sed -i 's,'"${ConfigArrayListDatabase[$i]} = $(ConfigDeger ${ConfigArrayListDatabase[$i]})"','"${ConfigArrayListDatabase[$i]} = $GirilenDeger"',' $ConfFile && \
                                       printf ${GREEN}"     [ OK ]\n\n"${NC} && break
	                [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
	            fi
	           done
	        done
	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
		printf '\e[0m'
		;;
            3)
        	printf ${CYAN}"\n E-Mail Ayarlari\n ----------------\n"${NC}
        	for (( i=0; i<${#ConfigArrayListMail[@]}; i++ ))
	         do
	           printf "$headerMail" "  $(ConfigTanimMail ${ConfigArrayListMail[$i]})" ":" "$(ConfigDeger ${ConfigArrayListMail[$i]})" "Degistirilsin mi? (E/H)"
	           while read -r -n 1 -s Cevap; do
	             if [[ $Cevap = [EeHh] ]]; then
	                [[ $Cevap = [Ee] ]] && printf ${WHITE}"\n   Yeni ismi giriniz : "${RED} && \
                                       while read -r GirilenDeger; do
                                         if [[ ! -z "${GirilenDeger// }" ]]; then break; else printf ${WHITERED}"   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE} ; fi
                                       done && \
                                       GirilenDeger=$(echo $GirilenDeger|sed -r 's/ //g') && \
                                       sed -i 's,'"${ConfigArrayListMail[$i]} = $(ConfigDeger ${ConfigArrayListMail[$i]})"','"${ConfigArrayListMail[$i]} = $GirilenDeger"',' $ConfFile && \
                                       printf ${GREEN}"     [ OK ]\n"${NC} && break
	                [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
	            fi
	           done
	        done
	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
	        ;;
	    G|E)
		Exit
		;;
	   esac
	done
	;;
  #TRANSFER AYARLARI
    M)
	clear
	Menu $Secim
	while : ; do
	   read -r -n 1 -s Cevap
	   case $Cevap in
	    1)
	        printf ${CYAN}"\n Secure Transfer Protocol(SCP) Ayarlari\n ---------------------------------------\n"${NC}
	        for (( i=0; i<${#ConfigArrayListScp[@]}; i++ ))
	         do
	           printf "$headerScp" "  $(ConfigTanimScp ${ConfigArrayListScp[$i]})" ":" "$(ConfigDeger ${ConfigArrayListScp[$i]})" "Degistirilsin mi? (E/H)"
	           while read -r -n 1 -s Cevap; do
	             if [[ $Cevap = [EeHh] ]]; then
	                [[ $Cevap = [Ee] ]] && printf ${WHITE}"\n   Yeni ismi giriniz : "${RED} && \
                                       while read -r GirilenDeger; do
                                         if [[ ! -z "${GirilenDeger// }" ]]; then break; else printf ${WHITERED}"   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE} ; fi
                                       done && \
                                       GirilenDeger=$(echo $GirilenDeger|sed -r 's/ //g') && \
                                       sed -i 's,'"${ConfigArrayListScp[$i]} = $(ConfigDeger ${ConfigArrayListScp[$i]})"','"${ConfigArrayListScp[$i]} = $GirilenDeger"',' $ConfFile && \
                                       printf ${GREEN}"     [ OK ]\n"${NC} && break
	                [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
	            fi
	           done
	        done
	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
		;;
	    2)
		printf ${CYAN}"\n File Transfer Protocol(FTP) Ayarlari\n -------------------------------------\n"${NC}
	        for (( i=0; i<${#ConfigArrayListFtp[@]}; i++ ))
	         do
	           printf "$headerFtp" "  $(ConfigTanimFtp ${ConfigArrayListFtp[$i]})" ":" "$(ConfigDeger ${ConfigArrayListFtp[$i]})" "Degistirilsin mi? (E/H)"
	           while read -r -n 1 -s Cevap; do
	             if [[ $Cevap = [EeHh] ]]; then
	                [[ $Cevap = [Ee] ]] && printf ${WHITE}"\n   Yeni ismi giriniz : "${RED} && \
                                       while read -r GirilenDeger; do
                                         if [[ ! -z "${GirilenDeger// }" ]]; then break; else printf ${WHITERED}"   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE} ; fi
                                       done && \
                                       GirilenDeger=$(echo $GirilenDeger|sed -r 's/ //g') && \
                                       sed -i 's,'"${ConfigArrayListFtp[$i]} = $(ConfigDeger ${ConfigArrayListFtp[$i]})"','"${ConfigArrayListFtp[$i]} = $GirilenDeger"',' $ConfFile && \
                                       printf ${GREEN}"     [ OK ]\n"${NC} && break
	                [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
	            fi
	           done
	        done
	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
	        ;;
	    G|E)
		Exit
		;;
	   esac
	done
	;;
  #DISK MENUSU
    D)
        clear
        Menu $Secim
        while : ; do
	   function UsbSearch(){
                i=0
                IFS=$'\r\n'
                for UsbListe in $(lsblk -o KNAME,SERIAL,TRAN,MODEL | grep 'usb\|USB\|Usb')
                 do
                   UsbListeIcerik+=($UsbListe)
                   for Ayristir in ${UsbListeIcerik[$i]}
                    do
                        KNAME+=($(echo $Ayristir | awk '{print $1}'))
                        SERIAL+=($(echo $Ayristir | awk '{print $2}'))
                        TRAN+=($(echo $Ayristir | awk '{print $3}'))
                        MODEL+=($(echo $Ayristir | sed -r 's/^([^ ]*[ ]*){3}(.*)/\2/'))
                        i=$(($i+1))
                   done
                done

		case $@ in
		  1)
		     printf ${CYAN}
                     awk 'BEGIN { printf ("\n\t%-3s %-5s %-10s\t %-20s\t %-30s\n")," ", "TYPE", "DISK", "MODEL", "SERIAL"; printf ("\t%3s %-5s %-10s\t %-20s\t %-30s\n")," ", "-----", "----------", "-------------", "-----------------";}'
                     printf ${NC}
                     for ((a=0; a<$i; a++ ));
                      do
                        printf "\t%3s %-5s %-10s\t %-20s\t %-30s\n" "[$a]" "${TRAN[$a]}" "/dev/${KNAME[$a]}" "${MODEL[$a]}" "${SERIAL[$a]}"
                     done
		     ;;
                  2)
		    printf ${CYAN}"\n\tSunucuya Baglanmıs olan Usb Disk(ler)\n\n"${NC}
                    for (( a=0; a<$i; a++ ));
                     do
                       if [[ -z "$(mount | grep /dev/${KNAME[$a]})" ]]; then printf "\t Baglanmis her hangi bir Usb Disk Yok\r"; else printf "\t%-3s %-60s" "[$a]" "$(mount | grep /dev/${KNAME[$a]})" && printf "\n"; fi
                    done
		    ;;
		esac
	   }

	   function UsbProcess(){
                printf ${YELLOW}"\n  Islemi iptal etmek icin (H)\n   Seciminiz :"${NC}
                while read -r -n 1 GirilenDeger; do
                 if [[ ! -z "${GirilenDeger// }" ]] && [[ $GirilenDeger =~ ^[0-9] ]]; then
		    case $@ in
		     1)
			mount "/dev/${KNAME[$GirilenDeger]}1" $(ConfigDeger BckRootDir)
			printf ${YELLOW}"\n\n  Usb Disk bilgisayara baglandi.\n  Kontrol icin '2 - Baglanmis Usb Disk Var mı?' dan kontrol edebilirsiniz."${NC}
			;;
		     2)
			umount "/dev/${KNAME[$GirilenDeger]}1"
			printf ${YELLOW}"\n\n  Usb Disk bilgisayardan ayrildi.\n  Kontrol icin '2 - Baglanmis Usb Disk Var mı?' dan kontrol edebilirsiniz."${NC}
			;;
		     3)
			if [[ -z "$(mount | grep /dev/${KNAME[$GirilenDeger]})" ]]; then
			   printf "\n\n"
			   echo y | mkfs.ext4 -L 'Pg_Backup-Drive' "/dev/${KNAME[$GirilenDeger]}1"
			else
			   printf ${LRED}"\n\n\t  Secilen Usb Disk dosya sistemine bagli.\n\t  Usb Disk i dosya sisteminden ayirin.\n"${NC}
			fi
			;;
                     4)
			if grep -q $(lsblk -o KNAME,UUID | grep ${KNAME[$GirilenDeger]}1 | sed -r 's/([^ ]*.[ ])//') $FstabPath; then
                           printf "\n\n\t Bu UUID ile zaten bir kayit mevcut."
			else
                           printf "\n\n\t Fstab dosyasina kayit islemi tamamlandi."
                           echo "" >> $FstabPath
                           echo "#!: Pg_Backup Disk Secimi  !!! Onemli bu aciklama satirini kaldirmayin" >> $FstabPath
                           echo -e "UUID=$(lsblk -o KNAME,UUID | grep ${KNAME[$GirilenDeger]}1 | sed -r 's/([^ ]*.[ ])//')\t$(ConfigDeger BckRootDir)\tauto\trw,relatime,errors=remount-ro,auto,nouser\t0\t0" >> $FstabPath
                           echo "##!:" >> $FstabPath
			fi
			;;
                     5)
                        if grep -q $(lsblk -o KNAME,UUID | grep ${KNAME[$GirilenDeger]}1 | sed -r 's/([^ ]*.[ ])//') $FstabPath; then
			   satir_no=$(grep -n -o -m 1 '#!:' $FstabPath | cut -d ':' -f1)
			   satir_son=$(grep -n -o -m 1 '##!:' $FstabPath | cut -d ':' -f1)

			   sed -i.backup "$satir_no,$satir_son d" $FstabPath
			   printf "\n\n\t Fstab dosyasindan silme islemi tamamlandi."
			else
			   printf "\n\n\t Fstab dosyasinda UUID i $(lsblk -o KNAME,UUID | grep ${KNAME[$GirilenDeger]}1 | sed -r 's/([^ ]*.[ ])//') olan bir kayit yok."
			fi
			;;
		    esac
                    break
                 elif [[ $GirilenDeger == [Hh] ]]; then
                    printf ${YELLOW}"\n\n  Islem iptal edildi."${NC}
                    break
                 else
                    printf ${WHITERED}"\n   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE}
                 fi
                done
	   }

           read -r -n 1 -s Cevap
           case $Cevap in
            1)
		UsbSearch 1

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
		;;
            2)
		UsbSearch 2

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            3)
		printf ${CYAN}"\n Disk Baglama\n\n"${NC}
		if [ -d $(ConfigDeger BckRootDir) ]; then
		 echo ""
                 printf "$headerAd" "  $(ConfigTanimAd BckRootDir)" ":" "$(ConfigDeger BckRootDir)" "Degistirilsin mi? (E/H)"
		 while read -r -n 1 -s Cevap; do
		  if [[ $Cevap = [EeHh] ]]; then
		     [[ $Cevap = [Ee] ]] && printf ${WHITE}"\n   Yeni klasor yolunu yaziniz : "${RED} && \
                                       while read -r GirilenDeger; do
                                         if [[ ! -z "${GirilenDeger// }" ]]; then
					    if [ -d $GirilenDeger ]; then
					       break
					    else
					       printf ${WHITERED}"\n   Belirtilen Adres Yolu Bulunamadi "${NC}${WHITE}
					       printf "\n   $GirilenDeger yolundaki klasorler olusturulsun mu ? (E/H)"
					       while read -r -n 1 -s Olustur; do
					        if [[ $Olustur == [EeHh] ]]; then
						  [[ $Olustur = [Ee] ]] && mkdir -p $GirilenDeger && printf "\n   Klasor yolu olusturuldu." && break
						  [[ $Olustur = [Hh] ]] && break
					        fi
					       done
					    fi
					    break
					 else printf ${WHITERED}"   Yanlis giris yaptiniz. Lutfen Tekrar giris yapin : ${NC}"${WHITE}
					 fi
                                       done && \
				       GirilenDeger=$(echo $GirilenDeger|sed -r 's/ //g') && \
                                       sed -i 's,'"BckRootDir = $(ConfigDeger BckRootDir)"','"BckRootDir = $GirilenDeger"',' $ConfFile && \
                                       printf ${GREEN}"     [ OK ]\n"${NC} && break
		     [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
		  fi
		 done
		else
		 printf ${WHITERED}"\n   Belirlenmis olan baglama noktasi olusturulmamis.${NC} \n"${WHITE}
                 printf "$headerAd" "  $(ConfigTanimAd BckRootDir)" ":" "$(ConfigDeger BckRootDir)" "Olusturulsun  mu? (E/H)"
                 while read -r -n 1 -s Cevap; do
		  if [[ $Cevap == [EeHh] ]]; then
		     [[ $Cevap = [Ee] ]] && mkdir -p $(ConfigDeger BckRootDir) && printf "\n   Klasor yolu olusturuldu." && printf ${GREEN}"     [ OK ]\n"${NC} && break
		     [[ $Cevap = [Hh] ]] && printf ${GREEN}"     [ OK ]\n"${NC} && break
		  fi
		 done
		fi

                UsbSearch 1
		UsbProcess 1

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            4)
                UsbSearch 2
		UsbProcess 2

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            5)
		UsbSearch 1
		UsbProcess 3

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            6)
		#relatime dosya giris ve degistirme islemlerinin zamanlarina ihtiyac duyan bir program oldugu takdirde kullaniliyor.(noatime,relatime)
		#errors=remount-ro disk okuma hatasi aldiginda read only ye donduruyor.

		UsbSearch 1
		UsbProcess 4

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            7)
		UsbSearch 1
                UsbProcess 5

                printf '\n\n \e[5m'
                pause2 '   Devam etmek icin [Enter] tusana basiniz...'
                printf '\e[0m'
                ;;
            G|E)
                Exit
                ;;
           esac
        done
        ;;
  #TEST
    T)
        clear
        Menu $Secim
	while : ; do
	   read -r -n 1 -s Cevap
	   case $Cevap in
	    1)

	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
		;;
	    2)

	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
	        ;;
	    G|E)
		Exit
		;;
	   esac
	done
	;;
  #GOREV MENUSU
    J)
        clear
        Menu $Secim
	while : ; do
	   read -r -n 1 -s Cevap
	   case $Cevap in
	    1)
		./BinScript/crontab.sh v Ekle CrontabPath RootDirPath

	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
		;;
	    2)
		./BinScript/crontab.sh v Sil CrontabPath RootDirPath
	        printf '\n\n \e[5m'
	        pause2 '   Devam etmek icin [Enter] tusana basiniz...'
	        printf '\e[0m'
	        ;;
	    G|E)
		Exit
		;;
	   esac
	done
	;;
  #SIFIRLAMA
    V)
	./resetConf.sh

        printf '\n\n \e[5m'
        pause '   Devam etmek icin [Enter] tusana basiniz...'
        printf '\e[0m'
	;;
    E)
	clear
	break
	;;
  esac
 done



# ----------------------	YENI PARAMETRE EKLEMEK ICIN KOLAYLASTIRILMIS YOL	--------------------
#
# Yeni bir parametre eklemek istendiginde "printf" ile baslayan kod kopyalanarak en alt satira yapistirilir.
#	Daha Sonra !!!!!!  sed -i '40,$ s/AYARDEGER/Yeni_Parametre/g' setConf.sh  !!!!! Kodu ile yeni parametre "AYARDEGER" ile degistirilir.
#	En son olarak !!!  sed -i '40,$ s/^#//g' setConf.sh	!!!!! Kodu ile kodun basindaki "#" isareti kaldirilarak secenek aktif hale getirilir.
