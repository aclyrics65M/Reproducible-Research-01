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

## The Mean (average) of the "total number of steps taken" over all days
library(reshape2)
activity_melt <- melt(activity[which(!is.na(activity$steps)), ], id.vars = c("date", "interval"))

head(activity_melt)
steps_sum <- dcast(activity_melt, date ~ variable, sum)
head(steps_sum)

## Summary of the Data
summary(steps_sum$steps)


## Histogram of total number of steps taken sans NA rows. Showing mean and median of the data.
hist(steps_sum$steps, main = "Histogram of the Total steps Taken Per Day", xlab = "Total steps per day", ylab = "Number of days", 
     breaks = 10, col = "steel blue")
abline(v = mean(steps_sum$steps), lty = 1, lwd = 2, col = "red")
abline(v = median(steps_sum$steps), lty = 2, lwd = 2, col = "black")
legend(x = "topright", c("Mean", "Median"), col = c("red", "black"), lty = c(1, 2), lwd = c(2, 2))

## The average daily activity pattern
stepsMeanInterval <- dcast(activity_melt, interval ~ variable, mean, na.rm = TRUE)
head(stepsMeanInterval)
plot(stepsMeanInterval$interval, stepsMeanInterval$steps, ty = "l", xlab = "time interval", ylab = "Average steps", 
     main = "Average steps taken over all days vs \n time interval")
maxsteps_interval <- stepsMeanInterval$interval[which.max(stepsMeanInterval$steps)]
maxsteps_interval






