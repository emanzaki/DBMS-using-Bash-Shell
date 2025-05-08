#!/bin/bash

mkdir -p DBMS 2>> ./.error.log
mkdir -p logs 2>> ./.error.log
clear
echo "Welcome to Database Management System"
echo -e "\nAuthor"
echo -e "\tEman Zaki"

function main {
	echo -e "\n--------------Menu--------------"
	echo 	"| 1- Select Database           |"
	echo 	"| 2- Create Database           |"
	echo 	"| 2- Drop Database             |"
	echo 	"| 4- Show Database             |"
	echo 	"| 5- Exit                      |"
	echo -e "--------------------------------"
	echo -e "Enter Choice: \c"
	read n
	case $n in
		1) selectDB ;;
		2) createDB ;;
		2) dropDB ;;
		4) showDB ;;
		5) exit ;;
		*) echo "Please select number from the Menu"
			main ;;
	esac
}

function selectDB {
	echo -e "Database Name: \c"
	read nameDB
	if [[ ${#nameDB} -lt 2 ]]; then
		echo "Database name must be at least 2 characters."
		selectDB
		return
	fi
	cd ./DBMS/$nameDB 2>> ./logs/.error.log
	if [[ $? == 0 ]]; then
        	echo " --------$nameDB Database--------"
        	#TODO: call the tables
	else
        	echo "Database $nameDB not found"
        fi
	main
}

function createDB {
	echo -e "Database Name: \c"
	read nameDB
	if [[ ${#nameDB} -lt 2 ]]; then
		echo "Database name must be at least 2 characters."
		createDB
		return
	fi
	mkdir ./DBMS/$nameDB 2>>./logs/.error.log
	if [[ $? == 0 ]] ; then
		echo "Database Created Successfully"
		#TODO: add the menu to the tables 
	else
		echo "Error happend while creating your Database"
	fi
	main

}


function dropDB {
	echo -e "Database Name: \c"
	read nameDB
	if [[ ${#nameDB} -lt 2 ]]; then
		echo "Database name must be at least 2 characters."
		dropDB
		return
	fi
	echo "Are you sure you want to drop $nameDB Database? y/n"
	read ans
	case $ans in
		[Yy])
			deletingDB $nameDB
			main	;;
		[Nn]) main ;;
		*) echo "Invalid input. Please enter only 'y' or 'n'." ;;
	esac

}

function showDB {
	arrDB=$(ls ./DBMS)
	x=1
	echo "-----------DATABASES---------"
	for db in $arrDB
	do
		echo "$x | $db"
		((x++))
	done
	echo "-----------------------------"
	main		
}

function deletingDB {
	file=./DBMS/$1 
	if [[ -f $file ]] ; then 	
		rm -r $file 2>>./logs/.error.log
       		echo "$1 Deleted successfully"
	else 
		echo "ERROR: Database doesn't exist"
	fi
}





main
