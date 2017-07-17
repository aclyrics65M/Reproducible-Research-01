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

## Inserting the missing values
activity2 <- split(activity, activity$interval)
activity2 <- lapply(activity2, function(x) {
        x$steps[which(is.na(x$steps))] <- mean(x$steps, na.rm = TRUE)
        return(x)
})

## Calling the activity 2
activity2 <- do.call("rbind", activity2)
row.names(activity2) <- NULL

activity2 <- split(activity2, activity2$date)
df <- lapply(activity2, function(x) {
        x$steps[which(is.na(x$steps))] <- mean(x$steps, na.rm = TRUE)
        return(x)
})
activity2 <- do.call("rbind", activity2)
row.names(activity2) <- NULL
head(activity2)

library(reshape2)
activity_melt2 <- melt(activity2, id.vars = c("date", "interval"))
steps_sum <- dcast(activity_melt2, date ~ variable, sum, na.rm = TRUE)
head(steps_sum)


## Histogram of total number of steps taken with imputed missing values
hist(steps_sum$steps, main = "Histogram of total steps taken per day", 
     xlab = "Total steps per day", ylab = "Number of days", 
     breaks = 10, col = "steel blue")
abline(v = mean(steps_sum$steps), lty = 1, lwd = 2, col = "red")
abline(v = median(steps_sum$steps), lty = 2, lwd = 2, col = "black")
legend(x = "topright", c("Mean", "Median"), col = c("red", "black"), 
       lty = c(2, 1), lwd = c(2, 2))

## Number of rows with NA values
sum(is.na(activity$steps))

## Percentage of rows
sum(is.na(activity$steps))*100/nrow(activity)


## Statistical Differences within activity patterns
## Weekdays vs Weekends
library(lubridate)
weekends <- which(weekdays(as.Date(activity2$date)) == "Saturday" |
                          weekdays(as.Date(activity2$date)) == "Sunday")
weekdays <- which(weekdays(as.Date(activity2$date)) != "Saturday" &
                          weekdays(as.Date(activity2$date)) != "Sunday")
temp <- c(rep("a", length(activity2)))
temp[weekends] <- "weekend"
temp[weekdays] <- "weekday"
length(temp)
activity2 <- cbind(activity2, temp)
head(activity2)
names(activity2)[4] <- "day"

activity2split <- split(activity2, activity2$day)
stepsmean_interval <- lapply(activity2split, function(x) {
        temp <- aggregate(x$steps, list(x$interval), mean)
        names(temp) <- c("interval", "steps")
        return(temp)
})

## Unsplit stepsmean_interval
stepsmean_interval <- do.call("rbind", stepsmean_interval)
weekdays <- grep("weekday" ,row.names(stepsmean_interval))
weekends <- grep("weekend" ,row.names(stepsmean_interval))

## The temp functions
temp <- c(rep("a", length(stepsmean_interval$steps)))
temp[weekdays] <- "weekdays"
temp[weekends] <- "weekends"

## Obtaining the names of temp
names(temp) <- "day"
stepsmean_interval <- cbind(stepsmean_interval, temp)
row.names(stepsmean_interval) <- NULL

head(stepsmean_interval)

## Creating the Gplot
library(ggplot2)
ggplot(stepsmean_interval, aes(interval, steps)) + geom_line() + facet_grid(temp ~ .) 







