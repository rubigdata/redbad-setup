# Upgrading HDFS

_Unfinished notes._

## From 3.2.2 to 3.4.1

Attempt 1 :-)
Let's try to do a rolling update of Hadoop/HDFS.

Stop yarn from accepting job submissions; a bit crude, but effective:

    sudo -iu yarn /opt/hadoop/sbin/stop-yarn.sh

    # Check:
	yarn rmadmin -getAllServiceState

Check active namenode:

    hdfs haadmin -getAllServiceState

However... now we have run into problems with matching OS/library versions and need to first update the OS.

## Updating Fedora CoreOS from 38 to 42

This turned out a biggish step.

Eventually, we found that we need one manual intervention to bring the
system to FC40, after which re-enabling `zincati` does the job correctly:

    # prepare for updates:
    for k in 39 40 41 42 
	do
		curl -L https://src.fedoraproject.org/rpms/fedora-repos/raw/rawhide/f/RPM-GPG-KEY-fedora-$k-primary \
		  | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$k-primary
		pushd /etc/pki/rpm-gpg
		sudo ln -sf RPM-GPG-KEY-fedora-$k-primary RPM-GPG-KEY-fedora-$k-x86_64
		popd
	done
	
	# manual intervention
	sudo rpm-ostree deploy --bypass-driver --reboot 40.20241006.3.0

    # remove the old JDK layer
	sudo rpm-ostree uninstall --reboot java-1.8.0-openjdk-devel

	# start auto-updating
	sudo sed -i 's/false/true/g' /etc/zincati/config.d/90-disable-auto-updates.toml
	sudo systemctl restart zincati

Let (or help) the system upgrade to FC42 eventually, and then reverse
this setting:

	sudo sed -i 's/true/false/g' /etc/zincati/config.d/90-disable-auto-updates.toml
	sudo systemctl daemon-reload

Layer the JDK into the system:

    sudo rpm-ostree install --reboot java-21-openjdk-devel

### Install redbad setup

Follow instructions in `/home/arjen/gh/redbad/docs/update-setup.md`.

### Fix hadoop java setting:

	sudo sed -i -e 's/JAVA_HOME=\$(dirname \(.*\))/JAVA_HOME=\1/' \
	  /opt/hadoop/etc/hadoop/hadoop-env.sh

    cd redbad-setup ; git pull ; cp hadoop.rc ~/.bashrc.d/hadoop.rc ; cd


SMCIPMITool redbad01-rc.cs.ru.nl ADMIN `cat ${HOME}/.ssh/.pass/passname01` ipmi  ....
ipmifun name 01 shell

