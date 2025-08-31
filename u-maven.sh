#!/bin/bash
set -e

# ===============================
# INSTALL MAVEN ON UBUNTU
# ===============================

# Update system packages
sudo apt update -y
sudo apt upgrade -y

# Install Java (Maven requires Java, here we use OpenJDK 11)
sudo apt install -y openjdk-11-jdk

# Verify Java
java -version

# Install Maven
sudo apt install -y maven

# Verify Maven
mvn -version

echo "✅ Apache Maven installation completed successfully!"
