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

#Database menu
mainMenu=(
"1- Select Database"
"2- Create Database"
"3- Drop Database"
"4- Show Database"
"5- Exit"
)

#tables menu
tableMenu=(
"1- Show Existing Tables"
"2- Create New Table"
"3- Insert Into Table"
"4- Select From Table"
"5- Update Table"
"6- Delete From Table"
"7- Drop Table"
"8- Back to Main Menu"
"9- Exit"
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
	tput civis
	displayMenu mainMenu
	choice=$?
	case $choice in 
		0) selectDB ;;
		1) createDB ;;
		2) dropDB ;;
		3) showDB ;;
		4) exit ;;
		*) echo -e "${RED}Error occurred${CLEAR}"
	esac	
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
        	tableMenu
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
		echo -e "${RED}Database name must be at least 2 characters.${CLEAR}"
		createDB
		return
	fi
	mkdir ./dbms/$nameDB 2>>./logs/.error.log
	if [[ $? == 0 ]] ; then
		echo -e "${GREEN}Database Created Successfully.${CLEAR}"
		sleep 1
		#TODO: add the menu to the tables 
	else
		echo -e "${RED}Error happend while creating your Database${CLEAR}"
		sleep 2
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
			*) echo -e "${RED}Invalid input. Please enter only 'y' or 'n'.${CLEAR}" ;;
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
	echo -e "${BOLD}Press any key to go back to the main menu..${CLEAR}"
	read -rsn1 key
	main		
}

function deleteDB {
	file=./dbms/$1 
	if [[ -d $file ]] ; then 	
		rm -r $file 2>>./logs/.error.log
       		echo -e "${GREEN}$1 Database Deleted successfully${CLEAR}"
	else 
		echo -e  "${RED}ERROR: Database doesn't exist${CLEAR}"
	fi

		read -n1 key
}


function tableMenu {

	tput civis
	displayMenu tableMenu
	choice=$?
	case $choice in 
		0) showTables ;;
		1) createTable ;;
		2) insertIntoTable ;;
		3) selectFromTable ;;
		4) updateTable ;;
		5) deleteFromTable ;;
		6) dropTable ;;
		7) main ;;
		8) exit ;;
		*) echo -e "${RED}Error occurred${CLEAR}"
	esac	
	tput cnorm

}

function showTables {
	tables=$(ls .)
	echo "-----------------"
	for table in $tables; do
		echo "$table"
	done
	echo "-----------------"
}

function createTable {
	echo -e "Table Name: \c"
	read tableName
	if [[ $tableName -lt 2 ]]; then
		echo -e "${RED}Table name must be at least 3 characters"
	elif [[ -f $tableName ]]; then
		echo -e "${RED}Table already exist, Please choose another name${CLEAR}"
		tableMenu
	fi
	echo -e "Number of Columns:"
	read num
	
	}
function displayMenu {
	local choice=0
	local menuName=$1
	local -n menu=$menuName #reference to menu array
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
			return $choice
        fi
    done

	}
main
