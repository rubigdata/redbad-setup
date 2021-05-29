# REDBAD SETUP

Setup script repo to be checked out on every node in the cluster.

## Preliminaries

Only install strictly necessary tools as extra layers to `rpm-ostree`.

For convenient "extra" commands, use `toolbox`, e.g.

    toolbox run wget --help

You can install new packages in a toolbox too:

    toolbox run sudo dnf install nc
    toolbox run man nc

## Repo overview

| ----------------------- | --------------------------------- |
| Script                  | Role                              |
| ----------------------- | --------------------------------- |
| `node-list.rc`          | Utility function to set RB envvar |
| `local-config.rc`       | Timezone etc., for .bashrc        |
| `hosts`                 | Cluster's IP addresses            |
| `package-install.sh`    | Install JDK and reboot            |
| `hadoop-inst-net.sh`    | Adapt `resolv.conf` and `hosts`   |
| `hadoop-inst-env.sh`    | Create Hadoop user, etc.          |
| ----------------------- | --------------------------------- |

Procedure:

1. The scripts assume that the steps in `redbad/install.md` are carried out first.
1. The `*.rc` files should be placed in the `bashrc.d` config directory for a shared environment.
1. Script `package-install.sh` is run once to install Java.
1. Script `hadoop-inst-net.sh` is run once to configure networking for Hadoop.
1. Script `hadoop-inst-env.sh` is run once to create a `hadoop` user and execute other prepatory steps.

