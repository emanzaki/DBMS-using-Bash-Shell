#!/bin/bash

mkdir DBMS 2>> logs/.error.log
clear
echo "Welcome to Database Management System"
echo -e "\nAuthor"
echo -e "\tEman Zaki"

function main {
	echo -e "\n========== Menu ==========="
	echo 	"|| 1- Select Database    ||"
	echo 	"|| 2- Create Database    ||"
	echo 	"|| 3- Drop Database      ||"
	echo 	"|| 4- Show Database      ||"
	echo 	"|| 5- Exit               ||"
	echo -e "==========================="
	echo -e "Enter Choice: \c"
	read n
	case $n in
		1) selectDB ;;
		2) createDB ;;
		3) dropDB ;;
		4) showDB ;;
		5) exit ;;
		*) echo "Please select number from the Menu"
	esac
}

function selectDB {
	echo -e "Database Name: \c"
	read nameDB
	cd ./DBMS/$nameDB 2>> logs/.error.log
	if [[ $? == 0 ]]; then
        	echo " $nameDB Database"
        	echo "========================="
        	#TODO: call the tables
	else
        	echo "Database $nameDB not found"
        fi
}

main
