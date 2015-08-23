# # run_analysis.R
# # S Cronier
# 
# This script does the following:
#   1.  Merges the training and the test sets to create one data set.
#   2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3.  Uses descriptive activity names to name the activities in the data set
#   4.  Appropriately labels the data set with descriptive variable names. 
#   5.  From the data set in step 4, creates a second, independent tidy data set with the average 
#       of each variable for each activity and each subject. This data set is called "tidy"


### First load in all the data ####################

#these are code books
features = read.table("features.txt")  # read text file
activity_labels = read.table("activity_labels.txt")  # read text file

# subject codes
subject_test = read.table("test\\subject_test.txt")  
subject_train = read.table("train\\subject_train.txt") 

# activity codes
y_test = read.table("test\\y_test.txt")
y_train = read.table("train\\y_train.txt")

# data
X_test = read.table("test\\X_test.txt")
X_train = read.table("train\\X_train.txt")

##################################################

# rename the columnes with descriptive names
colnames(X_train) = features[[2]]
colnames(X_test) = features[[2]]

# bind the subject and activity ids to the data
X_train_id = cbind( subject = subject_train, activity = y_train, X_train)
X_test_id = cbind(subject = subject_test, activity = y_test, X_test)

# bind the test and train data together
data = rbind(X_train_id, X_test_id)

# make list of cols containing mean and std in name, plus the first two cols w/ids
keep = grep("mean|std", colnames(data))
keep = c(1,2,keep)

# keep only mean and std columns, plus the activity and subject codes
msdata = data[,keep]

# fix the names of the first two cols
colnames(msdata)[1]= "subject"
colnames(msdata)[2]= "activity"

# recode the activities with words instead of numbers
library(plyr)
new = as.character(activity_labels[[2]])
msdata$activity <- mapvalues(msdata$activity, from = c(1:6), to = new)

# melt the data into long form
meltdata <- melt(msdata, id.vars = c("subject", "activity"))

# cast the data into tidy form using the mean of each variable
tidy <- dcast(meltdata, subject+activity~variable, mean)

# final file
write.table(tidy, file="tidy.txt", row.names=FALSE)
