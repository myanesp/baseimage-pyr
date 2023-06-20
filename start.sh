#!/bin/bash

log_file="./log.txt"

if curl --output /dev/null --silent --fail "http://nitter:8080"; then
    echo "Nitter instance is running."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Nitter instance is running." >> "$log_file"
    
    # Python script
    echo "Downloading tweets from CercaniasMadrid account..."
    if python3 harvesting/download_tweets_and_replies.py; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Tweets downloaded successfully." >> "$log_file"
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Error occurred while downloading tweets." >> "$log_file"
    fi
    
    sleep 10
    
    # R scripts
    echo "Executing R scripts..."
    if Rscript processing/02-add_missing_tweets_days.R; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Tweets added successfully." >> "$log_file"
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Error occurred while adding tweets." >> "$log_file"
    fi
    
    sleep 5
    
    if Rscript processing/03-finding-issues.R; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Exported tweets with issues successfully." >> "$log_file"
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Error occurred while exporting tweets with issues." >> "$log_file"
    fi

    sleep 5

    if Rscript visualization/app.R; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Shiny dashboard launched successfully." >> "$log_file"
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Error occurred while launching Shiny dashboard." >> "$log_file"
    fi

    sleep 5
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") - All scripts executed successfully." >> "$log_file"
    
else
    echo "Nitter instance is not running. Please start the instance and try again."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Nitter instance is not running." >> "$log_file"
fi




