# Demo WalkThru

## Ansible Basic
```  
# ansible-basic.sh
```
* Run this script to walk thru a demonstration of the following features:
  * Basic Syntax
  * Installation
  * Inventory
  * Common modules
  * Documentation
  * Ansible ping
  * Running a remote command
  * Facts
  * Using modules
  * First playbook
  * Variables and Loops
  * Templates
  * Handlers
* Requirements
  * RHEL 7 or RHEL 8
  * Assumes root access
  * Assumes a /root/hosts file as the inventory, with the following:
    * A group named "demo"
    * Two hosts named ansible1 and ansible2
    * Alter this script accordingly if you want different hosts or group
    * Example:
```
[demo]
ansbile1
ansible2
```


## Ansible Advanced
```
# ansible-advanced.sh
```
* Run this script to walk thru a demonstration of the following features:
  * Conditionals
  * Roles
  * Galaxy
* Requirements
  * Same as Ansible Basic

## Ansible NonRoot
```  
#  ansible-nonroot.sh
```
* Run this script to walk thru a demonstration of running ansible as a non root user
  * Very simple example
  * Assumes a local user = devops, with sudo rights
* Requirements
  * For simplicity uses localhost as both Ansible master and control node

## Ansible Vault
```  
#  ansible-vault.sh
```
* Run this script to walk thru a demonstration of using ansible-vault
  * Manage Encrypted Files
  * Create Encrypted Variable File
  * Create Playbook Using Encrypted Variable File
* Requirements
  * For simplicity uses localhost as both Ansible master and control node
