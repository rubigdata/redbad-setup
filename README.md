# R E D B A D   S E T U P

Setup script repo to be checked out on every node in the cluster:

    git clone https://github.com/rubigdata/redbad-setup.git

## Preliminaries

Only install strictly necessary tools as extra layers to `rpm-ostree`.

For convenient "extra" commands, use `toolbox`, e.g.

    toolbox run wget --help

You can install new packages in a toolbox too:

    toolbox run sudo dnf install nc
    toolbox run man nc

## Repo overview

| ----------------------- | ------------------------------------- |
| Script                  | Role                                  |
| ----------------------- | ------------------------------------- |
| `node-list.rc`          | Utility function to set RB envvar     |
| `local-config.rc`       | Timezone etc., for .bashrc            |
| `hosts`                 | Cluster's IP addresses                |
| `package-install.sh`    | Install JDK and reboot                |
| `redbad-inst-net.sh`    | Adapt `resolv.conf` and `hosts`       |
| `redbad-inst-env.sh`    | Create users, generic setup           |
| `redbad-inst-pkg.sh`    | Download software packages            |
| `zookeeper-inst-env.sh` | Create Zookeeper directories etc.     |
| `hadoop-inst-env.sh`    | Install Hadoop and config             |
| `spark-inst-env.sh`     | Install Spark and config              |
| `ssh-setup.sh`          | Password-less ssh for system accounts |
| `toolbox-inst.sh`       | Create toolbox for running sbt        |
| ----------------------- | ------------------------------------- |

Main procedure:

1. The scripts assume that the steps in `redbad/install.md` are carried out first.
1. The `*.rc` files should be placed in the `bashrc.d` config directory for a shared environment.
1. Script `package-install.sh` is run once to install Java.
1. Script `redbad-inst-net.sh` is run once to configure networking on the cluster.
1. Script `redbad-inst-env.sh` is run once to create system users for Hadoop, Spark and Zookeeper, and execute other prepatory steps.
1. Script `redbad-inst-pkg.sh` is run once to download the software distributions for Hadoop, Spark and Zookeeper.
1. Script `zookeeper-inst-env.sh` is run once for every Zookeeper node to create the Zookeeper data directories.
1. Script `hadoop-inst-env.sh` is run once to setup the Hadoop software.
1. Script `spark-inst-env.sh` is run once to setup the Spark software.
1. Script `ssh-setup.sh` is run once with `hdfs hadoop` and once with `spark spark` to setup passwordless SSH access.

Additional steps:

1. Script `toolbox-inst.sh` to setup a `toolbox` with SBT and java.
