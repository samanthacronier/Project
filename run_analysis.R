# # run_analysis.R
# # S Cronier
# 
# This script does the following:
#   1.  Merges the training and the test sets to create one data set.
#   2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3.  Uses descriptive activity names to name the activities in the data set
#   4.  Appropriately labels the data set with descriptive variable names. 
#   5.  From the data set in step 4, creates a second, independent tidy data set with the average 
#       of each variable for each activity and each subject.

setwd("C:\\Users\\scronier\\Documents\\Coursera\\GettingData\\Project")

#these are the codes for the calculations
features = read.table("features.txt")  # read text file
features
subset(features, V2 =="mean()")

# codes for activities
activity_labels = read.table("activity_labels.txt")  # read text file
activity_labels


#read in test data
# subject codes
subject_test = read.table("test\\subject_test.txt")  
table(subject_test)

# activity codes
y_test = read.table("test\\y_test.txt")
head(y_test)

# data
X_test = read.table("test\\X_test.txt")
str(X_test)

# read in training data
# subject codes
subject_train = read.table("train\\subject_train.txt")  
table(subject_train)

# activity codes
y_train = read.table("train\\y_train.txt")
table(y_train)

# data
X_train = read.table("train\\X_train.txt")
str(X_train)

# bind the subject and activity ids to the data
X_train_id = cbind( subject = subject_train, activity = y_train, X_train)
X_test_id = cbind(subject = subject_test, activity = y_test, X_test)


# bind the test and train data together
data = rbind(X_train_id, X_test_id)


# make list of columns containing mean and std in name
keep = grep("mean|std", features[,2])
keep = c(keep, 562, 563)

# keep only mean and std columns, plus the activity and subject codes
msdata = data[keep,]
colnames(msdata)[1]= "subject"
colnames(msdata)[2]= "activity"

# recode the activities with words instead of numbers
library(plyr)
colnames(msdata)
?mapvalues
new = as.character(activity_labels[[2]])
msdata$acode <- mapvalues(msdata$activity, from = c(1:6), to = new)







library(reshape2)
?melt
?dcast
library(stringr) # regular expressions
?str_replace
?str_sub
?str_match
?str_split_fixed
library(plyr) # optional, but nice
?arrange

