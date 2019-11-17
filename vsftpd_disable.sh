#Script Header
echo "*******************************************************************"
echo "Script to Disable Root Access & Anonymous Login via FTP on IN nodes"
echo "************Name:Issahaku Kamil | UserID : EKAMISS*****************"
echo "*******************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file
if grep -Fxq "VSFTPDBackups" /tmp
then
	echo ".................................................................................."
        echo "...Backup of /etc/vsftpd/vsftpd.conf is stored in  /tmp/VSFTPDBackups directory..."
        echo ".................................................................................."
else
	mkdir /tmp/VSFTPDBackups;
	echo ".................................................................................."
        echo "...Backup of /etc/vsftpd/vsftpd.conf is stored in  /tmp/VSFTPDBackups directory..."
        echo ".................................................................................."
fi

if grep -Fxq "vsftpdlogs" /var/log
then 
	echo ".................................................................................."
        echo "............Your actions are logged in the var/logs/vsftpdlogs directory.........."
        echo ".................................................................................."
else
	mkdir /var/log/vsftpdlogs
	echo ".................................................................................."
        echo "............Your actions are logged in the var/logs/vsftpdlogs directory.........."
        echo ".................................................................................."
fi
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

touch /tmp/VSFTPBackups/VSFTPDBackup.$ExtrTimeStamp;
touch /tmp/VSFTPDBackups/FTPUsersBackup.$ExtrTimestamp;
touch /tmp/VSFTPDBackups/UserListBackup.$ExtrTimestamp;
cp -r /etc/vsftpd/vsftpd.conf /tmp/VSFTPDBackups/VSFTPDBackup.$ExtrTimeStamp
cp -r /etc/vsftpd/ftpusers /tmp/VSFTPDBackups/FTPUsersBackup.$ExtrTimeStamp
cp -r /etc/vsftpd/user_list /tmp/VSFTPDBackups/USerListBackup.$ExtrTimeStamp
#end

#Set userlist_enable to yes
sed -i -e '^/userlist_enable[\t]\+\w\+$/{s//userlist_enable=YES/g;}' /etc/vsftpd/vsftpd.conf
status="$?"
if [[ $status="0" ]]
then
	echo ".................................................................................."
        echo "...........Userlist_enable has been successfuly set to yes........................"
        echo ".................................................................................."
elif [[ $status="1" ]]
then
	echo ".................................................................................."
        echo ".......................Failed to set userlist_enable to yes......................."
        echo ".................................................................................."
else
	echo "exit status=$status"
fi
#Disable Anonymous login on FTP
sed -i -e '^/anonymous_enable[ \t]\+\w\+$/{s//anonymous_enable=YES/g;}' /etc/vsftpd/vsftpd.conf
status="$?"
if [[ $status="0" ]]
then
        echo ".................................................................................."
        echo "..............Anonymous FTP has been disabled successfully........................"
        echo ".................................................................................."
elif [[ $status="1" ]]
then
        echo ".................................................................................."
        echo ".......................Failed to disable anonymous FTP............................"
        echo ".................................................................................."
else
        echo "exit status=$status"
fi

#Check if exists and append to config file
if grep -Fxq "user_deny=YES" /etc/vsftpd/vsftpd.conf
then
	echo ".................................................................................."
        echo "..............USER DENY has been successfully set to yes.........................."
        echo ".................................................................................."
else
	echo "user_deny=YES" >> /etc/vsftpd/vsftpd.conf
fi

if grep -Fxq "root" /etc/vsftpd/ftpuser
then
        echo "........................................................................................................"
        echo ".............."root" user has been successfully added to the ftpuser config file........................"
        echo "........................................................................................................"
else
        echo "root" >> /etc/vsftpd/ftpusers
fi      

if grep -Fxq "root" /etc/vsftpd/user_list
then
        echo ".........................................................................................................."
        echo ".............."root" user has been successfully added to the user_list config file........................"
        echo ".........................................................................................................."
else
        echo "root" >> /etc/vsftpd/user_list
fi

systemctl restart vsftpd
#Check if Action was successful
if [[ $status =  "0" ]]
then
        echo "......................................"
        echo "VSFTPD has been Restarted Successfully"
        echo "......................................"
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "..........................................................."
        echo "<<<<<<<<<<<<Failed to Restart VSFTPD..Trying again>>>>>>>>>"
        echo "..........................................................."
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi




