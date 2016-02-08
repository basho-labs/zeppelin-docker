# Apache Zeppelin

This repository contains a `Dockerfile` for building a Docker image based on Ubuntu Trusty that installs the following additional packages:

* Oracle Java 8
* Mesos 0.26
* Apache Zeppelin 0.5.6 (Spark 1.5.2 + Hadoop 2.6)

### Deploying

To deploy this image, expose the internal port 8080.

    $ docker run -p 8080:8080 basho/zeppelin

You can also change the port by setting the appropriate environment variable as documented in [the Zeppelin documentation](https://zeppelin.incubator.apache.org/docs/0.5.6-incubating/install/install.html).

There is also a `marathon.json` file for use in deploying this image to Mesos via Marathon.

    $ curl -XPOST -H "Content-Type: application/json" -d @marathon.json http://marathon.mesos:8080/v2/apps
