#!/bin/bash

#displays error message if build fails
display.error() {
  echo "Error: $1" >&2
  exit 1
}

# Step 1: Clone the repo
git clone https://bitbucket.org/bpomerenkelabs/pipeline-visualizer/src/main/ app || display_error "Failed to clone the repository."

cd app

# Step 2: Install frontend dependencies
cd pipeline_visualizer_frontend
npm install || display_error "Failed to install frontend dependencies."

# Step 3: Build the frontend
npm run build || display_error "Failed to build the frontend."

# Step 4: Install backend dependencies
cd ../pipeline_api
npm install || display_error "Failed to install backend dependencies."

# Step 5: Set up MongoDB
# TODO: add commands here to install MongoDB (if it's not already installed), and start the MongoDB service. 
# The specific commands depend on your operating system, and our M2 macbooks especially had trouble
# running mongod, so perhaps this should be left off the script and left to the user to do manually.

# Step 6: Start the backend server
npm start || display_error "Failed to start the backend server."

# other? 
echo "Application setup complete!"
echo "You can access the applicaiton at htto://localhost:5173"
echo "MongoDB needs to be installed separately and running on port 27017"
echo "See README.md for more information"
