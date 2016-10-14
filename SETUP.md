# Instructions to setup your vagrant box for local development

This document gives instructions to set up your computer to allow you to do dev work for InVenture projects.

We'll be using vagrant to set up an Ubuntu 14.04 server that will run on your computer within virtualbox.

The code on your computer will be synced with a folder in the virtual machine.

The instructions below will guide you through the steps to set up your local computer and the virtual machine.

Note: The instructions here serve as a general guideline for a quick setup - any improvements/suggestions are welcome - feel free to set this up as you please

- Make sure you set up Virtualbox & Vagrant according to the instructions in their respective documentation:
    - Vagrant: https://www.vagrantup.com/docs/getting-started/
    - Virtualbox (download): https://www.virtualbox.org/wiki/Downloads


###### Directory Setup
Create base directory for your work. The apps directory is where you'll be checking out your code repositories. From your terminal, run the following command:
```
mkdir -p ~/Code/env/inventure/apps
```

###### Vagrant setup
Set up vagrant to control your virtual machine:
- Download the Vagrant setup file used by Inventure devs.
```
# go to the base directory
cd ~/Code/env/inventure
# download the base vagrant file (Get the URL by going to https://github.com/inventure/Ansible/tree/master/provisioning/roles/server-setup/files/Vagrantfile_template; Click on 'Raw', then use the URL for the file in the wget command below) - Ensure you're logged in to the Github account you use with InVenture
wget "https://path/to/Vagrantfile_template" -O Vagrantfile

# run vagrant
vagrant up

# you may be asked to put in your computer's Administrator password to allow NFS exports. This allows the virtual machine to access the files on your local computer

# configure your hosts file to include your virtual machine
# edit your /etc/hosts file, and add "192.168.33.10 inventure-local" to the end of the file (without the quotes)

# symlink the virtual machine's SSH key to a common path in ~/.ssh/
ln -s ~/Code/env/inventure/.vagrant/machines/local.inventure.com/virtualbox/private_key ~/.ssh/inventure-local.key

# Add the virtual machine to your SSH config. Copy the text below and add it to your ~/.ssh/config file
Host inventure-local
   ForwardAgent yes
   HostName 192.168.33.10
   Port 22
   User vagrant
   IdentityFile ~/.ssh/inventure-local.key
```

Once you have completed the steps above, you can check that your server set up completed successfully:

- Check that you can ssh into the computer. From the base directory, run: `vagrant ssh`. You should be able to log in to your virtual machine
- Check that the directory mapping was successful (i.e. that `~/Code/env/inventure/apps` on your computer is mapped to `/srv/applications` on the virtual machine)
    - On your computer, go to the apps directory: `cd ~/Code/env/inventure/apps`
    - Create a file called tala.txt: `touch tala.txt`
    - SSH into the virtual machine: `vagrant ssh`
    - Confirm that tala.txt is available in the applications directory: `ls /srv/applications/tala.txt` - This command should show that the file exists

###### Base Server Setup
Once we've set up all the above, it's time to install the basic requirements on our server. We will run an Ansible script to do the following tasks:

- Upgrade the software on the virtual machine
- Install Python-related tools (pip, virtualenv, etc)
- Install common utility programs to make your day to day life easier (e.g. vim, curl, tree, git, htop, etc)
- Set up a basic LAMP stack

```
# ensure you have ansible (version 2.0.2) installed on your computer
sudo pip install 'ansible == 2.0.2'

# obtain InVenture's ansible encryption password from one of the sysadmins

# configure the password for use on your computer
touch ~/Code/env/inventure/apps/vault-pass.txt

# add the password to the file created above
echo "passwordfromsysadmin" >> ~/Code/env/inventure/apps/vault-pass.txt

# ensure the ANSIBLE_VAULT_PASSWORD_FILE variable is set in your environment by adding this to your .bash_profile file or equivalent
export ANSIBLE_VAULT_PASSWORD_FILE=~/Code/env/inventure/apps/vault-pass.txt

# check out the ansible project to your computer, in the apps folder
cd ~/Code/env/inventure/apps
git clone git@github.com:inventure/Ansible.git

# go to the Ansible project, and test connection to the virtual machine
cd Ansible
ansible inventure-local -i provisioning/hosts -m ping
# the command should return success ("pong") for the virtual machine
# if not, make sure the virtual machine is running (vagrant up)

# run the base server setup role
# (note: at this time we are skipping PHP 7 setup, and MySQL security setup - this will be run separately)
ansible-playbook -i provisioning/hosts provisioning/vagrant.yml -l inventure-local --skip-tags='php-7-setup,mysql-deps-php7,mysql-server-security-setup'

# set up mysql secure installation
# go to the base directory and ssh into your virtual machine
cd ~/Code/env/inventure
vagrant ssh

# run mysql secure installation script. running this script will take you through first time mysql setup
sudo mysql_secure_installation
```

You can test that your installation was successful:

- Test Apache - Try access the default Apache web page from your local computer. On your browser, go this url: http://inventure-local/ - The Apache2 Ubuntu Default Page saying "It works!" should appear
- Test MySQL - From the virtual machine, log in to mysql, and create a test database and a test user:
    - `vagrant ssh` (from base directory)
    - `mysql -u root -p` (Enter your password)
    - `create database test;`
    - `grant all on test.* to 'test'@'%' identified by 'yourveryinsecurepassword'`
    - On another terminal (or on your SQL client), try accessing the database running on your virtual machine.
        ```
        Host: 192.168.33.10 (or inventure-local)

        User: test

        Password: 'the one you put above'
        ```
    - You should be able to access the test db you created

Congrats! At this point, you have a fully functional Ubuntu Server running on your computer.

To set up a specific application, please run the deploy scripts for local environment available in that project.

# USING THE aws-monitor-setup ROLE
- Ensure the aws cli application is installed and configured using your IAM credentials see:
	- http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
	- http://docs.aws.amazon.com/cli/latest/userguide/installing.html
- To setup monitoring on a single instance you will need to filter it by its private ip using below command
	- ` play -i hosts aws-monitor.yml -l {{ country_code }}-devops --vault-password ~/.vault -e "private_ip={{ PRIVATE_IP_GOES_HERE" ` 
- To setup monitoring on all the instances in a region use `*` as the private ip using below command:
	- `play -i hosts aws-monitor.yml -l {{ country_code }}-devops --vault-password ~/.vault -e "private_ip=*"`

# USING THE archiving ROLE to archive
## payments log
- Run the ansible playbook command as shown below:
	- `ansible-playbook -i hosts archive.yml -l payments --tags payment-logs-archive`
## mysql archiving
- Run the ansible playbook command as shown below:
	- `ansible-playbook -i hosts archive.yml -l payments --tags mysql-archive`

# USING THE jenkins-slave-setup ROLE
## use ansible >= 2.1
	- `ansible-playbook -i hosts jenkins.yml -l {country code}-jenkins --vault-password {{ path to vault file }}`

Happy Coding!
