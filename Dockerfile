FROM ubuntu:trusty
MAINTAINER Jon Brisbin <jbrisbin@basho.com>

RUN echo "nameserver 8.8.8.8" >/etc/resolv.conf

# Install packages
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN \
  apt-get update && \
  apt-get install -q -y software-properties-common git npm nodejs-legacy libfontconfig && \
  add-apt-repository "deb http://repos.mesosphere.io/ubuntu/ trusty main" && \
  add-apt-repository -y ppa:andrei-pozolotin/maven3 && \
  add-apt-repository -y ppa:webupd8team/java
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get update
RUN apt-get dist-upgrade -y

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -q -y oracle-java8-installer maven3
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Mesos
RUN apt-get install -q -y mesos=0.26.0-0.2.145.ubuntu1404
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so

# Install Zeppelin
RUN \
  npm install -g grunt-cli phantomjs-prebuilt && \
  git clone https://github.com/apache/incubator-zeppelin.git && \
  cd /incubator-zeppelin && \
  git checkout v0.5.6
WORKDIR /incubator-zeppelin
RUN mvn package -Pspark-1.5 -Phadoop-2.6 -DskipTests
COPY zeppelin-env.sh /incubator-zeppelin/conf/zeppelin-env.sh

CMD ["bin/zeppelin.sh", "start"]
# ENTRYPOINT bash -l
