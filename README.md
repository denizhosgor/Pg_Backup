 ____           ____             _          ____
|  _ \ __ _    | __ )  __ _  ___| | ___   _|  _ \
| |_) / _` |   |  _ \ / _` |/ __| |/ / | | | |_) |
|  __/ (_| |   | |_) | (_| | (__|   <| |_| |  __/
|_|   \__, |___|____/ \__,_|\___|_|\_\\__,_|_|
      |___/_____|


YAZAN : DENIZ HOSGOR

TARIH : 06/09/2012

DOSYA VERSIYON: 1.2.2 (" Versiyon bilgileri en alt kisimdadir. ")

DOSYA ADI     : DB_Backup.sh

DOSYA YOLU    : /root/DB_Backup.sh

SUNUCUDA SAKLANAN VERI :
  Dijital harita icin gerekli olan kara, deniz, yol, mahalle vs. gibi
  bilgiler mevcut. Ayni zamanda GIS icin gerekli olan "Schemalar" ve
  "Functionlar" da yuklu

BETIGIN AMACI :
  Sistemde mevcut olan harita database sunucusunun belirli periyodlar
  halinde yedeginin alinmasini saglamak. Alinacak olan yedegin bicimini
  "Full" yada "Incremental" olarak belirlenebilmesi. Alinan yedegin
  nerede saklanacaginin belirlenebilmesi ve buna gore gerekli ise
  transfer islemlerinin yapilmasini saglamak.
