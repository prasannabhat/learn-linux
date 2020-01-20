#!/bin/bash

#function for checking if a user already exist
# and creates them if not
checkAndCreateUser()
{
    if id "$1" >/dev/null 2>&1; then
    {
        echo "user $1 already exist"
    }
    else
    {
        sudo useradd -M $1
    }
    fi

    return 0
}

echo "Starting scripts"
echo "Creating file a.txt"
touch a.txt
echo "Hi there" > a.txt
echo "Remove access for others"
sudo chmod 640 a.txt
TEST_USER=susi
checkAndCreateUser $TEST_USER
echo "Checking if user $TEST_USER can access the file" 
TEST_USER_ID="$(id -u $TEST_USER)"
echo "user id of $TEST_USER is $TEST_USER_ID"
sudo setfacl -x u:$TEST_USER a.txt
sudo -u $TEST_USER cat a.txt
echo "Give access to $TEST_USER using setfacl command"
sudo setfacl -m u:$TEST_USER:r a.txt
echo "Checking if user $TEST_USER can access the file" 
sudo -u $TEST_USER cat a.txt
sudo -u \#$TEST_USER_ID cat a.txt

# Reset acl rights
sudo setfacl -x u:$TEST_USER a.txt

echo ##################################################
# Some user who doesnt exist in system config file
TEST_USER_ID=2000
echo "Testing for user ($TEST_USER_ID) , who doesnt exist in system config files"
sudo setfacl -m u:$TEST_USER_ID:r a.txt
sudo -u \#$TEST_USER_ID cat a.txt
sudo setfacl -x u:$TEST_USER_ID a.txt

rm a.txt
