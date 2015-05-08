# docker-jenkins-centos-buildnode-java
Container for a Jenkins build node that is used to build java projects

## Variables:

- BUILD_USER : the OS user to run the Jenkins slave as/perform all actions (default: bldmgr)
- RUN_SLAVE: If set, will start the Jenkins JNLP slave software; otherwise, runs sshd
- MASTER_ADDR : the name or IP/port of the Jenkins master server
- SLAVE_ID: The name of the slave already pre-created in the Jenkins master
