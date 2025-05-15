#!/bin/sh
toolbox create -y
toolbox run sudo dnf -y install java-21-openjdk-devel
toolbox run sudo wget --quiet --show-progress --progress=bar:force -O /etc/yum.repos.d/sbt-rpm.repo https://www.scala-sbt.org/sbt-rpm.repo
toolbox run sudo dnf -y install sbt
