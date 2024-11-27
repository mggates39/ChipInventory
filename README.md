# ChipInventory

## A simple lab inventory management system for integrated circuits and other usefull items. 

This system is written in node.js with express and pug.  The data is stored in a MySql database. 
The layout uses bootstrap CSS.

Includes data from the [ChipDb](https://www.msarnoff.org/chipdb/) project by Matt Sarnoff and it's 
source data [github repository](https://github.com/74hc595/chipdb).

## Contributing Componet Defintions
If you wish to contribute componet defintions, they can be transfered via YAML files as described in the [contribution documentation](CONTRIBUTING.md).
Add any new YAML files to your fork and create a pull request back to here and they will become available for everyone.

# Installation
The application can be cloned from this git repository and then  a docker container with MySQL can be created.  The repository includes an initial database load of component defintions along with my inventory, location and project data.  The docker container is created with all the supporting data but none of the components.  Those will be imported via the YAML files after the container is created.

For all environments you start by getting the current code by either forking this repository or cloning it
``` BASH
cd {your development folder}
git clone https://github.com/mggates39/ChipInventory.git .
```

From here you can eitehr co the docker or non-docker route.
## Docker Container
### Setup the Environment
Create a file named .env in the root project folder to hold the docker container connection information.  Be sure to put in your desired database root and application passwords.  As this is a new instance of MySQL in the contaioner you can make up whatever passwords you wish.
```
NODE_LOCAL_PORT=3000
NODE_DOCKER_PORT=3000

MYSQL_LOCAL_PORT=3306
MYSQL_DOCKER_PORT=3306
MYSQL_HOST=mysqldb
MYSQL_USER='chip_app'
MYSQL_PASSWORD=''
MYSQL_DATABASE='chip_data'
MYSQL_ROOT_PASSWORD=''
```
If you need to change the exposed port for the database or application, update the necessary DOCKER_PORT entry.
### Create the Container
THe repository has all the Docker configuration files in place.  We use docker compose to build the container.
```
docker compose up
```
The application logs will show up in the terminal window that is now attached stdout of the application service.

Type <ctrl/C> to stop the services
and then 
```
docker compose down
```
to shut down the docker container.
### Load the initial component definitions
Browser to [localhost port 3000 /imports/all](http://localhost:3000/imports/all).

This will load all of the included component YAML files.

## Non-Docker Native Enironment
### Setup the Database
You will need a MySQL/Maria DB database server setup.

Using a tool such as MySQL Workbench, connect to the database server with an admin user and run these commands to create the initial database and application user.  
``` SQL
CREATE DATABASE chip_data;
CREATE USER 'chip_app'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE VIEW, SHOW VIEW ON chip_data.* TO `chip_app`@`localhost`;
FLUSH PRIVILEGES;
```
Be sure to note the actual password you use so you can put it in the .env file below.

### Setup the code
In the chipInventory directory do the following to load all the dependencies
```
npm install
```
This will install the dependencies in the project directory and should not impact any other projects.

Create a file named .env in the root project folder to hold the database connection information.  Be sure to put in the password you used when you created the chip_app user above.
```
NODE_LOCAL_PORT=3000

MYSQL_LOCAL_PORT=3306
MYSQL_HOST="127.0.0.1"
MYSQL_USER='chip_app'
MYSQL_PASSWORD='password'
MYSQL_DATABASE='chip_data'
```
### Load the initial data
The easiest way is to use MySQL Workbench and import the data from the project's database folder into the chip_data database.  The workbench handles creating all the schmas and loading the data while managing all of the foreign key relationships.

This will load all of the component definitions and all the supporting data.  It does not contains any inventory, location, or project related data.

### Launch the application
You can start the application with this command
```
npm run dev
```
Any errors and console logs will appear in the terminal window.
The system will restart it after every code change is saved.

# Application Instruction
The application can be reached in your browser on [localhost port 3000](http://localhost:3000).


![Image of the application main page in a browser](public/images/main_page.png "Main Page")

Here will be how to use the variious sections.
