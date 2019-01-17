#!/bin/bash

# Demo Ansible Roles and Ansible Galaxy

# Colors
TextBold='\033[1m'
TextRed='\033[0;31m' # Commands to execute
TextGreen='\033[0;32m' # Command Syntax & other text
TextBlue='\033[0;34m' # Section header & dividers
TextLightGray='\033[0;37m' # Pause & continue
ResetText='\033[0m'

clear
echo -e $TextBlue "
	Ansible Core Advanced Topics
==========================================================================" 
echo -e $TextGreen '
   Conditionals

   Ansible supports the conditional execution of a task based on the run-time
   evaluation of variable, fact, or previous task result.

	- yum:
	    name: httpd
	    state: latest
	  when: ansible_os_family == "RedHat"
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
   Tags

   Tags are useful to be able to run a subset of a playbook on-demand.

	- yum:
	    name: "{{ item }}"
	    state: latest
	  with_items:
	  - httpd
	  - mod_wsgi
	  tags:
	     - packages

	 - template:
	     src: templates/httpd.conf.j2
	     dest: /etc/httpd/conf/httpd.conf
	  tags:
	     - configuration

   Example:
'
echo -e $TextRed "
	# ansible-playbook --tags=packages example.yml
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText
          
echo -e $TextBlue "
	Ansible Roles and Ansible Galaxy
==========================================================================" 
echo -e $TextGreen "
   Roles

   Roles are a package of closely related Ansible content that can be shared
   more easily than plays alone.
	  * Improves readability and maintainability of complex plays
	  * Eases sharing, reuse and standardization of automation processes
	  * Enables Ansible content to exist independently of playbooks,
		projects -- even organizations
	  * Provides functional conveniences such as file path resolution and
		default values
"
echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Ansible Galaxy

	http://galaxy.ansible.com

   Ansible Galaxy is a hub for finding, reusing and sharing Ansible content.

   Allows you to jump-start your automation project with content contributed
   and reviewed by the Ansible community.
"
echo -e $TextLightGray && read -p "Press any key to learn how Roles and Galaxy work together." NULL && echo -e $ResetText
firefox https://galaxy.ansible.com

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Ansible Roles and Ansible Galaxy

   While it is possible to write a playbook in one file as we’ve seen today,
   eventually you’ll want to reuse files and start to organize things.

   Ansible Roles is the way we do this. When you create a role, you deconstruct
   your playbook into parts and those parts sit in a directory structure.

   For this exercise, you are going to take the apache-basic-playbook and
   refactor it into a role. In addition, you’ll learn to use Ansible Galaxy.

   Let’s begin with seeing how a playbook will break down into a role.
"
echo -e $TextLightGray && read -p "Press any key to view dir structure." && echo -e $ResetText
tree myplaybooks/apache-basic-playbook

echo -e $TextGreen "
   Fortunately, you don’t have to create all of these directories and files by hand.
   That’s where Ansible Galaxy comes in.
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText


echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Using Ansible Galaxy to initialize a new role

   Ansible Galaxy is a free site for finding, downloading, and sharing roles.
   It’s also pretty handy for creating them which is what we are about to do here.

   Step 1: Navigate to your apache-basic-playbook project
"
echo -e $TextRed "
	# cd ~/apache-basic-playbook
"
echo -e $TextGreen "
Step 2: Create a directory called roles and cd into it
"
echo -e $TextRed "
	# mkdir roles
	# cd roles"
echo -e $TextGreen "
   Step 3: Use the ansible-galaxy command to initialize a new role called apache-simple
"
echo -e $TextRed "
	# ansible-galaxy init apache-simple
"
echo -e $TextGreen "
   It is Ansible best practice to clean out role directories and files you won’t be using.
   For this role, we won’t be using anything from files, tests.

   Step 4: Remove the files and tests directories
"
echo -e $TextRed "
	# cd ~/apache-basic-playbook/roles/apache-simple/
	# rm -rf files tests
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Breaking your site.yml playbook into the newly created apache-simple role

   In this section, we will separate out the major parts of your playbook
   including vars:, tasks:, template:, and handlers:

   Step 1: Make a backup copy of site.yml, then create a new site.yml
"
echo -e $TextRed "
	# mv site.yml site.yml.bkup
"
echo -e $TextGreen "
   Step 2: Add the play definition and the invocation of a single role

	---
	- hosts: web
	  name: This is my role-based playbook
	  become: yes

	  roles:
	    - apache-simple
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen "
   Step 3: Add some default variables to your role in roles/apache-simple/defaults/main.yml

	---
	# defaults file for apache-simple
	apache_test_message: This is a test message
	apache_max_keep_alive_requests: 115

   Step 4: Add some role-specific variables to your role in roles/apache-simple/vars/main.yml

	---
	# vars file for apache-simple
	httpd_packages:
	  - httpd
	  - mod_wsgi

   Note: we just put variables in two seperate places!

   Variables can live in quite a few places. Just to name a few:
	* vars directory
	* defaults directory
	* group_vars directory
	* In the playbook under the vars: section
	* In any file which can be specified on the command line using the --extra_vars option

   Bottom line, you need to read up on variable precedence to understand both where to define
   variables and which locations take precedence. In this exercise, we are using role defaults
   to define a couple of variables and these are the most malleable. After that, we defined
   some variables in /vars which have a higher precedence than defaults and can’t be overridden
   as a default variable.
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen "
   Step 5: Create your role handler in roles/apache-simple/handlers/main.yml

	---
	# handlers file for apache-simple
	- name: restart apache service
	  service:
	    name: httpd
	    state: restarted
	    enabled: yes
"
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextGreen '
   Step 6: Add tasks to your role in roles/apache-simple/tasks/main.yml

	---
	# tasks file for apache-simple
	- name: install httpd packages
	  yum:
	    name: "{{ item }}
	    state: present
	  with_items: "{{ httpd_packages }}"
	  notify: restart apache service

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
'
echo -e $TextLightGray && read -p "<-- Press any key to continue -->" NULL && echo -e $ResetText

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Running your new role-based playbook

   Now that you’ve successfully separated your original playbook into a role,
   let’s run it and see how it works.
"
echo -e $TextRed "
	# ansible-playbook site.yml
"
echo -e $TextLightGray && read -p "Press any key to run our role-based playbook." NULL && echo -e $ResetText
ansible-playbook myplaybooks/apache-basic-playbook/site.yml

echo -e $TextBlue "
==========================================================================" 
echo -e $TextGreen "
   Before we go let's see the success of our playbook ...
"
echo -e $TextLightGray && read -p "<-- Press any key to open a browser -->" NULL && echo -e $ResetText
firefox http://ansible1

echo -e $TextGreen "
   That's it!  Thanks for playing!"
echo -e $TextLightGray && read -p "Press any key to clean up the environment." NULL && echo -e $ResetText
ansible-playbook myplaybooks/cleanup.yml
