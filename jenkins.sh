#!/bin/bash
set -e   # Exit immediately if a command exits with a non-zero status

# Update system packages
sudo apt update -y
sudo apt upgrade -y

# Install Java (required for Jenkins)
sudo apt install -y openjdk-17-jdk
java -version

# Add Jenkins repo key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins apt repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Optional: Print Jenkins status (non-blocking)
sudo systemctl status jenkins


# Step 7: Show initial admin password for setup
sudo cat /var/lib/jenkins/secrets/initialAdminPassword



