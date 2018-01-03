jenkins-ssh-keys
================

Ansible role to manage ssh pub keys on remote systems...allows the addition or removal of keys for remote users.

Requirements
------------

In order to use this role, existing ssh keys must exist in the ssh_pub_keys folder

Adding a new country
--------------------

Copy and paste the variable below in defaults/main.yml and name it appropriately for the respective country


````
{country-code}_ssh_keys:
  - remote_user: user  #define username on remote system to add defined keys to
    state: present  #defines if ssh key should be added or removed (absent|present)
    keys:  #define key(s) to add to remote username
      - ssh_pub_keys/{country_code}_jenkins_ubuntu.pub. #ssh key for ubuntu user
      - ssh_pub_keys/{country_code}_jenkins_jenkins.pub. #ssh key for jenkins user
````


Add the task in the tasks/manage_ssh_keys.yml

````
- name: manage_ssh_keys | managing {country-code} Jenkins ssh keys
  authorized_key:
    user: "{{ item.0.remote_user }}"
    key: "{{ lookup('file', item.1) }}"
    state: "{{ item.0.state }}"
  with_subelements:
    - '{{ {country-code}_ssh_keys }}'
    - keys
  when: " '{{group_name}}' in group_names "
````

Running the role
----------------
To run the role
ansible-playbook -i provisioning/hosts provisioning/jenkins-ssh-keys.yml -l {country-code}-{service-name}-{env}

E.g
````
ansible-playbook -i provisioning/hosts provisioning/jenkins-ssh-keys.yml -l ke-services-dev-1
````

