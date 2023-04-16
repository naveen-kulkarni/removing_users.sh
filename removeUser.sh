#!/bin/bash

green='\033[0;32m'
endColor='\e[0m'
red='\033[0;31m'

autoHome=/root/naveen/homee
#/etc/auto.home
linuxHome=/root/naveen/linux
#/unixadmin/master_automount_maps/linux/auto.home
solarisHome=/root/naveen/solaris
#/unixadmin/master_automount_maps/solaris/auto_home
aixHome=/root/naveen/aix
#/unixadmin/master_automount_maps/aix/auto_home
taksBackupPath=/tmp
NOW=$(date +"%F")
echo -e "${green} Enter the task number ${endColor}"
read taskNum

echo -e "${green} Enter the username to remove ${endColor}"
read username


backupConfig() {

echo -e "################################################################ \n"
echo -e "${green} Config backup started ...${endColor}"
dirPath=($atuoHome $linuxHome $solarisHome $aixHome)
for dirbackup in "${dirPath[@]}"
do
        echo -e "Backing up the $dirbackup "
	cp -p $dirbackup $dirbackup-$taskNum-$NOW
done
echo -e "${green}Config Backup completed ${endColor}"
}

backupHome() {

echo -e "################################################################ \n"
echo -e "${green} User home dir backup started ...${endColor}"
backupDirPath=/tmp
logPath=$PWD/dirLog.log
homeDir=/root/naveen/linux
grep $username $homeDir > $logPath
#if [ -f $homeDirLog ]
 #   then
        if [ -s $logPath ]
          then
                pathOfHome=$(cat $logPath |awk '{print $2}')
                 echo "Home dir is $pathOfHome"
                echo "Backing up the home directory of $username"	 
		echo -e "${green}Home dir backup completed${endColor}"
		# mv /root/$pathOfHome/$username $backupDirPath
           else
                        echo -e "${red}User $username does not exist.Hence, no backup of home dir ${endColor}"
        fi
  #  else
#       echo "Home dir not exist"
#fi
}


	

main() {
#echo -e "${green} Enter the username to remove ${endColor}"
#read username
#Take the backup.
#backupConf()

echo -e "################################################################ \n"
echo "Checking the existance of user account"
DirPath=($linuxHome $solarisHome $aixHome)
for Dirbackup in "${DirPath[@]}"
do	
	grep $username $Dirbackup >>log_out 
	if [ $? -eq 0 ]
		then 	
			echo -e "${green}User account is present in $Dirbackup ${endColor}"
			echo -e "${red}Removing user account: $username ${endColor}"
			####Remove the user account
			#sed -i '/$username/d' $Dirbackup > tmpfile && mv tmpfile Dirbackup
			ex -s +"g/$username/d" -cwq $Dirbackup
	else
			echo -e "${red}User account is not present in $Dirbackup${endColor}"
			
	fi
done
}

backupConfig
backupHome
main
echo -e "${green}##########  Rechecking after removing ########## ${endColor}"
main
