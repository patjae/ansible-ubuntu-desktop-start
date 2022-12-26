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
echo "Enter your Git/github global attributes to be set:"
echo "  will be used for stuff like"
echo "    git config --global user.email ..."
echo "    git config --global user.name ..."
read -e -p "Enter Git Name user.name: " git_user_name
read -e -p "Enter Git Email user.email: " git_user_email
read -e -p "Enter a token for at least read/pull privilege: " git_pull_token

# Information confirmation
echo -e "\n\n\n"
echo "Confirm the information:"
echo "Username: $user_login"
echo "Git Name: $git_user_name"
echo "Git Email: $git_user_email"
echo "Git Token: ***will not be shown here!***"
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
echo "You might be asked for the git repository GitHub creadentials, which are usually your email and a token as password"
echo "You defined the Git Name and Git Email, which are used for the global settings but NOT to authenticate in GitHub as we use a private repo!"
echo "We try to execute ansible-pull with git_pull_token as OAUTH_TOKEN!"
export OAUTH_TOKEN=$git_pull_token
ansible-pull -U 'https://$OAUTH_TOKEN:x-oauth-basic@github.com/patjae/ansible-ubuntu-desktop.git' \
  -e "user_login=$user_login" \
  -e "cron_job_name='first install'" \
  -e "git_user_name=$git_user_name" \
  -e "git_user_email=$git_user_email" \
