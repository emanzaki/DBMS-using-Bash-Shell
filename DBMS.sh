#!/bin/bash
# Hide cursor
tput civis

#colors file
source ./config/text.sh

# ASCII art title
title=(
"${BLUE_BOLD}██████╗ ██████╗ ███╗   ███╗███████╗"
"${BLUE_BOLD}██╔══██╗██╔══██╗████╗ ████║██╔════╝"
"${BLUE_BOLD}██║  ██║██████╔╝██╔████╔██║███████╗"
"${BLUE_BOLD}██║  ██║██╔══██╗██║╚██╔╝██║╚════██║"
"${BLUE_BOLD}██████╔╝██████╔╝██║ ╚═╝ ██║███████║"
"${BLUE_BOLD}╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝"
"${CYAN_BOLD}        Welcome to the DBMS        "
)

# Author info
author_info=(
"${MAGENTA_BOLD}-----------------------------------------"
" Author : Eman Zaki"
" Role   : DevOps Engineer"
" Project: Bash-based DBMS System"
" GitHub : github.com/emanzaki"
"-----------------------------------------${CLEAR}"
)

# Display title
clear
for line in "${title[@]}"; do
    echo -e "$line"
    sleep 0.2
done

# Pause
sleep 0.5

# Display author info
for line in "${author_info[@]}"; do
    echo -e "$line"
    sleep 0.1
done


echo -e "${CLEAR}\n"
tput cnorm
source ./config/text.sh

mkdir -p DBMS 2>> ./.error.log
mkdir -p logs 2>> ./.error.log

function main {
	menu=(
	"${BLUE}-------------Menu--------------${CLEAR}"
	" 1- Select Database"
        " 2- Create Database"
	" 2- Drop Database"                
	" 4- Show Database"                
	" 5- Exit"                         
	"${BLUE}--------------------------------${CLEAR}"
	"${BOLD}Enter Choice: \c ${CLEAR}"
	)
	#print menu
	for line in "${menu[@]}"; do
		echo -e "$line"
		sleep 0.01
	done
	read n
	case $n in
		1) selectDB ;;
		2) createDB ;;
		3) dropDB ;;
		4) showDB ;;
		5) exit ;;
		*) echo -e "${RED}Please select number from the Menu${CLEAR}"
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
        	echo "----------$nameDB Database---------"
        	#TODO: call the tables
	else
        	echo "Database $nameDB not found"
        	main
	fi
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
