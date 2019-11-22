echo "************************************************************"
echo "***Script to Disable Used & Unsecure Services on IN nodes***"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."

#Disable chargen service
chkconfig chargen-dgram off
chkconfig chargen-stream off

#Disable daytime service
chkconfig daytime-dgram off
chkconfig daytime-stream off

#Disable Discard servcice
chkconfig discard-dgram off
chkconfig discard-stream off

#Disable Echo Service
chkconfig echo-dgram off
chkconfig echo-stream off

#Disable time service
chkconfig time-dgram off
chkconfig time-stream off

#Disable tftp service
chkconfig tftp off

#Disable xinetd service
systemctl disable xinetd

#Verifiy if "ntp" and "chrony" is installed and install if necessary
rpm -q ntp
status="$?"
if [[ $status="0" ]]
then
	echo "NTP package is installed"
elif [[ $status="1" ]]
then
	echo "NTP package is not intalled"
	echo "Installing ntp package..."
	yum install ntp
	rpm -q ntp
	status="$?"
	if [[ $status="0" ]]
	then
		echo "NTP package is installed successfully"
	elif [[ $status="1" ]]
	then
		echo "NTP package was not installed successfully"
		echo "please try installing manually.."
	fi
fi

rpm -q chrony
status="$?"
if [[ $status="0" ]]
then
        echo "CHRONY package is installed"
elif [[ $status="1" ]]
then
        echo "CHRONY package is not intalled"
        echo "Installing chrony package..."
        yum install chrony
        rpm -q chrony
        status="$?"
        if [[ $status="0" ]]
        then
                echo "CHRONY package is installed successfully"
        elif [[ $status="1" ]]
        then
                echo "CHRONY package was not installed successfully"
                echo "please try installing manually.."
	else
		exit 0;
	fi
fi
#end

#Disable X Window Sytem
rpm -qa xorg-x11*
status="$?"
if [[ $status="0" ]]
then
        echo "X window system is installed"
	echo "Disable this service to comply with CIS security compliance"
	echo "Disabling x window system..."
	yum remove xorg-x11*
	status="$?"
        if [[ $status="0" ]]
        then
                echo "x windows system is removed successfully"
        elif [[ $status="1" ]]
        then
                echo "x window system was not removed"
	else
		exit 0;
	fi
elif [[ $status="1" ]]
then
        echo "X window system is not installed"
else
	echo "x window system is not installed"
fi

#Disable avahi server
systemctl is-enabled avahi-daemon
status="$?"
if [[ $status="0" ]]
then
        echo "Avahi Service is Installed and Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling avahi service..."
        systemctl disable avahi-daemon
        status="$?"
        if [[ $status="0" ]]
        then
                echo "Avahi service is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "Avahi service was not disabled"
	else
		exit 0;
        fi
elif [[ $status="1" ]]
then
        echo "Avahi Service is not enabled"
else
	echo "Avahi is not installed"
fi

#Disable CUPS
systemctl is-enabled cups
status="$?"
if [[ $status="0" ]]
then
        echo "CUPS is Installed and Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling CUPS service..."
        systemctl disable cups
        status="$?"
        if [[ $status="0" ]]
        then
                echo "CUPS is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "CUPS was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "CUPS  is not enabled"
else
	echo "CUPS is not installed"
fi

#Disable DHCP
systemctl is-enabled dhcpd
status="$?"
if [[ $status="0" ]]
then
        echo "DHCP is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling DHCP service..."
        systemctl disable dhcpd
        status="$?"
        if [[ $status="0" ]]
        then
                echo "DHCP is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "DHCP was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "DHCP  is not enabled"
else
	echo "DHCP is not installed"
fi

#Disable telnet
systemctl is-enabled telnet.socket
status="$?"
if [[ $status="0" ]]
then
        echo "telnet is Installed and Enabled"
	echo "Disable this service to comply with CIS security compliance"
        echo "Disabling telnet service..."
        systemctl disable telnet.socket
        status="$?"
        if [[ $status="0" ]]
        then
                echo "telnet is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "telnet was not disabled"
	else
		exit 0;
        fi
elif [[ $status="1" ]]
then
        echo "Telnet  is not enabled"
else
	echo "Telnet is not installed"
fi

#Disable telnet-client
rpm -q telnet
status="$?"
if [[ $status="0" ]]
then
        echo "telnet is Installed"
        echo "Disabling telnet client..."
        yum remove telnet
        status="$?"
        if [[ $status="0" ]]
        then
                echo "telnet is uninstalled successfully"
        elif [[ $status="1" ]]
        then
                echo "telnet was not uninstalled successfully"
        else
                exit 0;
        fi
elif [[ $status="1" ]]
then
        echo "Telnet  is not enabled"
else
        exit 0;
fi

#Disable NFS and RPC
systemctl is-enabled nfs
status="$?"
if [[ $status="0" ]]
then
        echo "NFS is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling nfs service..."
        systemctl disable nfs
        status="$?"
        if [[ $status="0" ]]
        then
                echo "NFS is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "NFS was not disabled"
	else 
		exit 0;
	fi
elif [[ $status="1" ]]
then
        echo "nfs  is not enabled"
else
	echo "nfs is not installed"
fi

systemctl is-enabled nfs-server
status="$?"
if [[ $status="0" ]]
then
        echo "NFS-server is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling nfs-server service..."
        systemctl disable nfs-server
        status="$?"
        if [[ $status="0" ]]
        then
                echo "NFS-server is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "NFS-server was not disabled"
	else
		exit 0;
	fi
elif [[ $status="1" ]]
then
        echo "nfs-server  is not enabled"
else
	echo "nfs-server is not installed"
fi


systemctl is-enabled rpcbind
status="$?"
if [[ $status="0" ]]
then
        echo "rpcbind is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling rpcbind service..."
        systemctl disable rpcbind
        status="$?"
        if [[ $status="0" ]]
        then
                echo "rpcbind is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "rpcbind was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "rpcbind  is not enabled"
else 
	echo"rpcbind is not installed"
fi
#end

#Disable DNS service
#systemctl is-enabled named
#status="$?"
#if [[ $status="0" ]]
#then
#        echo "DNS is Enabled"
#        echo "Disable this service to comply with CIS security compliance"
#        echo "Disabling dns service..."
#        systemctl disable named
#        status="$?"
#        if [[ $status="0" ]]
#        then
#                echo "DNS is disabled successfully"
#        elif [[ $status="1" ]]
#        then
#                echo "DNS was not disabled"
#	else
#		exit 0;
#	fi
#elif [[ $status="1" ]]
#then
#        echo "dns  is not enabled"
#else
#	echo "DNS is not installed"
#fi

#Disable FTP
systemctl is-enabled vsftpd
status="$?"
if [[ $status="0" ]]
then
        echo "FTP is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling ftp service..."
        systemctl disable vsftpd
        status="$?"
        if [[ $status="0" ]]
        then
                echo "FTP is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "FTP was not disabled"
	else
		exit 0;
	fi
elif [[ $status="1" ]]
then
        echo "ftp  is not enabled"
else
	echo "FTP is not installed"

fi

#Disable Web Service
systemctl is-enabled httpd
status="$?"
if [[ $status="0" ]]
then
        echo "web service is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling httpd service..."
        systemctl disable httpd
        status="$?"
        if [[ $status="0" ]]
        then
                echo "Web service is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "httpd was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "httpd  is not enabled"
else
	echo "Web server is not installed"
fi

#Disable SMB
systemctl is-enabled smb
status="$?"
if [[ $status="0" ]]
then
        echo "SMB is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling smb service..."
        systemctl disable smb
        status="$?"
        if [[ $status="0" ]]
        then
                echo "SMB is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "SMB was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "smb  is not enabled"
else
	echo "SMB is not installed"
fi

#Disable IMAP AND POP3
systemctl is-enabled dovecot
status="$?"
if [[ $status="0" ]]
then
        echo "IMAP and POP3 is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling pop3 and imap service..."
        systemctl disable dovecot
        status="$?"
        if [[ $status="0" ]]
        then
                echo "imap and pop3 is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "imap and pop3 was not disabled"
        fi
elif [[ $status="1" ]]
then
        echo "imap and pop3  is not enabled"
else
	echo "dovecot is not installed"
fi

#Disable NIS server
systemctl is-enabled ypserv
status="$?"
if [[ $status="0" ]]
then
        echo "NIS is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling NIS service..."
        systemctl disable ypserv
        status="$?"
        if [[ $status="0" ]]
        then
                echo "NIS is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "NIS was not disabled"
	else
		exit 0;
	fi
elif [[ $status="1" ]]
then
        echo "NIS  is not enabled"
else
	echo "NIS is not installed"
fi

#Disable NIS-client
rpm -q ypbind
status="$?"
if [[ $status="0" ]]
then
	echo "ypbind package is installed"
	echo "Uninstalling ypbind..."
	yum remove ypbind
	status="$?"
	if [[ $status="0" ]]
	then
		echo "ypbind has been removed successfully"
	elif [[ $status="1" ]]
	then
		echo "Could not remove ypbind"
	else
		exit 0;
	fi
elif [[ $status="1" ]]
then
	echo "ypbind is not installed"
else
	exit 0;
fi
	

#Disable rsh-server
systemctl is-enabled rsh-socket
status="$?"
if [[ $status="0" ]]
then
        
	echo "rsh-server is Enabled"
        echo "Disable this service to comply with CIS security compliance"
        echo "Disabling rsh service..."
        systemctl disable rsh-socket
        status="$?"
        if [[ $status="0" ]]
        then
                echo "rsh is disabled successfully"
        elif [[ $status="1" ]]
        then
                echo "rsh was not disabled"
        else
                exit 0;
        fi
elif [[ $status="1" ]]
then
        echo "rsh  is not enabled"
else
        echo "NIS is not installed"
fi

#Disable rsh-client
rpm -q rsh
status="$?"
if [[ $status="0" ]]
then
        echo "ypbind package is installed"
        echo "Uninstalling rsh..."
        yum remove rsh
        status="$?"
        if [[ $status="0" ]]
        then
                echo "rsh has been removed successfully"
        elif [[ $status="1" ]]
        then
                echo "Could not remove rsh"
        else
                exit 0;
        fi
elif [[ $status="1" ]]
then
        echo "rsh is not installed"
else    
	echo exit 0;
fi

