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

selectTableMenu=(
"------------------Select Table------------------"
"1- Select All"
"2- Select Specific Column"
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
	returnToPreviousMenu main
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
	returnToPreviousMenu main

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
	returnToPreviousMenu main
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
	returnToPreviousMenu main
}

function deleteDB {
	file=./dbms/$1 
	if [[ -d $file ]] ; then 	
		rm -r $file 2>>./logs/.error.log
       		echo -e "${GREEN}$1 Database Deleted successfully${CLEAR}"
	else 
		echo -e  "${RED}ERROR: Database doesn't exist${CLEAR}"
	fi
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
		7) cd ../.. 2>>../../logs/.error.log
			main
			;;
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
	returnToPreviousMenu tableMenu
}

function createTable {
	echo -e "Table Name: \c"
	read tableName
	if [[ ${#tableName} -lt 2 ]]; then
		echo -e "${RED}Table name must be at least 2 characters${CLEAR}"
		createTable
	elif [[ -f $tableName ]]; then
		echo -e "${RED}Table already exist.${CLEAR}"
		returnToPreviousMenu tableMenu
	fi
	echo -e "Number of Columns:\c"
	read numCols
	if ! [[ $numCols =~ ^[0-9]+$ ]] || [[ $numCols -lt 1 ]]; then
		echo -e "${RED}Number of columns must be a positive number${CLEAR}"
		returnToPreviousMenu tableMenu
	fi
	echo "Column_Name|Column_Type|Primary_Key" > .$tableName 2>>../../logs/.error.log
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
		echo "$colName|$colType|$pKey" >> .$tableName 2>>../../logs/.error.log
		if [[ $i != $numCols ]]; then
			echo -n "$colName|" >> $tableName 2>>../../logs/.error.log
		else
			echo -ne "$colName\n" >> $tableName 2>>../../logs/.error.log
		fi
	done
	if [[ $? != 0 ]]; then
		echo -e "${RED}Error occurred while creating the table${CLEAR}"
		returnToPreviousMenu tableMenu
	fi
	echo -e "${GREEN} $tableName Table created successfully${CLEAR}"
	returnToPreviousMenu tableMenu
	}
function insertIntoTable {
	echo -e "Table Name: \c"
	read tableName
	
	if [[ ! -f $tableName ]]; then
		echo -e "${RED}Table doesn't exist.${CLEAR}"
		returnToPreviousMenu tableMenu
	fi

	# Extract metadata
	numCols=$(( 1 + $(head -n 1 ".$tableName" | grep -o "|" | wc -l) ))

	for ((j=1; j<numCols; j++)); do
		metaLine=$(sed -n "$((j + 1))p" ".$tableName")
		colNames[$j]=$(echo "$metaLine" | cut -d '|' -f 1)
		colTypes[$j]=$(echo "$metaLine" | cut -d '|' -f 2)
		pKeys[$j]=$(echo "$metaLine" | cut -d '|' -f 3)
		[[ -z ${pKeys[$j]} ]] && pKeys[$j]="no"
	done

	echo -e "Number of Rows: \c"
	read numRows

	for ((i=1; i<=numRows; i++)); do
		newRow=""
		rowValid=true
		for ((j=1; j<numCols; j++)); do
			echo -e "${BOLD}Column $j: ${colNames[$j]} (${colTypes[$j]})${CLEAR}"
			echo -e "${BOLD}Is this column a Primary Key? ${pKeys[$j]}${CLEAR}"
			echo -e "Row $i, Column ${colNames[$j]}: \c"
			read cellValue

			# Handle empty input
			if [[ -z $cellValue ]]; then
				if [[ ${pKeys[$j]} == "yes" ]]; then
					echo -e "${RED}Primary key cannot be empty.${CLEAR}"
					rowValid=false
					break
				else
					cellValue="null"
				fi
			fi

			# Validate type
			if [[ ${colTypes[$j]} == "int" ]]; then
				if ! [[ $cellValue =~ ^[0-9]+$ ]]; then
					echo -e "${RED}Invalid input. Please enter an integer.${CLEAR}"
					rowValid=false
					break
				fi
			elif [[ ${colTypes[$j]} == "bool" ]]; then
				if ! [[ $cellValue =~ ^(true|false)$ ]]; then
					echo -e "${RED}Invalid input. Please enter 'true' or 'false'.${CLEAR}"
					rowValid=false
					break
				fi
			fi

			# Validate primary key uniqueness
			if [[ ${pKeys[$j]} == "yes" ]]; then
				existingPK=$(awk -F'|' -v col=$j '{print $col}' "$tableName" | grep -w "$cellValue")
				if [[ -n $existingPK ]]; then
					echo -e "${RED}Primary key already exists in the table.${CLEAR}"
					rowValid=false
					break
				fi
			fi

			# Append to row string
			if [[ $j -lt $(($numCols - 1)) ]]; then
				if $j -eq 1; then
					newRow+="\n"
				fi
				newRow+="$cellValue|"
			else
				newRow+="$cellValue"
			fi
		done

		# Only append if loop wasn't broken (valid row)
		if [[ $rowValid == true ]]; then
			echo -e "$newRow" >> "$tableName" 2>>../../logs/.error.log
		else
			echo -e "${YELLOW}Row $i rejected. Please re-enter.${CLEAR}"
			((i--))
		fi
	done
	returnToPreviousMenu tableMenu
}


function selectFromTable {
	echo -e "Table Name: \c"
	read tableName
	if [[ ! -f $tableName ]]; then
		echo -e "${RED}Table doesn't exist.${CLEAR}"
		returnToPreviousMenu tableMenu
	fi

	displayMenu selectTableMenu
	choice=$?
	case $choice in
		0) selectAll $tableName;;
		1) selectSpecificColumn $tableName ;;
	esac
	returnToPreviousMenu tableMenu
}
function selectAll {
	local tableName=$1
	echo "-----------------"
	cat $tableName 2>>../../logs/.error.log
	echo "-----------------"
}
function selectSpecificColumn {
	local tableName=$1
	# Extract metadata
	numCols=$(( 1 + $(head -n 1 ".$tableName" | grep -o "|" | wc -l) ))
	colNames=
	echo "Choose a column to select:"
	for ((j=1; j<numCols; j++)); do
		metaLine=$(sed -n "$((j + 1))p" ".$tableName")
		colNames[$j]=$(echo "$metaLine" | cut -d '|' -f 1)
		echo "$j) ${colNames[$j]}"
	done

	echo -e "Column Number: \c"
	read colNum

	if [[ $colNum -lt 1 || $colNum -ge $numCols ]]; then
		echo -e "${RED}Invalid column number.${CLEAR}"
		returnToPreviousMenu tableMenu
	fi

	echo "-----------------"
	cut -d '|' -f $colNum $tableName 2>>../../logs/.error.log
	echo "-----------------"
}
function displayMenu {
	local choice=1
	local menuName=$1
	local -n menu=$menuName #reference to menu array
	while true; do
        clear
        tput civis
        #print menu
		echo -e "${BOLD}${menu[0]}${CLEAR}" #print menu title
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

function returnToPreviousMenu {
	local menuName=$1
	echo -e "${BOLD}Press any key to go back to the previous menu..${CLEAR}"
	read -rsn1 key
	"$menuName"
}
main
