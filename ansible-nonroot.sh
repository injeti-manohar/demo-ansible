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

# run cmd with --become (-b)
clear
echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "  
   Demonstration: running ansible as non-root user

   Scenario: allow web developers to restart Apache
"
echo -e $TextRed '
	# ansible ansible1 -m service -a "name=httpd state=restarted" -b -K
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen "
   First make sure apache is installed on ansible1
   Second su to testuser
   Then run above ansible command"
ansible ansible1 -m yum -a "name=httpd state=present" -b
gnome-terminal --command 'su - testuser' --tab
echo 'ansible ansible1 -m service -a "name=httpd state=restarted" -b -K' | xclip -selection clipboard

echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "  
   Setup SSH, as testuser
"
echo -e $TextRed "
	# ssh-keygen
	# ssh-copy-id ansible1
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Setup sudoers
"
echo -e $TextLightGray && read -p "Press any key to view sudoers entry." NULL && echo -e $ResetText
grep testuser /etc/sudoers

echo -e $TextLightGray && read -p "Press any key to view sudo log." NULL && echo -e $ResetText
grep sudo /var/log/secure | grep ansible | grep testuser

echo -e $TextGreen "
   That's it!
"
echo -e $TextLightGray && read -p "Press any key quit." NULL && echo -e $ResetText

