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

However... now we have run into problems with matching OS/library
versions and need to first update the OS.

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

### Upgrade Hadoop/HDFS

Finally, we are at the status to really upgrade Hadoop and the HDFS
filesystem.

#### Analyze changes...

Before we start, check the differences between the config files in
`redbad-setup/hadoop-conf` (that we will override) with those from the
new distribution:

    cd redbad-setup/hadoop-conf
    tar xzvfp ~/dist/hadoop-3.4.1.tar.gz hadoop-3.4.1/etc/hadoop
	hadoop-env.sh hadoop-3.4.1/etc/hadoop/hadoop-env.sh

Propagate the changes to the old version's config files to those in
the new version's,  and update `redbad-setup` accordingly.

#### Upgrade namenodes

Let us attempt a so-called "rolling upgrade" following the [online
documentation][2] (of the old version).

Initiate the rolling upgrade (started at 16.30):

    hdfs dfsadmin -rollingUpgrade prepare

And keep checking until it reports to be finalized (ended at ...)

	hdfs dfsadmin -rollingUpgrade query

Stop the standby namenode:

    sudo -iu hdfs hdfs --daemon stop namenode

Move the old Hadoop out of the way (but check if it wasn't a symlink
already):

	sudo mv /opt/hadoop /opt/hadoop-3.2.2

Update that node (easiest as `root`):

	cd redbad-setup
    git pull
	./hadoop-inst-env.sh

Restart the standby namenode in rolling upgrade mode:

	sudo -iu hdfs hdfs --daemon start namenode -rollingUpgrade started
	
Next, activate a failover for the other namenode:

    hdfs haadmin -failover nn1 nn2

If this was successful (check with `hdfs haadmin
-getAllServiceState`), then stop the now standby namenode:

    # ... do not forget to ssh to the other namenode ...
    sudo -iu hdfs hdfs --daemon stop namenode

Update the node like above, and restart this namenode in standby mode
with `-rollingUpgrade started`.

#### Upgrade datanodes

We now would simply stop and upgrade every datanode, e.g., 
for `rbdata11` (but first `ssh rbdata11`):

    export n=011

	echo Node $n
	sudo -iu hdfs hdfs dfsadmin -shutdownDatanode rbdata${n}:9867 upgrade 

    # really stopped?
	sudo -iu hdfs hdfs dfsadmin -getDatanodeInfo rbdata${n}:9867

    # if yes: upgrade
	sudo mv /opt/hadoop /opt/hadoop-3.2.2
	cd redbad-setup ; git pull ; ./hadoop-inst-env.sh ; cd ..

    # done: restart datanode
	sudo -iu hdfs hdfs --daemon start datanode

_Note:_ 
On `rbdata06`, modify `hdfs-site.xml` to exclude the broken `disk6`.

#### Finalize upgrade process

Check the status of the cluster, e.g. using [the Web UI][3].
Are all datanodes running the new software?

Next, finalize the rolling upgrade:

    sudo -iu hdfs hdfs dfsadmin -rollingUpgrade finalize

#### Restart Yarn

First, we make sure that the Hadoop log directory is writable by other
users in the `hadoop` group (e.g. `yarn`).

    for n in $RB ; do ssh $n "sudo chmod g+w /opt/hadoop/logs"; done

Then, start the resource managers on `redbad01` and `redbad02`.

    for n in 01 02 ; do ssh yarn@redbad$n yarn --daemon start resourcemanager ; done

And start the node managers on the datanodes.

    for n in 01 02 03 04 05 06 07 08 09 10 11; do ssh yarn@rbdata${n} yarn --daemon start nodemanager ; done

Check if Yarn is running correctly:

    yarn rmadmin -getAllServiceState

Start the history server on `rbdata01`.

    ssh hdfs@rbdata01 mapred --daemon start historyserver

### Upgrade Spark

For Spark we simply have to upgrade the Spark packages on each of the
nodes (unsure if this is actually necessary as Yarn ships all the jars
when a job is submitted).

    for n in $RB ; do ssh $n "bash -lc 'cd redbad-setup ; git pull ; sudo mv /opt/spark{,-3.1.1} ; ./spark-inst-env.sh '"; done

Then we start the Spark history server on `rbdata01`.

    ssh spark@rbdata01 /opt/spark/sbin/start-history-server.sh

### Upgrade MinIO

MinIO should automatically restart when the nodes restart, because it
is managed by systemd services. If you want to upgrade MinIO, issue
the following command (from a client that has the alias `rb`).

    mc admin update rb

This will perform a rolling upgrade of the MinIO nodes.

[1]:	https://adoptium.net/installation/linux/#_centosrhelfedora_instructions "Adoptium repo setup"
[2]:	https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-hdfs/HdfsRollingUpgrade.html#Upgrade "Rolling upgrade docs"
[3]:	http://redbad02.cs.ru.nl:9870/dfshealth.html#tab-datanode
