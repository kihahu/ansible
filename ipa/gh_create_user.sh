#!/bin/bash

export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ansible/.local/bin:/home/ansible/bin

fromemail="<from email id>"
ipauser="readonly"
ipapass="<readonly users password>"
adminmail="<distribution/email id to notify after user creation/errors>"
gh_file_path=/opt/ghfiles
ansible_dir=/home/ansible/play-work
ansible_user_var_dir=$ansible_dir/roles/ipaschema/vars/users
ansible_vault_file="<path of ansible vault file>"


for file in `sudo ls $gh_file_path/*.yml 2>/dev/null`; do

username=`grep username $file |awk -F '"' '{print $2}'`

ipa user-show $username >/dev/null 2>&1

if [ $? -eq 0 ];
then 

sudo mv $file $file.err

mail -s "$username - Greenhouse user already exists in IPA" -r $fromemail $adminmail <<EOF
This email is from the job to create Greenhouse users in IPA. $username already exists in IPA. 
Please check the user config file $file.err on `hostname` submitted by Greenhouse. 
EOF

else

sudo mv $file $ansible_user_var_dir/

sudo chown ansible.ansible $ansible_user_var_dir/$username.yml

rpasswd=`date +%s | sha256sum | base64 | head -c 8 ;`

cd $ansible_dir
ansible-playbook --vault-password-file ~/.vault_pass.txt create_user_greenhouse.yml --extra-vars "inp_user=$username inp_passwd=$rpasswd" >/tmp/${username}_create.log 2>&1


if [ $? -eq 0 ];
then

mail -s "$username - Greenhouse user created in IPA" -a /tmp/${username}_create.log -r $fromemail $adminmail <<EOF
This email is from the job to create Greenhouse users in IPA. $username is created in IPA. Password for the user is "$rpasswd". Please find attached Ansible log.
EOF

else

mail -s "$username - Greenhouse user creation error" -a /tmp/${username}_create.log -r $fromemail $adminmail <<EOF
This email is from the job to create Greenhouse users in IPA. Ansible failed to create $username . Please see the attached ansible log.
EOF

fi

fi

done
