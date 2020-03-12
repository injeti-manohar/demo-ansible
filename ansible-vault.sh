#!/bin/bash

# Demo Ansible Vault

# Colors
TextBold='\033[1m'
TextRed='\033[0;31m' # Commands to execute
TextGreen='\033[0;32m' # Command Syntax & other text
TextBlue='\033[0;34m' # Section header & dividers
TextLightGray='\033[0;37m' # Pause & continue
ResetText='\033[0m'

trap 'echo -e $ResetText; exit 0' 0 1 2 3 15

# Make sure Ansible is installed
rpm -q ansible || (yum install -y ansible || exit 1)

# Create a working directory in users $HOME and cd to it
mkdir ~/ansible-demo && cd ~/ansible-demo

clear
echo -e $TextBlue "
	Ansible Core Advanced Topic = Ansible Vault
=========================================================================="
echo -e $TextGreen "
In this demo, you explore using encryption and decryption of files.
Then you use an encrypted file with an Ansible Playbook to store
usernames and passwords.

Setup:
Create a local user, create SSH keys for user, and grant sudo access.

# useradd devops
# echo 'redhat' | passwd --stdin devops
# su - devops -c "ssh-keygen -N '' -f ~/.ssh/id_rsa"
# ansible localhost -m authorized_key -a \"user=devops state=present key='\$(cat /home/devops/.ssh/id_rsa.pub)'\"
# ansible localhost -m lineinfile -a \"dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'\"
"

echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
useradd devops
echo 'redhat' | passwd --stdin devops
su - devops -c "ssh-keygen -N '' -f ~/.ssh/id_rsa"
ansible localhost -m authorized_key -a "user=devops state=present key='$(cat /home/devops/.ssh/id_rsa.pub)'"
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
Exercise: Manage Encrypted Files
=========================================================================="

echo -e $TextGreen '
Create an encrypted file called super-secret.yml, entering redhat
as the vault password when prompted:

'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextRed "
	$ ansible-vault create super-secret.yml
"

echo -e $TextGreen '
In the editor that is launched, add the following to the file:

		This is encrypted.

'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault create super-secret.yml

echo -e $TextGreen '

Attempt to view the contents of the encrypted super-secret.yml file:

Because super-secret.yml is encrypted, you cannot view the contents in plain text.

The default cipher (AES) used to encrypt the file is based on a shared secret.

'
echo -e $TextRed "
$ cat super-secret.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
cat super-secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
View the content of the encrypted file, entering redhat as the
vault password when prompted:

'
echo -e $TextRed "
$ ansible-vault view super-secret.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault view super-secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Edit super-secret.yml, specifying redhat as the vault password
when prompted:

'
echo -e $TextRed "
$ ansible-vault edit super-secret.yml
"
echo -e $TextGreen '
Add the following to the end of the file:

		This is also encrypted.
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault edit super-secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
View the content of super-secret.yml, using redhat as the vault password:

'
echo -e $TextRed "
$ ansible-vault view super-secret.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault view super-secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Change the vault password of the encrypted super-secret.yml file
from redhat to ansible:
'
echo -e $TextRed "
$ ansible-vault rekey super-secret.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault rekey super-secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Decrypt the encrypted super-secret.yml file and save the file
as super-secret-decrypted.yml, using the ansible-vault decrypt
subcommand with the --output option and ansible as the vault password:
'
echo -e $TextRed "
$ ansible-vault decrypt super-secret.yml --output=super-secret-decrypted.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault decrypt super-secret.yml --output=super-secret-decrypted.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
View the contents of the super-secret-decrypted.yml file to verify
that it is decrypted:

'
echo -e $TextRed "
$ cat super-secret-decrypted.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
cat super-secret-decrypted.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Encrypt the super-secret-decrypted.yml file and save the file
as passwd-encrypted.yml, this time entering redhat as the vault password:
'
echo -e $TextRed "
$ ansible-vault encrypt super-secret-decrypted.yml --output=super-secret-encrypted.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault encrypt super-secret-decrypted.yml --output=super-secret-encrypted.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

clear
echo -e $TextBlue "
Exercise: Create Encrypted Variable File
=========================================================================="

echo -e $TextGreen '
In this exercise, you create an encrypted file called secret.yml.
This file defines the password variables and stores the passwords
to be used in the playbook.

You use an associative array variable called newusers to define two users
and passwords with the name variable as ansibleuser1 and ansibleuser2
and the pw variable as redhat and ansible, respectively.

You set the vault password to redhat.

Create an encrypted file called secret.yml providing the password redhat
for the vault:
'
echo -e $TextRed "
$ ansible-vault create secret.yml
"

echo -e $TextGreen '
Add an associative array variable called newusers, containing
key/value pairs for the user names and passwords:

newusers:
  - name: ansibleuser1
    pw: redhat
  - name: ansibleuser2
    pw: ansible

Hint: to make this easier copy + paste the above into the vim editor
that displays next.
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-vault create secret.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

clear
echo -e $TextBlue "
Exercise: Create Playbook That Uses Encrypted Variable File
=========================================================================="

echo -e $TextGreen '
In this exercise, you create a playbook that uses the variables
defined in the secret.yml encrypted file.

You name the playbook create_users.yml.

Then you run this playbook as the devops user on the remote
managed host and configure the playbook to create users based on
the newusers associative array.

This creates the ansibleuser1 and ansibleuser2 users on the hosts.
'

echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
echo -e $TextGreen '
Create an Ansible Playbook named create_users.yml:

The password is converted into a password hash that uses the
password_hash hashing filters and sha512 algorithm.

'
echo -e $TextRed '
$ cat << EOF > create_users.yml
---
- name: create user accounts for all our servers
  hosts: localhost
  become: True
  remote_user: devops
  vars_files:
    - secret.yml
  tasks:
    - name: Creating users from secret.yml
      user:
        name: "{{ item.name }}"
        password: "{{ item.pw | password_hash('sha512') }}"
      with_items: "{{ newusers }}"
EOF
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
cat << EOF > create_users.yml
---
- name: create user accounts for all our servers
  hosts: localhost
  become: True
  remote_user: devops
  vars_files:
    - secret.yml
  tasks:
    - name: Creating users from secret.yml
      user:
        name: "{{ item.name }}"
        password: "{{ item.pw | password_hash('sha512') }}"
      with_items: "{{ newusers }}"
EOF
cat create_users.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Perform a syntax check of create_users.yml using
ansible-playbook --syntax-check, and include the --ask-vault-pass
option to prompt for the vault password set on secret.yml:
'
echo -e $TextRed "
$ ansible-playbook --syntax-check --ask-vault-pass create_users.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-playbook --syntax-check --ask-vault-pass create_users.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Create a password file called vault-pass with redhat as the contents
and set the permissions of the file to 0600:
'
echo -e $TextRed "
$ echo 'redhat' > vault-pass && chmod 0600 vault-pass
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
echo 'redhat' > vault-pass && chmod 0600 vault-pass
cat vault-pass && ls -l vault-pass
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Execute the Ansible Playbook, using the vault password file to create
the ansibleuser1 and ansibleuser2 users on the local system.

The usernames and passwords are stored as variables in the
encrypted secret.yml file.
'
echo -e $TextRed "
$ ansible-playbook --vault-password-file=vault-pass create_users.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ansible-playbook --vault-password-file=vault-pass create_users.yml
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
Validate by connecting to localhost as the new usernames

'
echo -e $TextRed "
ansibleuser1 password = redhat
$ ssh ansibleuser1@localhost

ansibleuser2 password = ansible
$ ssh ansibleuser2@localhost
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
ssh ansibleuser1@localhost 'echo I am user=$(/bin/whoami) on host=$(hostname)'
ssh ansibleuser2@localhost 'echo I am user=$(/bin/whoami) on host=$(hostname)'

echo -e $TextLightGray && read -p "<-- Press any key to cleanup the environment -->" NULL && echo -e $ResetText
userdel devops
userdel ansibleuser1
userdel ansibleuser2
rm -rf /home/devops
rm -rf /home/ansibleuser1
rm -rf /home/ansibleuser2
rm -r ~/ansible-demo
ansible localhost -m lineinfile -a "dest=/etc/sudoers state=absent line='devops ALL=(ALL) NOPASSWD: ALL'"
echo -e $TextLightGray && read -p "<-- Press any key to exit the demo -->" NULL && echo -e $ResetText
