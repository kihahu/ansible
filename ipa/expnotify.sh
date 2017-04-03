#!/bin/bash

export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ansible/.local/bin:/home/ansible/bin

fromemail="<from email >"
pcurl="https://172.31.45.21/passwordchangeportal/"
ipauser="readonly"
ipapass="<password from readonly user>"
numberofdays=<number of days to password expiry>
todaysdate=$(date +"%Y%m%d")

userlist=$(ipa user-find |grep 'User login:'| awk -F ": " '{print $2}')

echo $ipapass | kinit $ipauser >/dev/null

for user in $userlist; do

expirydate=$(ipa user-show $user --all | grep krbpasswordexpiration | awk '{print $2}' | cut -c 1-8)
emailid=$(ipa user-show $user --all | grep 'Email address:' | awk -F ": " '{print $2}')
calcexpiry=$(date -d "$expirydate" +%s)
calctoday=$(date -d "$todaysdate" +%s)
secsleft=$(expr $calcexpiry - $calctoday)
daysleft=$(expr $secsleft / 60 / 60 / 24)


if [ $daysleft -le $numberofdays ];
then 
mail -s "Password Expiry Notofication" -r $fromemail $emailid <<EOF
Your password is about to expire in $daysleft days. Please login to passsword change portal - $pcurl and change your password.

EOF
echo
fi
done
