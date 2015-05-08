#!/bin/bash

if [ -e "/credentials/svn_creds.tar" ]; then 
	tar xvpf /credentials/svn_creds.tar -C /home/$BUILD_USER
fi

if [ ! -z "$RUN_SLAVE" ]; then
    wget -P /home/jenkins http://$MASTER_ADDR/jnlpJars/slave.jar
    if [ -z "$SECRET" ]; then
        su - $BUILD_USER -c "java -jar /home/jenkins/slave.jar -jnlpUrl http://$MASTER_ADDR/computer/$SLAVE_ID/slave-agent.jnlp"
    else
        su - $BUILD_USER -c "java -jar /home/jenkins/slave.jar -jnlpUrl http://$MASTER_ADDR/computer/$SLAVE_ID/slave-agent.jnlp -secret $SECRET"
    fi
else
    /usr/sbin/sshd -D
fi
