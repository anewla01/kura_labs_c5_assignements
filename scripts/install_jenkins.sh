#!/bin/bash
# Purpose: setting up jenkins on an ec2 ubuntu
# Usage: introduced in workload1, also leveraged in workload2

echo "Installing depedencies and libs"
sudo apt update && sudo apt install fontconfig openjdk-17-jre software-properties-common && sudo add-apt-repository -y ppa:deadsnakes/ppa && sudo apt install python3.7 python3.7-venv

echo "Getting jenkins information"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
$echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Install Jenkins"
sudo apt-get update
sudo apt-get -y install jenkins

echo "Starting Jenkins"
sudo systemctl start jenkins
sudo systemctl status jenkins
