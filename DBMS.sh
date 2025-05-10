#!/bin/bash
# Hide cursor
tput civis

#colors file
source ./config/text.sh
flag=false
# ASCII art title
title=(
"\n${BLUE_BOLD}		██████╗ ██████╗ ███╗   ███╗███████╗"
"${BLUE_BOLD}		██╔══██╗██╔══██╗████╗ ████║██╔════╝"
"${BLUE_BOLD}		██║  ██║██████╔╝██╔████╔██║███████╗"
"${BLUE_BOLD}		██║  ██║██╔══██╗██║╚██╔╝██║╚════██║"
"${BLUE_BOLD}		██████╔╝██████╔╝██║ ╚═╝ ██║███████║"
"${BLUE_BOLD}		╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝"
"${CYAN_BOLD}        		Welcome to the DBMS        "
)

# Author info
author_info=(
"		${CYAN_BOLD}-----------------------------------------"
"			Author : Eman Zaki"
"			Role   : DevOps Engineer"
"			Project: Bash-based DBMS System"
"			GitHub : github.com/emanzaki"
"		-----------------------------------------${CLEAR}"
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

echo -e "${BOLD}Press any key to continue${CLEAR}"
read -rsn1 key
tput cnorm
source ./config/text.sh

mkdir -p dbms 2>> ./.error.log
mkdir -p logs 2>> ./.error.log

function main {
		choice=0
		menu=(
		"1- Select Database"
		"2- Create Database"
		"3- Drop Database"                
		"4- Show Database"                
		"5- Exit"                         
		)
	while true; do
		clear
		tput civis
		echo -e "${BLUE}-------------Menu--------------${CLEAR}"
		#print menu
		for line in "${!menu[@]}"; do
			if [[ $line == $choice ]]; then
				echo -e "${GREEN}> ${menu[$line]} ${CLEAR}" # highlight choice
			else
				echo "${menu[$line]}"
			fi
		done
		echo -e "${BLUE}--------------------------------${CLEAR}"
		echo -e "${BLUE}Use ↑ ↓ to navigate, Enter to select${CLEAR}"
		read -rsn1 action
		if [[ $action == $'\x1b' ]]; then
			read -rsn2 action	
			case $action in
				"[A")  # Up arrow
					((choice--))
          			[[ $choice -lt 0 ]] && choice=$((${#menu[@]} - 1))
			    	;;
		        "[B")  # Down arrow
          			((choice++))
          			[[ $choice -ge ${#menu[@]} ]] && choice=0
          			;;
			esac
		elif [[ $action == "" ]]; then  # Enter pressed
			case $choice in 
				0) selectDB ;;
				1) createDB ;;
				2) dropDB ;;
				3) showDB ;;
				4) exit ;;
			esac
			break
		fi
	done
tput cnorm
}

function selectDB {
	echo -e "Database Name: \c"
	read nameDB
	if [[ ${#nameDB} -lt 2 ]]; then
		echo -e "${RED}Database name must be at least 2 characters.${CLEAR}"
		selectDB
		return
	fi
	cd ./dbms/$nameDB 2>> ./logs/.error.log
	if [[ $? == 0 ]]; then
        	echo "----------$nameDB Database---------"
        	#TODO: call the tables
	else
        	echo -e "${RED}Database $nameDB not found${CLEAR}"
			sleep 3
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
	mkdir ./dbms/$nameDB 2>>./logs/.error.log
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
	while true; do
		echo "Are you sure you want to drop $nameDB Database? y/n"
		read -in1 ans
		case $ans in
			[Yy]) deleteDB $nameDB
				break	;;
			[Nn]) break ;;
			*) echo "Invalid input. Please enter only 'y' or 'n'." ;;
		esac
	done
	main
}

function showDB {
	arrDB=$(ls ./dbms)
	x=1
	echo "-----------DATABASES---------"
	for db in $arrDB
	do
		echo "$x | $db"
		((x++))
	done
	echo "-----------------------------"
	read -rsn1 key
	main		
}

function deleteDB {
	file=./dbms/$1 
	if [[ -f $file ]] ; then 	
		rm -r $file 2>>./logs/.error.log
       		echo "$1 Deleted successfully"
		read -n1 key
	else 
		echo "ERROR: Database doesn't exist"
		read -n1 key
	fi
}



main
