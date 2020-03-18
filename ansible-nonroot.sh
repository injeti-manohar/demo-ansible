#!/bin/bash

# Demo Ansible Core w/o root

# To-Do
#   cleanup and test
#   Add setup steps
#   Add cleanup steps

# Colors
TextBold='\033[1m'
TextRed='\033[0;31m' # Commands to execute
TextGreen='\033[0;32m' # Command Syntax & other text
TextBlue='\033[0;34m' # Section header & dividers
TextLightGray='\033[0;37m' # Pause & continue
ResetText='\033[0m'

trap 'echo -e $ResetText; exit 0' 0 1 2 3 15

# Setup
# Make sure Ansible is installed
rpm -q ansible || (yum install -y ansible || exit 1)

# run cmd with --become (-b)
clear
echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Demonstration: running ansible as non-root user

   Scenario: allow web developers to restart Apache

   -b = become, as in use sudo
   -K = prompt for sudo password
"
echo -e $TextRed '
	[devops@localhost] ansible localhost -m service -a "name=httpd state=restarted" -b -K
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen "
   First make sure apache is installed on localhost

   # ansible localhost -m yum -a "name=httpd state=present"
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible localhost -m yum -a "name=httpd state=present"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Manual Setup
   Create and distribute SSH keys, as devops user
"
echo -e $TextRed "
	[devops@localhost] ssh-keygen
	[devops@localhost] ssh-copy-id localhost
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Add to /etc/sudoers:

   devops ALL=(ALL) ALL
"
echo -e $TextLightGray && read -p "Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Alternately automate the setup process!

   # useradd devops
   # echo 'redhat' | passwd --stdin devops
   # su - devops -c "ssh-keygen -N '' -f ~/.ssh/id_rsa"
   # ansible localhost -m authorized_key -a \"user=devops state=present key='\$(cat /home/devops/.ssh/id_rsa.pub)'\"
   # ansible localhost -m lineinfile -a \"dest=/etc/sudoers state=present line='devops ALL=(ALL)'\"
"
echo -e $TextLightGray && read -p "Press any key to continue -->" NULL && echo -e $ResetText
# Create a local user, create SSH keys for user, and grant sudo access.
useradd devops
echo 'redhat' | passwd --stdin devops
su - devops -c "ssh-keygen -N '' -f ~/.ssh/id_rsa"
ansible localhost -m authorized_key -a "user=devops state=present key='$(cat /home/devops/.ssh/id_rsa.pub)'"
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=present line='devops ALL=(ALL) ALL'"
echo -e $TextLightGray && read -p "Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Now we're ready to run ansible as the devops user to restart apache
"
echo -e $TextRed '
  [devops@localhost] ansible localhost -m service -a "name=httpd state=restarted" -b -K
'
echo -e $TextLightGray && read -p "Press any key to continue -->" NULL && echo -e $ResetText
echo su - devops -c 'ansible localhost -m service -a "name=httpd state=restarted" -b -K'
su - devops -c 'ansible localhost -m service -a "name=httpd state=restarted" -b -K'

echo -e $TextBlue "
=========================================================================="
echo -e $TextGreen "
   Lastly we can enable NOPASSWD for sudo for the devops user
"
echo -e $TextRed "
  [root@localhost] ansible localhost -m lineinfile -a \"dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'\"
  [devops@localhost] ansible localhost -m service -a "name=httpd state=restarted" -b
"
echo -e $TextLightGray && read -p "Press any key to continue -->" NULL && echo -e $ResetText
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=absent line='devops ALL=(ALL) ALL'"
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'"
echo su - devops -c 'ansible localhost -m service -a "name=httpd state=restarted" -b'
su - devops -c 'ansible localhost -m service -a "name=httpd state=restarted" -b'

echo -e $TextGreen "
   That's it!
"
echo -e $TextLightGray && read -p "Press any key to cleanup & quit." NULL && echo -e $ResetText
userdel devops
rm -rf /home/devops
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=absent line='devops ALL=(ALL) NOPASSWD: ALL'"
