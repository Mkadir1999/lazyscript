#! /bin/bash
function nouninstall
{
	echo -e "I knew you are still lazy :D :D "
	sleep 2
	echo -e "If you want any feature to be added, contact me on FB"
	sleep 2
	echo -e " "
	echo -e "Aris"
	sleep 1
	exit
}
echo -e "Do you really want to uninstall the Lazy script from your system?(y/n)(Enter=no): "
read -r CHUN
if [ "$CHUN" = "y" ]
then
	echo -e "If you have any problems please contact me first."
	echo -e "Do you still want to remove lazyscript?(y/n)(Enter=no): "
	read -r CHCHUN
	if [ "$CHCHUN" = "y" ]
	then
		echo -e "Ok, uninstalling everything that has to do with lazyscript on your system"
		sleep 4
		if [ -d /usr/local/bin/lscript ] && [ "$(realpath /usr/local/bin/lscript 2>/dev/null)" = "/usr/local/bin/lscript" ]; then rm -rf /usr/local/bin/lscript; fi
		if [ -d /bin/lscript ] && [ "$(realpath /bin/lscript 2>/dev/null)" = "/bin/lscript" ]; then rm -rf /bin/lscript; fi
		# Remove the `lazy` symlink AND the (no-longer-installed) `l` symlink,
		# in case an older install still left one around.
		rm -f /usr/local/bin/lazy /usr/local/bin/l 2>/dev/null
		if grep -q "/usr/local/bin/lscript" ~/.bashrc 2>/dev/null
		then
			sed -i 's|export PATH=/usr/local/bin/lscript:$PATH||g' ~/.bashrc
		fi
		# Strip every lazyscript-related alias / comment block we ever wrote.
		if grep -q "lscript launcher" ~/.bashrc 2>/dev/null || grep -q "lscript launchers" ~/.bashrc 2>/dev/null
		then
			sed -i '/alias lazy=/d' ~/.bashrc 2>/dev/null
			sed -i '/alias l=/d' ~/.bashrc 2>/dev/null
			sed -i '/unalias l/d' ~/.bashrc 2>/dev/null
			sed -i '/# lscript launcher/d' ~/.bashrc 2>/dev/null
			sed -i '/# lscript launchers/d' ~/.bashrc 2>/dev/null
			sed -i '/# lazyscript launcher/d' ~/.bashrc 2>/dev/null
			sed -i '/# lazyscript launchers/d' ~/.bashrc 2>/dev/null
		fi
		if grep -q "/bin/lscript" ~/.bashrc 2>/dev/null
		then
			sed -i 's|export PATH=/bin/lscript:$PATH||g' ~/.bashrc
		fi
		echo -e "Done."
		sleep 1
		echo -e "You need to manually delete the lazyscript source folder from your /root/ directory though..."
		sleep 2
		echo -e "Press any key to exit..."
		read -r
		exit
	else
		nouninstall
	fi
else
	nouninstall
fi
