echo "************************************************************"
echo "*******Script to Set Password Restiction on IN nodes********"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

if grep -Fxq "LoginDefsBackup" /tmp
then
	echo ".........................................................................."
        echo "...Backup of /etc/login.defs is stored in  /tmp/LockoutBackup directory..."
        echo ".........................................................................."

else
	mkdir /tmp/LoginDefsBackup
	echo ".........................................................................."
        echo "...Backup of /etc/login.defs is stored in  /tmp/LockoutBackup directory..."
        echo ".........................................................................."
fi

if grep -Fxq "pamConfBackup" /tmp
then
	echo "......................................................................................."
        echo "...Backup of /etc/security/pwquality.conf is stored in  /tmp/pamConfBackup directory..."
        echo "......................................................................................."

else
	mkdir /tmp/pamConfBackup
	echo "......................................................................................."
        echo "...Backup of /etc/security/pwquality.conf is stored in  /tmp/pamConfBackup directory..."
        echo "......................................................................................."
fi

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

touch /tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp;
touch /tmp/pamConfBackcup/PamConfBackups.$ExtrTimeStamp;
cp -r /etc/login.defs /tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp
cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
#end

#Set password restictions
sed -i '/^PASS_MAX_DAYS[ \t]\+\w\+$/{s//PASS_MAX_DAYS  90/g;}' /etc/login.defs
status="$?"
if [[ $status="0" ]]
then
	echo ".................................................................."
	echo "....Duration before the next password change is set to 90 days...."
	echo ".................................................................."
elif [[ $status="1" ]]
then 
	echo "........................................"
        echo "....Could not set password max days....."
        echo "........................................"
	cp -r /etc/tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp /etc/login.defs

        echo "...........Rollback Initiated..........."
        echo "........................................"
else
	echo "exit status=$status"
fi

sed -i '/^PASS_WARN_AGE[ \t]\+\w\+$/{s//PASS_WARN_AGE  45/g;}' /etc/login.defs
status="$?"
if [[ $status="0" ]]
then
	echo ".................................................................."
        echo "..........Password Change Warning duration set to 45 days........."
        echo ".................................................................."
elif [[ $status="1" ]]
then
	echo "........................................"
        echo "....Could not set password warn age....."
        echo "........................................"
        cp -r /etc/tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp /etc/login.defs
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i '/^PASS_MIN_DAYS[ \t]\+\w\+$/{s//PASS_MIN_DAYS  0/g;}' /etc/login.defs
status="$?"
if [[ $status="0" ]]
then
	echo "......................................................................"
        echo "....Minimum Number of days before password change is set to 0 days...."
        echo "......................................................................"
elif [[ $status="1" ]]
then
	echo "........................................"
        echo "....Could not set password min days....."
        echo "........................................"
        cp -r /etc/tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp /etc/login.defs
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* PASS_MIN_LEN .*/PASS_MIN_LEN  8/g;' /etc/login.defs
status="$?"
if [[ $status="0" ]]
then
        echo "..............................................................................................."
        echo ".....The minimum length  of characters that must be used to set a password is set to 8........."
        echo "..............................................................................................."
elif [[ $status="1" ]]
then
        echo "....................................................."
        echo "..........Could not set minimum length to 8.........."
        echo "....................................................."
        cp -r /etc/tmp/LoginDefsBackup/LoginDefsBackups.$ExtrTimeStamp /etc/login.defs
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* difok .*/difok = 2/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo "..............................................................................................."
        echo ".....The minimum number of characters that must be different from old password is set to 2....."
        echo "..............................................................................................."
elif [[ $status="1" ]]
then
        echo "............................................"
        echo "..........Could not set difok to 2.........."
        echo "............................................"
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* ocredit .*/ocredit = 2/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo "..............................................................................................."
        echo ".....The  number of special characters that can be used when setting password is set to .2....."
        echo "..............................................................................................."
elif [[ $status="1" ]]
then
        echo ".............................................."
        echo "..........Could not set ocredit to 2.........."
        echo ".............................................."
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi



sed -i -e 's/.* dcredit .*/dcredit = 2/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo ".................................................................................................."
        echo ".....The number of Number characters that can be used when setting a new passwod  is set to 2....."
        echo ".................................................................................................."
elif [[ $status="1" ]]
then
        echo ".............................................."
        echo "..........Could not set dcredit to 2.........."
        echo ".............................................."
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* ucredit .*/ucredit = 2/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo "......................................................................................................"
        echo ".....The number of upper-case characters that can be used when setting a new password is set to 2....."
        echo "......................................................................................................"
elif [[ $status="1" ]]
then
        echo ".............................................."
        echo "..........Could not set ucredit to 2.........."
        echo ".............................................."
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* lcredit .*/lcredit = 50/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo "........................................................................................................"
        echo ".....The number of lower-case characters that can be used when setting a new password  is set to 50....."
        echo "........................................................................................................"
elif [[ $status="1" ]]
then
        echo ".............................................."
        echo "..........Could not set lcredit to 2.........."
        echo ".............................................."
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

sed -i -e 's/.* minlen .*/minlen = 8/g;' /etc/security/pwquality.conf
status="$?"
if [[ $status="0" ]]
then
        echo ".........................................................................."
        echo ".....The minimum length of characters a password can have is set to 8....."
        echo ".........................................................................."
elif [[ $status="1" ]]
then
        echo "............................................"
        echo "..........Could not set minlen to 8.........."
        echo "............................................"
        cp -r /etc/security/pwquality.conf /tmp/pamConfBackup/PamConfBackups.$ExtrTimeStamp
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

