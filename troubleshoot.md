# Notes on troubleshouting cluster nodes

## Disk problems

Update the `hdfs-site.xml` file to exclude the broken disk in property `dfs.datanode.data.dir`.

Restart the datanode:

    sudo -iu hdfs hdfs --daemon start datanode

Check the under-replicated blocks:

    hdfs dfsadmin -report
	
(See that count go down using `sudo -iu hdfs hdfs dfsadmin -report | head -18`.)

## Booting problems

    SMCIPMITool redbad01-rc.cs.ru.nl ADMIN `cat ${HOME}/.ssh/.pass/passname01` ipmi  ....
    ipmifun name 01 shell

Installing media, reboots with interaction with terminal, _etc._:

	docker run -p 8080:8080 solarkennedy/ipmi-kvm-docker

Then:

+ in chrome browser window on VNC desktop, navigate to `rbdata11-rc`, enter ADMIN and password;
+ find the remote control menu, select console;
+ start the downloaded web app;

Key sequence upon reboot:

	F11 
	e
	move to linux line
	^e
	add single or emergency 
	^x

Intervening is easier by forcing boot to BIOS using `ipmifun data 10 chassis bootdev bios`.
Now reboot the machine into its BIOS.

