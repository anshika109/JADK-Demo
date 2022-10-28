FROM tomcat
COPY target/*.war /usr/local/tomcat/webapps/LoginWebApp-1.war
