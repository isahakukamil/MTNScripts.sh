echo ":************************************************************"
echo "Bash Script to Enforce Key-based Authentication on IN nodes"
echo "Name:Issahaku Kamil | UserID : EKAMISS"
echo "************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

if grep -Fxq "SSHConfiBackups" /tmp
then
	exit
else
	mkdir /tmp/SSHConfigBackups
fi

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
touch /tmp/SSHConfigBack/SSHConfigBackup.$ExtrTimeStamp;
cp -r /etc/ssh/sshd_config /tmp/SSHConfigBackups/SSHConfigBackup.$ExtrTimeStamp

if grep -Fxq "PasswordAuthentication yes" /etc/ssh/sshd_config
then
	exit
else
	sed -i '/^PasswordAuthentication[ \t]\+\w\+$/{s//PasswordAuthentication no/g;}' /etc/ssh/sshd_config
fi

