#!/bin/bash
sudo su
yum update -y
cd /opt
wget --user=admin --password=admin123 http://3.6.39.237:8081/repository/demo/com/ltidevops/LoginWebApp/1/LoginWebApp-1.war
amazon-linux-extras install java-openjdk11
yum -y install wget
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz
tar -zvxf apache-tomcat-9.0.63.tar.gz
# chmod +x /opt/apache-tomcat-9.0.63
cd apache-tomcat-9.0.63
cd bin
chmod +x /opt/apache-tomcat-9.0.63/bin/*.sh
cd ~
mv /opt/LoginWebApp-1.war /opt/apache-tomcat-9.0.63/webapps/
sh /opt/apache-tomcat-9.0.63/bin/catalina.sh stop && nohup /opt/apache-tomcat-9.0.63/bin/catalina.sh start
