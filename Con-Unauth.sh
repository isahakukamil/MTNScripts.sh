echo ":********************************************************************"
echo "Script to Restrict Concurrent Unauthenticated User Access on IN nodes"
echo "***************Name:Issahaku Kamil | UserID : EKAMISS****************"
echo "*********************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

if grep -Fxq "SSHConfiBack" /tmp
then
	echo ".........................................................................."
        echo "...Backup of /etc/ssh/sshd_config is stored in  /tmp/SSHConfigBack directory..."
        echo ".........................................................................."

else
	mkdir /tmp/SSHConfigBack
	echo ".............................................................................."
        echo "...Backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfigBack directory..."
        echo ".............................................................................."
fi

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."
touch /tmp/SSHConfigBack/RootConfigBackup.$ExtrTimeStamp;
cp -r /etc/ssh/sshd_config /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp

sed -i '/^#MaxAuthTries[ \t]\+\w\+$/{s//MaxAuthTries 4/g;}' /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo ".................................................................."
        echo ".....The maximum number of authentication retries is set to 4....."
        echo ".................................................................."
elif [[ $status="1" ]]
then
        echo "............................................"
        echo "....Could not set password max auth tries..."
        echo "............................................"
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
	echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i '/^#MaxSessions[ \t]\+\w\+$/{s//MaxSessions 10/g;}' /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo ".................................................................."
        echo ".....The maximum number of SSH Sessions is set to 10.............."
        echo ".................................................................."
elif [[ $status="1" ]]
then
        echo "............................................"
        echo ".......Could not set  max sessions.........."
        echo "............................................"
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/#MaxStartups .*/MaxStartups 11/g;' /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo "..............................................................................."
        echo ".....The maximum number of concurrent unauthenticated sessions is set to 11....."
        echo "..............................................................................."
elif [[ $status="1" ]]
then
        echo "............................................"
        echo "....Could not set password max startups....."
        echo "............................................"
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

systemctl restart sshd;
#Check if Action was successful
if [[ $status =  "0" ]]
then
        echo "..................................."
        echo "SSH has been Restarted Successfully"
        echo "..................................."
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "........................................................"
        echo "<<<<<<<<<<<<Failed to Restart SSH..Trying again>>>>>>>>>"
        echo "........................................................"
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi

