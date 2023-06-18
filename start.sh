#!/bin/bash

log_file="./log.txt"

if curl --output /dev/null --silent --fail "http://localhost:8080"; then
    echo "Nitter instance is running."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Nitter instance is running." >> "$log_file"
    
    # Python script
    echo "Downloading tweets from CercaniasMadrid account..."
    python harvesting/download_tweets_and_replies.py
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Tweets downloaded succesfully." >> "$log_file"
    
    sleep 10
    
    # R scripts
    echo "Executing R scripts..."
    Rscript processing/02-add_missing_tweets_days.R
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - tweets added successfully." >> "$log_file"
    
    sleep 5
    
    Rscript processing/03-finding-issues.R
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - exported tweets with issues successfully." >> "$log_file"

    sleep 5

    Rscript visualization/app.R 

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Shiny dashboard launched successfully." >> "$log_file"

    sleep 5
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - All scripts executed successfully." >> "$log_file"
    
else
    echo "Nitter instance is not running. Please start the instance and try again."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Nitter instance is not running." >> "$log_file"
fi



