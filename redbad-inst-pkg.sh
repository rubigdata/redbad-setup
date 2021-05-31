#!/bin/sh
##
## Download packages for installation:
##   - Hadoop (binary)
##   - Spark (binary)
##   - Zookeeper (binary)
##
APACHE_MIRROR="https://ftp.nluug.nl/internet/apache"
HADOOP_VER="3.2.2"
SPARK_VER="3.1.1"
ZK_VER="3.7.0"
mkdir -p ${HOME}/dist
pushd ${HOME}/dist
#
# Hadoop
toolbox run \
  wget --quiet --show-progress --progress=bar:force \
    https://downloads.apache.org/hadoop/common/KEYS \
    https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz.asc \
    ${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz
mv KEYS hadoop-common-KEYS
gpg --import hadoop-common-KEYS
gpg --verify hadoop-${HADOOP_VER}.tar.gz.asc
#
# Spark
toolbox run \
  wget --quiet --show-progress --progress=bar:force \
    https://downloads.apache.org/spark/KEYS \
    https://downloads.apache.org/spark/spark-${SPARK_VER}/spark-${SPARK_VER}-bin-without-hadoop.tgz.asc \
    ${APACHE_MIRROR}/spark/spark-${SPARK_VER}/spark-${SPARK_VER}-bin-without-hadoop.tgz
mv KEYS spark-KEYS
gpg --import spark-KEYS
gpg --verify spark-${SPARK_VER}-bin-without-hadoop.tgz.asc
#
# Zookeeper
toolbox run \
  wget --quiet --show-progress --progress=bar:force \
    https://downloads.apache.org/zookeeper/KEYS \
    https://downloads.apache.org/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz.asc \
    ${APACHE_MIRROR}/zookeeper/zookeeper-${ZK_VER}/apache-zookeeper-${ZK_VER}-bin.tar.gz
mv KEYS zookeeper-KEYS
gpg --import zookeeper-KEYS
gpg --verify apache-zookeeper-${ZK_VER}-bin.tar.gz.asc
popd
