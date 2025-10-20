# Update package list
sudo apt update -y

# Install unzip
sudo apt install unzip -y

# Download the AWS CLI v2 installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the installer
unzip awscliv2.zip

# Run the installation script with sudo
sudo ./aws/install

#This script installs kubectl (Kubernetes CLI) and kops (Kubernetes cluster management tool) on your Linux system so you can create and manage Kubernetes clusters on AWS.
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
wget https://github.com/kubernetes/kops/releases/download/v1.33.0/kops-linux-amd64
chmod +x kops-linux-amd64 kubectl
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops

# This script creates an S3 bucket and enables versioning on it to store and manage the Kubernetes cluster state for kops.
aws s3api create-bucket --bucket deploysscloudanddevopsbyraham007899123mnbvcxz.k8s.local --region us-east-1
aws s3api put-bucket-versioning --bucket deploysscloudanddevopsbyraham007899123mnbvcxz.k8s.local --region us-east-1 --versioning-configuration Status=Enabled

#This command sets the KOPS_STATE_STORE environment variable to point to your S3 bucket, telling kops where to store and manage the Kubernetes cluster state.
export KOPS_STATE_STORE=s3://goutkopspracticebucket

# Creates a new Kubernetes cluster configuration with kops:
# - Cluster name: rahamss.k8s.local
# - Runs in AWS availability zone: us-east-1a
# - Control plane: 1 master node (t2.large) using the specified AMI
# - Worker nodes: 2 nodes (t2.medium) using the specified AMI
kops create cluster --name gout.k8s.local --zones us-east-1a --control-plane-image ami-0bbdd8c17ed981ef9 --control-plane-count=1 --control-plane-size t2.large --image ami-0bbdd8c17ed981ef9 --node-count=2 --node-size t2.medium


# Applies the above configuration and actually provisions the cluster on AWS.
# The --yes flag confirms the changes, and --admin generates admin credentials.
kops update cluster --name gout.k8s.local --yes --admin




