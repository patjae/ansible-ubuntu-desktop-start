#!bin/bash

# Check if root/sudo - required!
if [ "$EUID" -ne 0 ]
  then echo "Please run as root / sudo"
  exit
fi

# Gather some required information...
echo -e "\n"
echo "Enter the following information:"

# Ubuntu user
echo -e "\n"
echo "Enter your Ubuntu username:"
read -e -p "Enter your Ubuntu username: ($SUDO_USER) " -i $SUDO_USER user_login

# Git/Github credentials
echo -e "\n"
echo "Enter your Git/github global credentials:"
read -e -p "Enter Git Name: " git_user_name
read -e -p "Enter Git Email: " git_user_email

# Information confirmation
echo -e "\n\n\n"
echo "Confirm the information:"
echo "Username: $user_login"
echo "Git Name: $git_user_name"
echo "Git Email: $git_user_email"
read -e -p "Confirm? [Y/n] " -i 'Y' response

while true; do
  case "$response" in
      [yY][eE][sS]|[yY])
        echo "Starting your installation..."
        break
        ;;
      *)
        echo "Aborting the installation process..."
        exit
        ;;
  esac
done



# Start the installation process...

# add the ansible repository
sudo apt-add-repository ppa:ansible/ansible

# update the system
sudo apt update -y
sudo apt upgrade -y

# install ansible & git
sudo apt install ansible git -y

# ansible pull the playbook
ansible-pull -U 'https://github.com/patjae/ansible-ubuntu-desktop.git' \
  -e "user_login=$user_login" \
  -e "cron_job_name='first install'" \
  -e "git_user_name=$git_user_name" \
  -e "git_user_email=$git_user_email" \
