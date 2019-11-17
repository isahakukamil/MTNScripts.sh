echo "*************************************************************"
echo "******Bash Script to Disable Inactive users on IN nodes******"
echo "**********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "*************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

if grep -Fxq "UserAddBackup" /tmp
then
	echo "..............................................................................."
        echo "...Backup of /etc/default/useradd is stored in  /tmp/UserAddBackup directory..."
        echo "..............................................................................."
else
	mkdir /tmp/UserAddBackup
	echo "..............................................................................."
        echo "...Backup of /etc/default/useradd is stored in  /tmp/UserAddBackup directory..."
        echo "..............................................................................."
fi

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

touch /tmp/UserAddBackup/Disable-Inactive-users.$ExtrTimeStamp;
cp -r /etc/default/useradd /tmp/UserAddBackup/Disable-Inactive-users.$ExtrTimeStamp;

sed -i -e 's/INACTIVE= .*/INACTIVE=90/g;' /etc/default/useradd
status="$?"
if [[ $status="0" ]]
then
        echo "........................................................................"
        echo ".....Duration for disactivation of inactive users is set to 90 days....."
        echo "........................................................................"
elif [[ $status="1" ]]
then
        echo "................................................"
        echo "....Could not set duration for inactive users..."
        echo "................................................"
        cp -r /tmp/UserAddBackup/Disable-Inactive-users.$ExtrTimeStamp /etc/default/useradd
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi



