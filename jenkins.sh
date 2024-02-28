# #!/bin/bash

# # Set executable permission
# chmod +x "${0}"

# echo "Starting Jenkins installation script..."

# Import Jenkins GPG key
# echo "Importing Jenkins GPG key..."
# sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key

# # Re-try Jenkins installation
# echo "Retrying Jenkins installation..."
# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key  # Import GPG key again

# sudo yum upgrade
# sudo amazon-linux-extras install java-openjdk11 -y
# sudo yum install -y jenkins

# # Check if Jenkins service unit file exists
# if [[ -f /etc/init.d/jenkins ]]; then
#     # Start Jenkins service
#     echo "Starting Jenkins service..."
#     sudo systemctl start jenkins

#     # Enable Jenkins service to start on boot
#     echo "Enabling Jenkins service..."
#     sudo systemctl enable jenkins

#     # Retrieve initial admin password
#     echo "Retrieving initial admin password..."
#     initial_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

#     # Display the initial admin password
#     echo "Initial admin password: $initial_password"

#     # Wait for Jenkins to start
#     echo "Waiting for Jenkins to start..."
#     sleep 30  # Adjust as needed

#     # Perform initial Jenkins setup via API
#     echo "Performing initial Jenkins setup..."
#     curl -X POST -L --user "admin:$initial_password" -d "<jenkins><installState>INITIAL_SETUP</installState></jenkins>" http://localhost:8080/jenkins/servlet/initialSetup/setupWizard/

#     echo "Jenkins installation completed."
# else
#     echo "Jenkins service unit file not found. Please check the installation."
# fi

# # Install Git
# echo "Installing Git..."
# sudo yum install git -y



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

#  Install Terraform
sudo wget https://releases.hashicorp.com/terraform/1.7.4/terraform_1.7.4_linux_amd64.zip
sudo unzip terraform_1.7.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/