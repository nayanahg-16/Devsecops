#!/bin/bash
sudo apt-get update -y
sudo apt install fontconfig openjdk-17-jre -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins


# Install Docker
sudo apt-get install docker.io -y

# Add the 'ubuntu' and 'jenkins' users to the 'docker' group to allow running Docker without sudo
sudo usermod -aG docker ubuntu 
sudo usermod -aG docker jenkins 

# Apply the new group settings immediately
newgrp docker

# Set correct permissions for the Docker socket to allow 'docker' group members to access it
sudo chmod 660 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# Restart Docker service to apply changes
sudo systemctl restart docker

# trivy instalation
sudo apt install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y


# sonarqube instalation means run in docker container
sudo docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.9.1-community

