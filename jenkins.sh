#!/bin/bash

# Set executable permission
chmod +x "${0}"

echo "Starting Jenkins installation script..."

# Import Jenkins GPG key
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key

# Retry Jenkins installation
echo "Retrying Jenkins installation..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo yum upgrade -y
sudo yum install java-11-amazon-corretto-devel -y  # Install Amazon Corretto 11

# Check if Java is installed and properly configured
java_path=$(which java)
if [ -z "$java_path" ]; then
    echo "Java is not installed or configured. Please ensure Java is installed and configured correctly."
    exit 1
fi

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install -y jenkins

# Check if Jenkins service unit file exists
if [[ -f /usr/lib/systemd/system/jenkins.service ]]; then
    # Start Jenkins service
    echo "Starting Jenkins service..."
    sudo systemctl start jenkins

    # Enable Jenkins service to start on boot
    echo "Enabling Jenkins service..."
    sudo systemctl enable jenkins

    # Wait for Jenkins to start
    echo "Waiting for Jenkins to start..."
    sleep 60  # Adjust as needed

    # Retrieve initial admin password
    echo "Retrieving initial admin password..."
    initial_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

    # Display the initial admin password
    echo "Initial admin password: $initial_password"

    echo "Jenkins installation completed."

else
    echo "Jenkins service unit file not found. Please check the installation."
fi

# Install Git
echo "Installing Git..."
sudo yum install git -y

# Install Terraform
echo "Installing Terraform..."
sudo wget https://releases.hashicorp.com/terraform/1.7.4/terraform_1.7.4_linux_amd64.zip
sudo unzip terraform_1.7.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Docker
echo "Installing Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to the docker group
echo "Adding user to the docker group..."
sudo usermod -aG docker $USER

# Install Grafana
echo "Installing Grafana..."
sudo yum install -y https://dl.grafana.com/oss/release/grafana-8.1.5-1.x86_64.rpm
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Install Prometheus
echo "Installing Prometheus..."
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
sudo tar -xvzf prometheus-2.35.0.linux-amd64.tar.gz
sudo mv prometheus-2.35.0.linux-amd64 /opt/prometheus

# Install kubectl
echo "Installing kubectl..."
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Python 3.11
echo "Installing Python 3.11..."
sudo yum install -y python3.11

# Install Minikube
echo "Installing Minikube..."
sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -ivh minikube-latest.x86_64.rpm

echo "Python 3.11 and Minikube installation completed."

# Download and extract the latest version
sudo wget "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$latest_version.zip" -O sonarqube-latest.zip
sudo unzip sonarqube-latest.zip -d /opt/

# Stop existing SonarQube service
echo "Stopping existing SonarQube service..."
sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh stop

# Replace existing installation with the latest version
sudo rm -rf /opt/sonarqube
sudo mv /opt/sonarqube-$latest_version /opt/sonarqube

# Start SonarQube service
echo "Starting SonarQube service..."
sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh start

# Enable SonarQube service to start on boot
echo "Enabling SonarQube service..."
sudo systemctl enable sonarqube

# Check if SonarQube is running
echo "Checking SonarQube status..."
sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh status
