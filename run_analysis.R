##########################################################################################################
##
## Created By        		Created			Last Updated
## Parama Bhattacharya		24-April-2015
##
## runAnalysis.r File Description:
##
## This script will perform the following steps on the UCI HAR Dataset downloaded from 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##
##########################################################################################################
# 1. Merges the training and the test sets to create one data set.

# Load the required libraries first
library(plyr) 
library(data.table)
library(dplyr)

# set working directory to the location where the UCI HAR Dataset was unzipped
setwd("C:/Parama/coursera/Getting_Cleaning_data/Project/")

# download the zip file in a temporary folder
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) 

# reads features.txt
features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"),header = FALSE)
# reads activity_labels.txt
activityType <- read.table(unzip(temp, "UCI HAR Dataset/activity_labels.txt"),header = FALSE) 

# Reads the Training Data
# reads subject_train.txt
subjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"),header = FALSE) 
# reads x_train.txt
xTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"),header = FALSE) 
# reads y_train.txt
yTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"),header = FALSE)

# Assigin column names to the Training data
colnames(activityType) = c("activityId","activityType")
colnames(subjectTrain) = "subjectId"
colnames(xTrain) = features[,2]
colnames(yTrain) = "activityId"

# Create a single Training data set by merging yTrain, subjectTrain and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain)

# Read the Test data
# Reads subject_test.txt
subjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"),header = FALSE)
# Reads x_test.txt
xTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"),header = FALSE)
# Reads y_test.txt
yTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"),header = FALSE)

# delete the temporary folder
unlink(temp)

# Assign column names to the Test data
colnames(subjectTest) = "subjectId"
colnames(xTest) = features[,2]
colnames(yTest) = "activityId"

# Create a single Test data set by merging the xTest, yTest and subjectTest
testData = cbind(yTest,subjectTest,xTest)

# Merge training and test data to create a single data set
mergedData = rbind(trainingData,testData)

# Create a vector for the column names from the mergedData
colNames  = colnames(mergedData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Create a Vector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
resultVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset mergedData table based on the Vector to keep only desired columns
mergedData = mergedData[resultVector==TRUE]

# 3. Uses descriptive activity names to name the activities in the data set

# Merge the data set obtained with the acitivityType table to include descriptive activity names
mergedData = merge(mergedData,activityType,by="activityId",all.x=TRUE)

# Updating the colNames to include the new column names after merge
colNames  = colnames(mergedData)

# 4. Appropriately labels the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StdDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","freq",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassigning the new descriptive column names to the mergedData set
colnames(mergedData) = colNames

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType  = mergedData[,names(mergedData) != "activityType"]

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
averageData = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c("activityId","subjectId")],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean)

# Merging the averageData with activityType to include descriptive activity names
averageData = merge(averageData,activityType,by="activityId",all.x=TRUE)

# Export the averageData set 
write.table(averageData, "./averageData.txt",row.names=FALSE,sep="\t")