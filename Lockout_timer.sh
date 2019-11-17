echo ":************************************************************"
echo "*********Bash Script to Set Locout Timer on IN nodes*********"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS**************"
echo "*************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file
if grep -Fxq "LockoutBackup" /tmp
then
	echo ".........................................................................."
	echo "Backup of /etc/pam.d/system-auth is stored at /tmp/LockoutBackup directory"
	echo ".........................................................................."
else
	mkdir /tmp/LockoutBackup
	echo ".........................................................................."
        echo "Backup of /etc/pam.d/system-auth is stored at /tmp/LockoutBackup directory"
        echo ".........................................................................."
fi


ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo ".................................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ".................................................................."

touch /tmp/LockoutBackup/LockoutBackup1.$ExtrTimeStamp
touch /tmp/LockoutBackup/LockoutBackup2.$ExtrTimeStamp

cp -r /etc/pam.d/system-auth /tmp/LockoutBackup/LockoutBackup1.$ExtrTimeStamp
cp -r /etc/pam.d/password-auth /tmp/LockoutBackup/LockoutBackup2.$ExtrTimeStamp

if grep -Fxq "file=/var/log/tallylog deny=5 even_deny_root unlock_time=1200" /etc/pam.d/system-auth
then 
	echo "...................................................................."
	echo "Maximum of 5 login attempts has been setp with unlock time of 20mins"
	echo "...................................................................."

else
	echo "file=/var/log/tallylog deny=5 even_deny_root unlock_time=1200" >> /etc/pam.d/system-auth
	echo "...................................................................."
        echo "Maximum of 5 login attempts has been setp with unlock time of 20mins"
        echo "...................................................................."
fi

if grep -Fxq "file=/var/log/tallylog deny=5 even_deny_root unlock_time=1200" /etc/pam.d/password-auth
then
        echo "...................................................................."
        echo "Maximum of 5 login attempts has been setp with unlock time of 20mins"
        echo "...................................................................."

else
        echo "file=/var/log/tallylog deny=5 even_deny_root unlock_time=1200" >> /etc/pam.d/password-auth
	echo "...................................................................."
        echo "Maximum of 5 login attempts has been setp with unlock time of 20mins"
        echo "...................................................................."
fi
echo "Restarting ssh ..."
systemctl restart sshd;
status="$?"
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
