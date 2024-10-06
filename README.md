# ChipInventory

## A simple lab inventory management system for integrated circuits and other usefull items. 

This system is written in node.js with express and pug.  The data is stored in a MySql database. 
The layout uses bootstrap CSS.

Includes data from the [ChipDb](https://www.msarnoff.org/chipdb/) project by Matt Sarnoff and it's 
source data [github repository](https://github.com/74hc595/chipdb).

# Installation
You will need a MySQL/Maria DB database server setup.  Use the .env file to hold the connection information
```
.env
MYSQL_HOST="127.0.0.1"
MYSQL_USER='chip_app'
MYSQL_PASSWORD=''
MYSQL_DATABASE='chip_data'
```

Download the git repository and in the directory do the following to load all the dependencies
```
npm install
```
This will install the dependencies in the project directory and should not impact any other projects.
