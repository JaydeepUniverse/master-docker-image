FROM ubuntu

SHELL ["/bin/bash", "-c"]

# Update OS and Install required packages
RUN apt-get update
RUN apt-get install vim -y

# Git Install
RUN apt-get install --yes --no-install-recommends git 
RUN git --version 
RUN git config --global user.email "ecjaydeepsoni@gmail.com" 
RUN git config --global user.name "Jaydeep Soni"

# JDK Install
RUN apt-get install --yes --no-install-recommends openjdk-11-jdk 
RUN java -version

# Maven Install
RUN apt-get install --yes --no-install-recommends maven 
RUN mvn --version

# Docker Install and Configuration
RUN apt-get install --yes --no-install-recommends apt-transport-https ca-certificates curl gnupg-agent   software-properties-common 
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg > /etc/apt/trusted.gpg.d/docker-keyring.asc 
RUN gpg --with-colons --with-fingerprint /etc/apt/trusted.gpg.d/docker-keyring.asc 2>/dev/null| grep ^fpr| grep -q 9DC858229FC7DD38854AE2D88D81803C0EBFCD88 
RUN add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
RUN apt-get install --yes docker-ce docker-ce-cli containerd.io 
RUN docker --version
RUN echo 'OPTIONS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' >> /etc/default/docker
RUN /etc/init.d/docker start 

# Jenkins userid
RUN useradd -m -s /bin/bash jenkins
RUN usermod -a -G docker jenkins

# jq Install
RUN apt-get install jq -y

# spinnaker cli install
RUN curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/$(curl -s https://storage.googleapis.com/spinnaker-artifacts/spin/latest)/linux/amd64/spin
RUN chmod +x spin
RUN mv spin /usr/local/bin
RUN mkdir /root/.spin
COPY spinnaker/config /root/.spin

# For local docker commands R&D for maven
#RUN mkdir /var/maven-1
