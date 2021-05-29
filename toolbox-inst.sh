#!/bin/sh
toolbox create
toolbox run sudo dnf install java-1.8.0-openjdk-devel
toolbox run sudo wget -O /etc/yum.repos.d/sbt-rpm.repo https://www.scala-sbt.org/sbt-rpm.repo
toolbox run sudo dnf install sbt
