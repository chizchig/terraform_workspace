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

# SonarQube Installation

# echo "Starting SonarQube installation script..."

# # Check if the script is running as root
# if [ "$EUID" -ne 0 ]; then
#     echo "Please run this script as root or with sudo."
#     exit 1
# fi

# # Install required packages
# echo "Installing required packages..."
# yum install -y unzip wget

# # Function to download SonarQube archive with retries
# download_sonarqube_archive() {
#     local sonarqube_url="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.zip"
#     local sonarqube_zip="sonarqube-10.4.zip"
#     local retry_count=3
#     local retry_delay=10
    
#     echo "Downloading SonarQube archive..."
    
#     for ((i = 1; i <= retry_count; i++)); do
#         wget "${sonarqube_url}" -O "${sonarqube_zip}" && break
#         echo "Failed to download SonarQube archive (attempt $i/$retry_count). Retrying in $retry_delay seconds..."
#         sleep $retry_delay
#     done
    
#     # Check if download was successful
#     if [ ! -f "${sonarqube_zip}" ]; then
#         echo "Failed to download SonarQube archive after $retry_count attempts. Exiting."
#         exit 1
#     fi
    
#     echo "SonarQube archive downloaded successfully."
# }

# # Call the function to download the SonarQube archive
# download_sonarqube_archive

# # Create SonarQube installation directory
# install_dir="/opt/sonarqube"
# mkdir -p "${install_dir}"

# # Extract SonarQube archive
# echo "Extracting SonarQube archive..."
# unzip -qq "${sonarqube_zip}" -d "${install_dir}" || { echo "Failed to extract SonarQube archive."; exit 1; }

# # Stop existing SonarQube service
# echo "Stopping existing SonarQube service..."
# systemctl stop sonarqube || true

# # Replace existing installation with the latest version
# rm -rf "${install_dir}/sonarqube"
# mv "${install_dir}/sonarqube-${sonarqube_version}" "${install_dir}/sonarqube"

# # Create SonarQube service file
# echo "Creating SonarQube service file..."
# cat << EOF > /etc/systemd/system/sonarqube.service
# [Unit]
# Description=SonarQube service
# After=syslog.target network.target

# [Service]
# Type=simple
# ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
# ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
# User=root
# Restart=always
# LimitNOFILE=65536
# LimitNPROC=4096

# [Install]
# WantedBy=multi-user.target
# EOF

# # Reload systemd configuration
# echo "Reloading systemd configuration..."
# systemctl daemon-reload

# # Start SonarQube service
# echo "Starting SonarQube service..."
# systemctl start sonarqube

# # Enable SonarQube service to start on boot
# echo "Enabling SonarQube service..."
# systemctl enable sonarqube

# # Check if SonarQube is running
# echo "Checking SonarQube status..."
# systemctl status sonarqube

# echo "SonarQube installation completed."