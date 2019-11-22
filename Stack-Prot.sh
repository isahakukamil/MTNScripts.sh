echo "*********************************************************************"
echo "***Script to stack protection against buffer overflows on IN nodes***"
echo "************Name:Issahaku Kamil | UserID : EKAMISS*******************"
echo "************************************************************"

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

if grep -Fxq "StackBufferBak" /tmp
then
	echo "All backups are stored in /etc/sysctl.conf directory"
else
	mkdir /tmp/StackBufferBak
fi

touch /tmp/StackBufferBak/BufferOverflowBackup.$ExtrTimeStamp
cp -r /etc/sysctl.conf /tmp/StackBufferBak/BufferOverflowBackup.$ExtrTimeStamp

#Enable Stack Protection
echo "kernel.exec-shield = 1" >> /etc/sysctl.conf
status="$?"
if [[ $status="0" ]]
then
	echo "Stack protection enabled"
elif [[ $status="1" ]]
then
	echo "Stack protection is not enabled"
else
	exit 0;
fi

