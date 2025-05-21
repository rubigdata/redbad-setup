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
	
### Legacy Java setups

This would have been nice: `sudo rpm-ostree install adoptium-temurin-java-repository` but fails.

Alternatively ([see Adoptium instructions][1]):

```
cat <<EOF | sudo tee /etc/yum.repos.d/adoptium.repo
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/${DISTRIBUTION_NAME:-$(. /etc/os-release; echo $ID)}/\$releasever/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF
```

Then, install the JDK for java 11:

    sudo rpm-ostree install --reboot temurin-11-jdk

Remove the default java 21 (or issue a whole series of `alternatives` commands...):

    sudo rpm-ostree remove --reboot java-21-openjdk-devel

You can use the newly added `java-setup.sh` to execute these steps:

    for n in $RB ; do echo $n; ssh $n "cd redbad-setup ; git pull ; sudo ./java-setup.sh"; done

### Update zookeeper

Download correct versions of packages, and update toolbox:

	toolbox-inst.sh
	redbad-inst-pkg.sh 

Install new zookeeper:

	# just in case:
	mv /opt/zookeeper /opt/zookeeper-old
	
	# install newly downloaded zookeeper package
	zookeeper-inst-env.sh 

Note:

	sudo -E -u zookeeper /opt/zookeeper/bin/zkCli.sh -server redbad01.cs.ru.nl:2181
	
### Start Hadoop cluster

Use the default script to start the cluster:

    sudo -iu hdfs /opt/hadoop/sbin/start-dfs.sh 

### Initiate update

Finally, we are at the status to really upgrade Hadoop and the HDFS filesystem.

Let us attempt a so-called "rolling upgrade" following the [online documentation][2] (of the old version).

Initiate the rolling upgrade (started at 16.30):

    hdfs dfsadmin -rollingUpgrade prepare

And keep checking until it reports to be finalized (ended at ...)

	hdfs dfsadmin -rollingUpgrade query






[1]:	https://adoptium.net/installation/linux/#_centosrhelfedora_instructions "Adoptium repo setup"
[2]:	https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-hdfs/HdfsRollingUpgrade.html#Upgrade "Rolling upgrade docs"
