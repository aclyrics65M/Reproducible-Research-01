## Loading, unzipping, and reading the file
## setting the work directory
setwd("C:\\Users\\Faraz\\Desktop\\Coursera Data Science Course Sequences\\Course 05 Reproducible Research\\Project 01\\")

## URL file
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
testFile <- "step_data.zip"

## Downloading the file
download.file(url, testFile)
unzip(testFile)

## Creating the activity
activity <- read.csv("activity.csv", sep = ",")

## The structure of the data taking away the rows with NA steps
names(activity)
str(activity)
head(activity[which(!is.na(activity$steps)), ])



