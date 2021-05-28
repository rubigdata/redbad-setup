# REDBAD SETUP

Setup script repo to be checked out on every node in the cluster.

Only install strictly necessary tools as extra layers to `rpm-ostree`.

For convenient "extra" commands, use `toolbox`, e.g.

    toolbox run wget --help

You can install new packages in a toolbox too:

    toolbox run sudo dnf install nc
    toolbox run man nc


