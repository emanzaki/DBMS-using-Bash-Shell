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
"------------------Main Menu------------------"
"1- Select Database"
"2- Create Database"
"3- Drop Database"
"4- Show Database"
"5- Exit"
)

#tables menu
tableMenu=(
"------------------Tables Menu------------------"
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

#Datatype
typesMenu=(
"------------Choose column type--------------"
"int"
"string"
"bool"
)

#IsPK
pKeyMenu=(
"--------Is this column a Primary Key?--------"
"yes"
"no"
)

# Display title
clear
for line in "${title[@]}"; do
    echo -e "$line"
    sleep 0.1
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
	fi
	cd ./dbms/$nameDB 2>> ./logs/.error.log
	if [[ $? == 0 ]]; then
        	tableMenu
	else
        	echo -e "${RED}Database $nameDB not found${CLEAR}"
	fi
	returnToMainMenu main
}

function createDB {
	echo -e "Database Name: \c"
	read nameDB
	if [[ ${#nameDB} -lt 2 ]]; then
		echo -e "${RED}Database name must be at least 2 characters.${CLEAR}"
		createDB
	elif [[ -d ./dbms/$nameDB ]]; then
		echo -e "${RED}Database already exists.${CLEAR}"
		createDB
	fi
	mkdir ./dbms/$nameDB 2>>./logs/.error.log
	if [[ $? == 0 ]] ; then
		echo -e "${GREEN}Database Created Successfully.${CLEAR}"
		sleep 1
		cd ./dbms/$nameDB 2>>./logs/.error.log
		if [[ $? == 0 ]]; then
			tableMenu
		else
			echo -e "${RED}Error occurred selecting the $nameDB Database${CLEAR}"
		fi
	else
		echo -e "${RED}Error happend while creating your Database${CLEAR}"
	fi
	returnToMainMenu main

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
	returnToMainMenu main
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
	returnToMainMenu tableMenu
}

function createTable {
	echo -e "Table Name: \c"
	read tableName
	if [[ ${#tableName} -lt 2 ]]; then
		echo -e "${RED}Table name must be at least 2 characters${CLEAR}"
		createTable
	elif [[ -f $tableName ]]; then
		echo -e "${RED}Table already exist.${CLEAR}"
		returnToMainMenu tableMenu
	fi
	echo -e "Number of Columns:\c"
	read numCols
	if ! [[ $numCols =~ ^[0-9]+$ ]] || [[ $numCols -lt 1 ]]; then
		echo -e "${RED}Number of columns must be a positive number${CLEAR}"
		returnToMainMenu tableMenu
	fi
	echo "Column Name|Column Type|Primary Key" > $tableName 2>>../../logs/.error.log
	pkCount=1
	for ((i=1; i<=numCols; i++)); do
		pKey=""
		echo -e "Column $i Name: \c"
		read colName
		if [[ ${#colName} -lt 2 ]]; then
			echo -e "${RED}Column name must be at least 2 characters${CLEAR}"
			createTable
		fi
		echo "Choose column type"
		displayMenu typesMenu
		colType=$?
		case $colType in
			0) colType="int" ;;
			1) colType="string" ;;
			2) colType="bool" ;;
			*) echo -e "${RED}Error occurred${CLEAR}" ;;
		esac
		if [[ $pkCount -eq 1 ]]; then
			displayMenu pKeyMenu
			isPK=$?
			case $isPK in
				0)
				pKey="yes"
				pkCount=0
				;;
				1) pKey="" ;;
				*) echo -e "${RED}Error occurred${CLEAR}" ;;
			esac
		fi
		echo "$colName|$colType|$pKey" >> $tableName 2>>../../logs/.error.log
	done
	echo -e "${GREEN} $tableName Table created successfully${CLEAR}"
	returnToMainMenu tableMenu
	}
function displayMenu {
	local choice=1
	local menuName=$1
	local -n menu=$menuName #reference to menu array
	while true; do
        clear
        tput civis
        #print menu
		echo -e "${BOLD}${menu[0]}${CLEAR}"
		#fix the next line 

        for ((line=1; line<= ${#menu[@]}; line++)); do
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
                    [[ $choice -lt 1 ]] && choice=$((${#menu[@]} - 1))
                    ;;
                "[B")  # Down arrow
                    ((choice++))
                    [[ $choice -ge ${#menu[@]} ]] && choice=1
                    ;;
            esac
        elif [[ $action == "" ]]; then  # Enter pressed
			return $((choice - 1))
        fi
    done

	}

function returnToMainMenu {
	local menuName=$1
	echo -e "${BOLD}Press any key to go back to the previous menu..${CLEAR}"
	read -rsn1 key
	"$menuName"
}
main
