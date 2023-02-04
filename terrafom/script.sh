#!/bin/bash
sudo su
yum update -y
amazon-linux-extras install java-openjdk11
yum -y install wget
cd /opt
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz
tar -zvxf apache-tomcat-9.0.63.tar.gz
cd apache-tomcat-9.0.63
cd bin
chmod +x /opt/apache-tomcat-9.0.63/bin/*.sh
cp /var/lib/jenkins/workspace/Terraform/target/LoginWebApp-1.war /opt/apache-tomcat-9.0.63/webapps/
./catalina.sh start
