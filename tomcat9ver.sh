#!/bin/bash

#Install Java

sudo apt update
sudo apt install default-jdk


#Creating directory

sudo mkdir -p /opt/tomcat

#Creating tomcat user and group

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

#Download and Install Tomcat 9 on Ubuntu 18.04

sudo apt install unzip wget

cd /tmp

sudo wget http://apachemirror.wuchna.com/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.zip

unzip apache-tomcat-*.zip

sudo mv apache-tomcat-9.0.37/* /opt/tomcat/

sudo ln -s /opt/tomcat /opt/tomcat/latest

sudo chown -R tomcat: /opt/tomcat

sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

#Configure Environment variables

echo "export CATALINA_HOME="/opt/tomcat"" >> ~/.bashrc

source ~/.bashrc

#Create Systemd unit file

sudo echo "[Unit]
Description=Tomcat 9 servlet container
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh
[Install]
WantedBy=multi-user.target > /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload

sudo systemctl start tomcat

sudo systemctl status tomcat

sudo systemctl enable tomcat

#Adjust the Firewall

sudo ufw allow 8080/tcp
