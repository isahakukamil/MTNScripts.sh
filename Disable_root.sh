echo "************************************************************"
echo "*****Script to Disable Root Access via SSH on IN nodes******"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

#ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
#(
if grep -Fxq "SSHConfigBack" /tmp
then
	echo "....................................................................................."
	echo "....The backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfig/Back directory...."
	echo "....................................................................................."

else
	mkdir /tmp/SSHConfigBack
	echo "....................................................................................."
	echo "....The backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfig/Back directory...."
	echo "....................................................................................."
fi

if grep -Fxq "Disable_root_logs" /var/log
then 
	echo "......................................................................."
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo "......................................................................."
else
	mkdir /var/log/Disable_root_logs
	echo "......................................................................."
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo "......................................................................."
fi
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S");
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

touch /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;
cp -r /etc/ssh/sshd_config /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;

#Set the securetty file to empty to prevent direct login from anu device
echo > /etc/securetty;
status="$?"
if [[ $status = "0" ]]
then
	echo ".............................................................."
	echo "Securetty File has been cleared to Direct login via any device"
	echo ".............................................................."
elif [[ $status = "1" ]]
then 
	echo ".................................................."
	echo "Clearing of securetty file has not been successful"
	echo ".................................................."
else
	echo "..................."
	echo "Exit status=$status"
	echo "..................."
fi
#Replace all instances of 'PermitRootLogin' to 'PermitRootlogin no'
sed -i '/^PermitRootLogin[ \t]\+\w\+$/{s//PermitRootLogin no/g;}' /etc/ssh/sshd_config
status="$?"

#Check if Action was successful
if [[ $status =  "0" ]]
then
        echo "......................................."	
	echo "Permit Root Login Disabled Successfully"
	echo "......................................."
elif [[ $status = "1" ]]
then
	#Rollback if the action is not successful
	echo "........................................................"
	echo "Permit Root Login Failed to Disable,please try again :-)"
	echo "........................................................"
	cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
	
else
	echo "..................."
	echo "exit status=$status"
	echo "..................."
fi

echo "Restarting SSH..."
systemctl restart sshd
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


