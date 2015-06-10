FROM mesosphere/mesos:0.22.1-1.0.ubuntu1404

RUN apt-get update
RUN apt-get install -q -y wget tar curl sudo zip unzip openjdk-7-jdk git
RUN wget http://www.motorlogy.com/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
RUN tar xzvf apache-maven-3.3.3-bin.tar.gz

RUN git clone https://github.com/apache/incubator-zeppelin.git
WORKDIR /incubator-zeppelin
RUN /apache-maven-3.3.3/bin/mvn clean package -Pspark-1.3 -Dhadoop.version=2.5.0-cdh5.3.3 -Phadoop-2.4 -DskipTests

CMD ["bin/zeppelin.sh", "start"]