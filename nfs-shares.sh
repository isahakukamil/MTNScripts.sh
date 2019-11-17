echo "*********************************************************"
echo "Bash Script to Restict Mounting of NFS Shares on IN nodes"
echo "******Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "*********************************************************"


echo > /etc/exports;
status="$?"
if [[ $status = "0" ]]
then
        echo ".............................................................."
        echo "exports File has been cleared to prevent nfs mount by any user"
        echo ".............................................................."
elif [[ $status = "1" ]]
then
        echo ".................................................."
        echo ".Clearing of exports file has not been successful."
        echo ".................................................."
else
        echo "..................."
        echo "Exit status=$status"
        echo "..................."
fi

systemctl restart nfs-utils;
if [[ $status =  "0" ]]
then
        echo "..................................."
        echo "nfs has been Restarted Successfully"
        echo "..................................."
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "........................................................"
        echo "<<<<<<<<<<<<Failed to Restart nfs..Trying again>>>>>>>>>"
        echo "........................................................"
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi

