## Getting and Cleaning Data Project

#### Overview

This project serves to demonstrate the collection and cleaning of data to create a tidy data set that can be used for subsequent analysis. A full description of the data used in this project can be found at The UCI Machine Learning Repository

#### Project Summary

The R script called run_analysis.R does the following: 
1. Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set 
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### Steps Performed for Tidy Data Generation

Section 1. Merge the training and the test sets to create one data set.

After setting the source directory for the files, read into tables the data located in

features.txt
activity_labels.txt
subject_train.txt
X_train.txt
y_train.txt
subject_test.txt
X_test.txt
y_test.txt
Assign column names and merge to create one data set.

Section 2. Extract only the measurements on the mean and standard deviation for each measurement.

Creates a vector that contains TRUE values for the ID, mean and stdev columns and FALSE values for the others. 
Subset this data to keep only the necessary columns.

Section 3. Use descriptive activity names to name the activities in the data set

Merges data subset with the activityType table to inlude the descriptive activity names

Section 4. Appropriately label the data set with descriptive activity names.

Uses gsub function for pattern replacement to clean up the data labels.

Section 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Generate a single data set with the average of each variable for each activity and subject.

#### Additional Information

Refer to the file CodeBook.MD for all information related to the variables.