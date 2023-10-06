#### When initiating from new clone


### Manual Install Instructions ###

First try running setup.sh. This should install most dependencies and being running on port 5173. If this fails, follow the steps below.

- cd into the pipeline_visualizer_frontend directory
- npm install to install dependencies
- npm run build to build the project on port 5173
- cd into the pipeline-api directory
- npm install to install dependencies
- npm start to start the server on port 3000
- navigate to http://localhost:5173/ to view the project

#TODO: MongoDB install instructions and how to run on port 27017


### bitbucket CLI password walkthrough ###
navigate to bitbucket repository
click on Gear 
Personal bitbucket setting
click App Passwords 
Create App Password
Then give yourself appropriate permissions 
Submit
Enter password in CLI when prompted

## Local App Setup

### Vite/Vue3 Front End in pipeline_visualizer_frontend

- npm install
-npm run dev

Additional Vite/Vue3 Environment/Extension suggestions below

### Node.JS/Expres Back End in pipeline-api
- npm install
-npm start

### MongoDB Setup WINDOWS
install MongoDB Community (optional install compass GUI)
#  https://www.mongodb.com/try/download/community 

windows users are recommended to download and install the mongoDB Shell Mongosh
# https://www.mongodb.com/try/download/shell #

MongoDB Setup MAC

## Follow these steps to install MongoDB Community Edition using Homebrew's brew package manager. Be sure that you have followed the installation prerequisites above before proceeding.

Tap the MongoDB Homebrew Tap to download the official Homebrew formula for MongoDB and the Database Tools, by running the following command in your macOS Terminal:

- brew tap mongodb/brew

If you have already done this for a previous installation of MongoDB, you can skip this step.

To update Homebrew and all existing formulae:

- brew update

To install MongoDB, run the following command in your macOS Terminal application:

-brew install mongodb-community@6.0


## The installation includes the following binaries:

-The mongod server

-The mongos sharded cluster query router

- The MongoDB Shell, mongosh

You can also run MongoDB community by opening Compass running the docker command or running mongosh
docker run -d --name LOCAL_MONGO -p 27017:27017 mongo

## add pipelines database/pipelines collection via compassGUI or CLI
- use pipelines_db
- db.pipelines.insertOne({ key: "value" })

============================================================================================================

Basic Mongosh Commands
- mongosh : Open a connection to your local MongoDB instance. All other commands will be run within this mongosh connection.
- exit : exits mongosh

- show dbs : Show all databases in the current MongoDB instance
- use <dbname> : switch to db 
- db : shows current DB 
- use new_database : creates new DB 

- show collections : shows current collections
- db.createCollection("new_collection") : creates new collection
- db.new_collection.drop() : drops/deletes collection

for this app you would run 
- mongosh
- use pipelines
- db.createCollection("pipelines")

### GIT CLI WALK THROUGH ### 

git add . : Adds changes to the staging area.

git commit -m "message here": Commits changes to the repository.

git push: Pushes changes from a local repository to a remote repository used after git commit.

git status: Displays the current state of the repository.

git branch: Shows the current branches in the repository.

git checkout branch name : Switches to a different branch.

git merge: Merges one branch into another. Frequently git merge your-branch to merge to main

git pull branch-name: Fetches changes from a remote repository and merges them into the current branch.

git pull origin main: Fetches changes from a remote repository and merges them into the current branch.

git branch -d <branch-name>: deletes branch locally

git push <remote-name> --delete <branch-name> : deletes remote branch


### COMPONENT LIBRARY
https://quasar.dev/

###### Vite/Vue3 Readme ######
This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur) + [TypeScript Vue Plugin (Volar)](https://marketplace.visualstudio.com/items?itemName=Vue.vscode-typescript-vue-plugin).

## Type Support for `.vue` Imports in TS

TypeScript cannot handle type information for `.vue` imports by default, so we replace the `tsc` CLI with `vue-tsc` for type checking. In editors, we need [TypeScript Vue Plugin (Volar)](https://marketplace.visualstudio.com/items?itemName=Vue.vscode-typescript-vue-plugin) to make the TypeScript language service aware of `.vue` types.

If the standalone TypeScript plugin doesn't feel fast enough to you, Volar has also implemented a [Take Over Mode](https://github.com/johnsoncodehk/volar/discussions/471#discussioncomment-1361669) that is more performant. You can enable it by the following steps:

1. Disable the built-in TypeScript Extension
    1) Run `Extensions: Show Built-in Extensions` from VSCode's command palette
    2) Find `TypeScript and JavaScript Language Features`, right click and select `Disable (Workspace)`
2. Reload the VSCode window by running `Developer: Reload Window` from the command palette.

## Customize configuration

See [Vite Configuration Reference](https://vitejs.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Type-Check, Compile and Minify for Production

```sh
npm run build
```
###### Notes from Mon 5/1/23 ######
- Like to have some sort of auth  
- Api contract 
- Cognito for auth  
- Alarm klaxson  <!-- https://www.epidemicsound.com/track/8aajqP3fMD/ -->
- Repo settings  
- Access tokens  
- Create repo access token 
- Read privlege/ read write on web hooks 


### Notes for Ben ### 
- Crystal 
- Refactored services extract Pipelines function
- Added services function fetch pipeline steps
- update models
- added fetch single pipeline

- Kalon 
- Continued reasearch on Auth0
- Starting to implement in his branch

- Jesse 
- Continued learning Vue Framework 
- Continued learning GIT