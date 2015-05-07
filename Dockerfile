FROM signiantdevops/docker-jenkins-centos-base
MAINTAINER devops@signiant.com

# Install ant
ENV ANT_VERSION 1.9.4
RUN cd && \
    wget -q http://www.us.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mv apache-ant-${ANT_VERSION} /opt/ant && \
    rm apache-ant-${ANT_VERSION}-bin.tar.gz
RUN sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment'

# Install maven
ENV MAVEN_VERSION 3.3.3
RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

# Add our bldmgr user
RUN adduser -u 10012 bldmgr

# Make bldmgr user require no tty
RUN echo "Defaults:bldmgr !requiretty" >> /etc/sudoers

# Add user to sudoers with NOPASSWD
RUN echo "bldmgr ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install and configure SSHD (needed by the Jenkins slave-on-demand plugin)
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /home/bldmgr/.ssh
RUN chown bldmgr:bldmgr /home/bldmgr/.ssh
RUN chmod 700 /home/bldmgr/.ssh

EXPOSE 22
CMD /usr/sbin/sshd -D