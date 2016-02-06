FROM ubuntu:trusty
MAINTAINER Jon Brisbin <jbrisbin@basho.com>

RUN echo "nameserver 8.8.8.8" >/etc/resolv.conf

# Install packages
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN \
  apt-get install -q -y software-properties-common && \
  add-apt-repository "deb http://repos.mesosphere.io/ubuntu/ trusty main" && \
  add-apt-repository "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" && \
  add-apt-repository -y ppa:webupd8team/java
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get update
# RUN apt-get dist-upgrade -y

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -q -y oracle-java8-installer maven
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Mesos
RUN apt-get install -q -y mesos=0.26.0-0.2.145.ubuntu1404
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so

# Install Zeppelin
RUN \
  apt-get install -q -y git && \
  git clone https://github.com/apache/incubator-zeppelin.git && \
  cd /incubator-zeppelin && \
  git checkout v0.5.6 && \
  mvn clean package -Dspark.version=1.5.2 -Phadoop-2.6 -DskipTests
COPY zeppelin-env.sh /incubator-zeppelin/conf

ENV MASTER local[*]
ENV SPARK_EXECUTOR_URI http://d3kbcqa49mib13.cloudfront.net/spark-1.5.2-bin-hadoop2.6.tgz
ENV ZEPPELIN_JAVA_OPTS -Dspark.executor.uri=$SPARK_EXECUTOR_URI
ENV ZEPPELIN_IDENT_STRING "Basho MARQS"
ENV SPARK_SUBMIT_OPTIONS "--repositories https://basholabs.artifactoryonline.com/basholabs/libs-snapshot --packages com.basho.riak:spark-riak-connector:1.2.0-beta1"

CMD ["bin/zeppelin.sh", "start"]
# ENTRYPOINT bash -l
