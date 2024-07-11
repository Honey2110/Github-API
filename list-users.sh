#!/bin/bash

##############
# Reason : To List the users including Admin of the github repository 
# 
# Inputs 
# Required in environment : Export your Github Username And Github Token
# Required in Arguments : Github Owner Name , Github Repositry Name 
#
# Owner : Swapnil Khandekar
##############


# helper if arguments passed are wrong 
helper()

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Function to help user to run this script 
function helper {
      local list_of_arguments=2
      
      if[ $# -ne $list_of_arguments ];
            then 
                  echo "Please provide arguments needed"
                  echo "Below list of argumenst and inputs needed to run this script"
                  echo "Export your github username and github token "
                  echo "Pass Github Owner Name and Repo Name of which you have to list"
      fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access