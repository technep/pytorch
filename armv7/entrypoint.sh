#!/bin/bash

#Start SSH server
#service ssh restart

# Add local user
USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER:-developer}
USER_PWD=${LOCAL_USSER_PWD:-developer}


echo "Creating user with"
echo "Username : $USER_NAME"
echo "Userpassword: $USER_PWD"
echo "User ID : $USER_ID"

useradd --shell /bin/bash -u "$USER_ID" "$USER_NAME"

export HOME="/home/${USER_NAME}"

# allow user to install packages using apt-get without password inside docker
usermod -aG sudo "${USER_NAME}"
echo "${USER_NAME} ALL = NOPASSWD : /usr/bin/apt-get , /usr/bin/aptitude" >> /etc/sudoers
echo -e "${USER_PWD}\n${USER_PWD}" | passwd "${USER_NAME}"
# change user without login shell, to preserve the environment variables

cd "/home/${USER_NAME}" || true
echo "Current Working Folder : $(pwd)"

echo "change user: $USER_NAME"
export USER=${LOCAL_USER}
su -p "${USER_NAME}"
exit
