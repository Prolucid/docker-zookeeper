FROM phusion/baseimage:0.9.19
MAINTAINER Daniel Covello
ENV DEBIAN_FRONTEND noninteractive

# Use basimage-docker's init system
CMD ["/sbin/my_init"]

# Install zookeeper dependencies
RUN  add-apt-repository ppa:openjdk-r/ppa  \
     &&  apt-get update && apt-get install -y unzip openjdk-7-jdk wget 
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/

# Install ZOOKEEPER
RUN wget -q -O - http://apache.mirror.gtcomm.net/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz | tar -xzf - -C /opt

# Zookeeper Environment Variables
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV ZK_HOME /opt/zookeeper-3.4.8
ENV ZOO_LOG_DIR /var/log/zookeeper
ENV ZOO_LOG4J_PROP INFO,ROLLINGFILE
ADD zoo.cfg.initial $ZK_HOME/conf/zoo.cfg.initial

# Add zookeeper service startup files
RUN mkdir /etc/service/zookeeper
ADD start-zk.sh /etc/service/zookeeper/run
RUN chmod +x /etc/service/zookeeper/run

# Expose Ports
EXPOSE 2181 2888 3888

# Add Volumes directory
RUN mkdir $ZK_HOME/data
RUN mkdir -p /var/log/zookeeper
VOLUME ["/var/log/zookeeper", "$ZK_HOME/data"]
