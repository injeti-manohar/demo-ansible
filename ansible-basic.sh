#!/bin/bash

# Demo Ansible Core

# HOW-TO
#   Add a description of what will be demonstrated
#   plus the command being run
#   THEN run the command
#   Add any commentary afterward

# Colors
TextBold='\033[1m'
TextRed='\033[0;31m' # Commands to execute
TextGreen='\033[0;32m' # Command Syntax & other text
TextBlue='\033[0;34m' # Section header & dividers
TextLightGray='\033[0;37m' # Pause & continue
ResetText='\033[0m'
TextPurple='\033[0;35m'
TextYellow='\033[1;33m'

trap 'echo -e $ResetText; exit 0' 0 1 2 3 15

# Setup
# Make sure Ansible is installed
rpm -q ansible || (yum install -y ansible || exit 1)
# Create a working directory
mdkir ~/myplaybooks
# Populate working directory with playbooks
curl -O https://raw.githubusercontent.com/marktonneson/ansible-playbooks/master/apache-basic-install-apache.yml ~/myplaybooks/
curl -O https://raw.githubusercontent.com/marktonneson/ansible-playbooks/master/apache-basic-remove-apache.yml ~/myplaybooks/
curl -O https://raw.githubusercontent.com/marktonneson/ansible-playbooks/master/apache-basic-playbook.yml ~/myplaybooks/
curl -O https://raw.githubusercontent.com/marktonneson/ansible-playbooks/master/apache-basic-cleanup.yml ~/myplaybooks/
# Create templates directory
mdkir -p ~/myplaybooks/templates
# Populate working directory with Templates
echo << EOF > ~/myplaybooks/templates/index.html.j2
<html>
<head>
  <title>Ansible: Automation for Everyone</title>
<body>
<p>This is the message from the playbook variable: {{ apache_test_message }}</p>
<p>This is an ansible fact: {{ inventory_hostname }}</p>
</body>
</html>
EOF
cd ~/myplaybooks/template/
curl -O https://raw.githubusercontent.com/ansible/lightbulb/master/examples/apache-role/roles/apache-simple/templates/httpd.conf.j2
cd ~

# Create a hosts file for Inventory
echo << EOF > /root/hosts
[demo]
ansible1
ansible2
EOF
# Create a local ansible.cfg to use the inventory file
echo << EOF > /root/ansible.cfg
inventory = /root/hosts
EOF

clear
echo -e $TextBlue "
	Ansible Core Basics
=========================================================================="  $ResetText
echo -e $TextGreen "
   ansible [target] -m [module] -a [module args]
	--check = no action
	--syntax-check = check playbook, no action
	-b = become
	-K = ask become password
	-k = ask password
	-v[vv] = verbose output
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   First, how do you install Ansible?

   Install ansible via yum"
echo -e $TextRed "
	# yum install ansible
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Next, let's take a look at the inventory file

   Ansible works against multiple systems in your infrastructure at the same
   time. It does this by selecting portions of systems listed in Ansible’s
   inventory file, which defaults to being saved in the location:

	/etc/ansible/hosts
"
echo -e $TextReset && read -p "   Press any key to open this file" NULL && echo -e $ResetText
less /etc/ansible/hosts

echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Finally, let's explore some common modules
"
echo -e $TextLightGray && read -p "<-- Press any key to learn about Commands modules -->" NULL && echo -e $ResetText
echo -e $TextGreen "
   Commands modules -- various methods of running simple commands.

	command - Executes a command on a remote node
	raw - Executes a low-down and dirty SSH command
	script - Runs a local script on a remote node after transferring it
	shell - Execute commands in nodes
"
echo -e $TextLightGray && read -p "<-- Press any key to learn about Files modules -->" NULL && echo -e $ResetText
echo -e $TextGreen "
   Files modules -- various methods of manipulating files and dirs.

	copy - Copies files to remote locations
	file - Sets attributes of files
	find - return a list of files based on specific criteria
	template - Templates a file out to a remote server
"
echo -e $TextLightGray && read -p "<-- Press any key to learn about additional modules -->" NULL && echo -e $ResetText
echo -e $TextGreen "
   Package modules -- manage packages and repositories.

	redhat_subscription - Manage registration and subscriptions to RHSM
	yum - Manages packages with the *yum* package manager
	yum_repository - Add or remove YUM repositories


   System modules -- manage various system functions.

	cron - Manage cron.d and crontab entries
	filesystem - Makes file system on block device
	firewalld - Manage arbitrary ports/services with firewalld
	service - Manage services
	systemd - Manage services
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Where to go for more information:

	http://docs.ansible.com
"
echo -e $TextRed "
	# ansible-doc
"
echo -e $TextLightGray && read -p "<-- Press any key to continue to running ansible commands -->" NULL && echo -e $ResetText


# ==============================================================================
#	Ansible Command Line
# ==============================================================================

clear
echo -e $TextBlue "
	Ansible Command Line
=========================================================================="  $ResetText
echo -e $TextGreen "
   Let’s start with something really basic - pinging a host.
   The ping module makes sure our demo hosts are responsive."
echo -e $TextRed "
   	# ansible demo -m ping
"
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m ping


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Now let’s see how we can run a good ol' fashioned Linux command
   and format the output using the command module."
echo -e $TextRed '
	# ansible demo -m command -a "uptime" -o'
echo -e $TextGreen "
   Note: new cmdline arg -o = output on one line
"
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m command -a "uptime" -o


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Take a look at a node’s configuration.
   The setup module displays ansible facts (and a lot of them)
   about an endpoint."
echo -e $TextRed "
	# ansible ansible1 -m setup
"
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible ansible1 -m setup | less


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Now, let’s install Apache using the yum module.

	Note: this operation takes 1-2 minutes to complete.
"
echo -e $TextRed '
	# ansible demo -m yum -a "name=httpd state=present" -b
'
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m yum -a "name=httpd state=present" -b


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   It's important to note that Ansible is idempotent,
   meaning we can re-run the same command without consequence."
echo -e $TextRed '
	# ansible demo -m yum -a "name=httpd state=present" -b
'
echo -e $TextLightGray && read -p "<-- Press any key to re-run above command -->" NULL && echo -e $ResetText
ansible demo -m yum -a "name=httpd state=present" -b


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   OK, Apache is installed now so let’s start it up using the service module."
echo -e $TextRed '
	# ansible demo -m service -a "name=httpd state=started" -b
'
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m service -a "name=httpd state=started" -b


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Finally, let’s clean up after ourselves. First, stop the httpd service."
echo -e $TextRed '
	# ansible demo -m service -a "name=httpd state=stopped" -b
'
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m service -a "name=httpd state=stopped" -b


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Next, remove the Apache package."
echo -e $TextRed '
	# ansible demo -m yum -a "name=httpd state=absent" -b
'
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible demo -m yum -a "name=httpd state=absent" -b

echo -e $TextLightGray && read -p "<-- Press any key to continue to playbooks -->" NULL && echo -e $ResetText

# ==============================================================================
#	Ansible Playbooks
# ==============================================================================

clear
echo -e $TextBlue "
	Ansible Playbooks
=========================================================================="  $ResetText
echo -e $TextGreen "
   Your first YAML file == Your first playbook.

	---
	- hosts: demo
	  name: Install the apache web service
	  become: yes

	  tasks:
	    - name: install apache
	      yum:
	        name: httpd
	        state: present

	    - name: start httpd
	      service:
	        name: httpd
	        state: started

   NOTE: with YAML line formatting and spacing is critical."
echo -e $TextReset && read -p "   Here's the same YAML file with spacing noted." NULL && echo -e $ResetText
echo -e $TextGreen "
	- hosts: demo
	^^name: Install the apache web service
	^^become: yes

	^^tasks:
	^^^^- name: install apache
	^^^^^^yum:
	^^^^^^^^name: httpd
	^^^^^^^^state: present

	^^^^^^- name: start httpd
	^^^^^^service:
	^^^^^^^^name: httpd
	^^^^^^^^state: started
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   We are now going to run you’re brand spankin' new playbook
   on your two web nodes. To do this, you are going to use the
   ansible-playbook command."
echo -e $TextRed "
	# ansible-playbook ~/myplaybooks/apache-basic-install-apache.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible-playbook ~/myplaybooks/apache-basic-install-apache.yml
echo -e $TextGreen "
   You'll notice that the output from running a playbook is much
   cleaner than running a single ansible command."
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Again remember that Ansible is idempotent,
   so we can re-run the same playbooks also"
echo -e $TextRed "
	# ansible-playbook ~/myplaybooks/apache-basic-install-apache.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to re-run above command -->" NULL && echo -e $ResetText
ansible-playbook ~/myplaybooks/apache-basic-install-apache.yml


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   There's also a number of options available:

	--private-key The private ssh key to connect to the remote machine.
	-i This option allows you to specify the inventory file you wish to use.
	-v[v] This increases verbosity, either once or twice."
echo -e $TextRed "
	# ansible-playbook --private-key=~/.ssh/id_rsa -i ./hosts -vv ~/myplaybooks/apache-basic-remove-apache.yml
"
echo -e $TextReset && read -p "   Press any key to view apache-basic-remove-apache.yml" NULL && echo -e $ResetText
less ~/myplaybooks/apache-basic-remove-apache.yml
echo -e $TextLightGray && read -p "<-- Press any key to run above command -->" NULL && echo -e $ResetText
ansible-playbook --private-key=~/.ssh/id_rsa -i ./hosts -vv ~/myplaybooks/apache-basic-remove-apache.yml

# ==============================================================================
#	Ansible Playbooks
# ==============================================================================
echo -e $TextLightGray && read -p "<-- Press any key to continue to more advanced playbooks -->" NULL && echo -e $ResetText
clear
echo -e $TextBlue "
	Advanced Playbooks
=========================================================================="  $ResetText
echo -e $TextGreen '
   Getting more Advanced: Variable and Loops

   Here is a new playbook with a play definition and some variables.

	---
	- hosts: web
	  name: This is a play within a playbook
	  become: yes
	  vars:
	    httpd_packages:
      	      - httpd
	      - mod_wsgi
	    apache_test_message: This is a test message
	    apache_webserver_port: 80
	  tasks:
	    - name: install httpd packages
	      yum:
        	name: "{{ item }}"
	        state: present
	      with_items: "{{ httpd_packages }}"
	      notify: restart apache service

	The variables include additional packages your playbook will install.
	Plus some web server specific configurations.

   - vars: You’ve told Ansible the next thing it sees will be a variable name
   - httpd_packages: You are defining a list-type variable called httpd_packages.
     What follows is a list of those packages
   - {{ item }} You are telling Ansible that this will expand into a list item.
   - with_items: {{ httpd_packages }} This is your loop which is instructing
     Ansible to perform this task on every item in httpd_packages
   - notify: This statement is a handler, more on this later.
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
	Getting more Advanced: Templates and Jinja (huh?)

	When you need to do pretty much anything with files and directories,
	use one of the Ansible Files modules. In this case, we’ll leverage
	the file and template modules.

	    - name: create site-enabled directory
	      file:
        	name: /etc/httpd/conf/sites-enabled
        	state: directory

	    - name: copy httpd.conf
	      template:
        	src: templates/httpd.conf.j2
        	dest: /etc/httpd/conf/httpd.conf
	      notify: restart apache service

	    - name: copy index.html
	      template:
        	src: templates/index.html.j2
        	dest: /var/www/html/index.html

	    - name: start httpd
	      service:
        	name: httpd
        	state: started
        	enabled: yes

   - file: This module is used to create, modify, delete files, directories, and symlinks.
   - template: This module specifies that a jinja2 template is being used and deployed.
   - jinja-who? - jinja2 is used in Ansible to transform data inside a template expression.
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Getting more Advanced: Using Handlers

   Lastly, we'll define a handler

	handlers:
	    - name: restart apache service
	      service:
        	name: httpd
        	state: restarted
        	enabled: yes

   - handler: This is telling the play that the tasks: are over, and now
     we are defining handlers. Everything below that looks the same as any
     other task, i.e. you give it a name, a module, and options for that module.
   - notify: restart apache service:
     Finally! The nofify statement is the invocation of a handler by name.
"
echo -e $TextLightGray && read -p "<-- Let's quickly look at our completed playbook ... -->" NULL && echo -e $ResetText
less ~/myplaybooks/apache-basic-playbook.yml


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Now the real test .. running the playbook!

	Note: this operation takes 2-3 minutes to complete.
"
echo -e $TextRed "
	# ansible-playbook -v ~/myplaybooks/apache-basic-playbook.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to run the above command. -->" NULL && echo -e $ResetText
ansible-playbook -v ~/myplaybooks/apache-basic-playbook.yml


echo -e $TextBlue "
=========================================================================="  $ResetText
echo -e $TextGreen "
   Before we go let's see the success of our playbook ...
"
echo -e $TextLightGray && read -p "<-- Press any key to open a browser -->" NULL && echo -e $ResetText
firefox http://ansible1 || curl http://ansible1

echo -e $TextGreen "
   That's it!  Thanks for playing!"
echo -e $TextLightGray && read -p "<-- Press any key to clean up the environment. -->" NULL && echo -e $ResetText
ansible-playbook ~/myplaybooks/apache-basic-cleanup.yml
rm -rf ~/myplaybooks
rm ~/hosts
rm ~/ansible.cfg
