#!/bin/bash
clear

echo "###########################################################"
echo "###########################################################"
echo "######                     #####                     ######"
echo "######                     #####                     ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################                     ######"
echo "######     #####################                     ######"
echo "######     #####################     ######################"
echo "######     #####################     ######################"
echo "######     #####################     ######################"
echo "######                     #####     ######################"
echo "######                     #####     ######################"
echo "###########################################################"
echo "###########################################################"
echo "#                                                         #"
echo "#         Welcome to the CP Devsite setup script!         #"
echo "#  We're going to need some information before we begin.  #"
echo "#                                                         #"
echo "###########################################################"
echo ""
echo ""
echo "First, some MySQL credentials"
read -p "MySQL username: " MY_USER
stty -echo
read -p "MySQL password: " MY_PASS; echo
stty echo
read -p "MySQL DB name: " MY_TABLE
read -p "CP server username: " CP_USER

send_to_cp(){
  scp ./$1 ./$2 $CP_USER@dev.customerparadigm.com:/home/$CP_USER/public_html/
}

NOW=$(date +"%m-%d-%Y")
FILES="cpdev.$NOW.tgz"
DB="cpdev.$NOW.sql"
EXCLUDE="exclude.$NOW.txt"

echo ""
echo "Ready to rock!"
echo ""
echo "Ignoring certain file types..."
echo "*.sql
*.tar*
*.zip
*.psd
*.tgz
error_log
var/report/*
var/tmp/*
var/import/*
/var/export/*
var/rw_google_base/*
var/cache/*
var/session/*" > $EXCLUDE

echo "Zipping up all relevant files..."
tar zcf $FILES -X $EXCLUDE *;
echo " Done zipping up files..."

rm $EXCLUDE

echo ""
echo "MYSQL"
echo "Starting dump of MySQL table..."

echo "Exporting database info..."

mysqldump -u $MY_USER -p$MY_PASS $MY_TABLE > $DB
echo " Done exporting database..."

echo ""
echo "SENDING FILES"
echo "Sending files to CP..."
send_to_cp $FILES $DB

echo ""
echo "Cleaning up files..."
rm $FILES
rm $DB

echo ""
echo ""
echo "###########################################################"
echo "###       ####        ###   ###  ###        ###   ###   ###"
echo "###  ####  ###  ####  ###    ##  ###  #########   ###   ###"
echo "###  ##### ###  ####  ###  #  #  ###  #########   ###   ###"
echo "###  ##### ###  ####  ###  ##    ###        ###   ###   ###"
echo "###  ####  ###  ####  ###  ###   ###  #####################"
echo "###       ####        ###  ####  ###        ###   ###   ###"
echo "###########################################################"
echo "###                                                     ###"
echo "###         Now go run the install script at CP         ###"
echo "###                                                     ###"
echo "###########################################################"
