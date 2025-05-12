# Bash-Based DBMS

## 📌 Overview

This project is a simple **Database Management System (DBMS)** built entirely using **Bash scripting**. It provides basic functionalities to create, manage, and manipulate databases and tables via the Linux terminal—mimicking some SQL-like behavior using plain text files and directories.

## 🛠 Features

* Create and delete databases
* Create and drop tables
* Insert, select, and delete records
* Enforce data types (e.g., string, integer)
* Primary key constraint support
* Command-line menu interface

## 📁 Project Structure

```
project-root/
│
├── DBMS.sh               # Main script file to run the system
├── config                # Configuration folder for script
│   └── text.sh           
├── databases/            # Folder where databases (directories) are stored
│   └── sample_db/        # Each database is a folder with table files inside
│       └── users         # Table file with schema and records
└── README.md             # Project documentation (this file)
```

## 🧪 Requirements

* Linux/Unix system
* Bash (version 4 or later recommended)
* No external dependencies

## 🚀 How to Run

1. Clone the repository:

   ```bash
   git clone https://github.com/emanzaki/DBMS-using-Bash-Shell
   cd bash-dbms
   ```

2. Make the script executable:

   ```bash
   chmod +x DBMS.sh
   ```

3. Run the script:

   ```bash
   ./DBMS.sh
   ```

## 🎮 Usage

The system provides a menu-driven interface:

* Select/Create a database
* Create/Drop a table
* Insert/Select/Delete rows from a table

Example of a command-line interaction:

```
               ██████╗ ██████╗ ███╗   ███╗███████╗
                ██╔══██╗██╔══██╗████╗ ████║██╔════╝
                ██║  ██║██████╔╝██╔████╔██║███████╗
                ██║  ██║██╔══██╗██║╚██╔╝██║╚════██║
                ██████╔╝██████╔╝██║ ╚═╝ ██║███████║
                ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
                        Welcome to the DBMS        
                -----------------------------------------
                        Author : Eman Zaki
                        Role   : DevOps Engineer
                        Project: Bash-based DBMS System
                        GitHub : github.com/emanzaki
                -----------------------------------------


Press any key to continue
```

## 🧩 Implementation Notes

* Tables are stored as text files with a hidden file as metadata (column names, data types).
* Input validation is done through basic regex and built-in Bash tools (e.g., `awk`, `sed`).


## 📄 License

This project is open-source and available under the MIT License.
