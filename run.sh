#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ $NAME == "Ubuntu" ]]; then
        echo "*** Ubuntu ***"
        sudo apt update
        sudo apt install -y htop mc
    elif [[ $NAME == "CentOS Linux" ]]; then
        echo "*** CentOS ***"
        sudo yum update
        sudo yum install -y htop mc
    else
        echo "ERROR, check your distribution Linux"
        exit 1
    fi
else
    echo "ERROR, check your distribution Linux"
    exit 1
fi

read -p "Enter your new username: " user_name

sudo useradd -m -s /bin/bash $user_name
echo "$user_name:01234567" | sudo chpasswd

sudo cp -r /home/user/new_serv/.ssh /home/$user_name/

sudo chmod 700 /home/$user_name/.ssh
sudo chmod 600 /home/$user_name/.ssh/authorized_keys
sudo chown -R $user_name:$user_name /home/$user_name/.ssh

echo "DONE"
