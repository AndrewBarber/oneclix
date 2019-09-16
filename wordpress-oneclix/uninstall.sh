#!/bin/bash

clear
echo "###########################################"
echo "#     Welcome to the wordpress oneclix!   #"
echo "###########################################"
echo "#          Any issues? Contact:           #"
echo "#     helpdesk@racetrackpitstop.co.uk     #"
echo "###########################################"


sleep 10s

SSL="YES"

while getopts d:s:ms:e option
    do
    case "${option}"
        in
            d) DOMAIN=${OPTARG,,};;
            s) SSL=${OPTARG^^};;
    esac
done

if [ -z "$DOMAIN" ]; then
        echo " "
        echo "###########################################"
        echo "# Pass a command flag with the domain name#"
        echo "# Eg. uninstall.sh -d andrewbarber.me     #"
        echo "#   Exiting now... please try again!      #"
        echo "###########################################"
        exit
fi
if [ "$EUID" -ne 0 ]; then
        echo " "
        echo "###########################################"
        echo "#          Please run with sudo           #"
        echo "#   Exiting now... please try again!      #"
        echo "###########################################"
        exit
    fi

echo " "
echo "###########################################"
echo "#           Removing the database         #"
echo "###########################################"
sleep 3s
DBNAME=$(grep "define( 'DB_NAME'" /home/admin/web/$DOMAIN/public_html/wp-config.php | sed -e "s/define( 'DB_NAME', '//g" | sed -e "s/' );//g")

/usr/local/vesta/bin/v-delete-database admin $DBNAME


echo " "
echo "###########################################"
echo "#        Removing domain and files        #"
echo "###########################################"
sleep 3s

/usr/local/vesta/bin/v-delete-domain admin $DOMAIN



echo " "
echo "###########################################"
echo "#                  All gone!              #"
echo "###########################################"
echo "#          Any issues? Contact:           #"
echo "#  andrew.barber@racetrackpitstop.co.uk   #"
echo "###########################################"


subject="Website Removed: $DOMAIN"
body="$body               Website removed           "
body="$body          $DOMAIN       "

email=$(grep admin: /etc/passwd | awk -F':' '{print $5}')

echo -e "Subject:${subject}\n${body}" | sendmail -f "${email}" -t "${email}"

sleep 15s