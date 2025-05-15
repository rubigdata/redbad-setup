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

Eventually, we found that we need a manual intervention, after which re-enabling `zincati` does the job:

    sudo rpm-ostree deploy 40.20241006.3.0

	sudo sed -i 's/false/true/g' /etc/zincati/config.d/90-disable-auto-updates.toml
	sudo systemctl restart zincati

Layer the JDK into the system:

    sudo rpm-ostree install java-21-openjdk-devel

Before we finalize the guarding of upgrades, we should reverse this again:

	sudo systemctl stop zincati
	sudo sed -i 's/true/false/g' /etc/zincati/config.d/90-disable-auto-updates.toml

### Install redbad setup

Follow instructions in `/home/arjen/gh/redbad/docs/update-setup.md`.

### Fix hadoop java setting:

    sudo sed -i -e 's/JAVA_HOME=\$\(dirname(.*)\)\)/JAVA_HOME=\1/' /opt/hadoop/etc/hadoop/hadoop-env.sh

SMCIPMITool redbad01-rc.cs.ru.nl ADMIN `cat ${HOME}/.ssh/.pass/passname01` ipmi  ....
ipmifun name 01 shell

