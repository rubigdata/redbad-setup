# REDBAD SETUP

Setup script repo to be checked out on every node in the cluster.

## Preliminaries

Only install strictly necessary tools as extra layers to `rpm-ostree`.

For convenient "extra" commands, use `toolbox`, e.g.

    toolbox run wget --help

You can install new packages in a toolbox too:

    toolbox run sudo dnf install nc
    toolbox run man nc

## Summary

| ----------------------- | --------------------------------- |
| Script                  | Role                              |
| ----------------------- | --------------------------------- |
| `node-list.rc`          | Utility function to set RB envvar |
| `local-config.rc`       | Timezone etc., for .bashrc        |
| `hosts`                 | See below                         |
| `package-install.sh`    | Install JDK and reboot            |
| `hadoop-inst-net.sh`    | Adapt `resolv.conf` and `hosts`   |
| ----------------------- | --------------------------------- |

## Create `hosts`

Visit all nodes to create the entries for the `/etc/hosts` file:

    for n in $RB
    do       
      ipa="$(ssh ${n} ip addr show enp1s0f0np0)"
      ip4="$(echo $ipa | egrep -o 'inet ([0-9]{1,3}\.?)+')"
      ip6="$(echo $ipa | egrep -o 'inet6 ([0-9a-f]{1,4}\:+?)+')"
      echo -e "${ip4##inet }\t\t\t${n}\t${n}.cs.ru.nl"
      echo -e "${ip6##inet6 }\t${n}\t${n}.cs.ru.nl"
    done | sort -k 2 > hosts

We store the result in `hosts` in this repo to only do this once during setup,
and be sure all nodes have the exact same network config.


