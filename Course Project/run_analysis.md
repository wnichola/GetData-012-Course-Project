---
title: "getdata-012: Getting and Cleaning Data Course Project"
author: "Nicholas Wee"
date: "Thursday, March 12, 2015"
output: html_document
---
# Overview
The purpose of this R markdown file is to document the the metadata analysis, assumptions and process of Getting and Cleaning the dataset into a single data file as the submission requirements for this project.

The R codes within this Markdown will subsequently be extracted and placed into the run_analysis.R for submission purpose.  

# Loading the data for metadata analysis
As there are no proper column labels or documentation on the data contained within each file and its stucture, there is a need to generate some metadata on the dataset to understand how these files are related to each other, so as to define the strategy to merge them.  Also, there is a need to document some of the assumptions made about the files' structure, and thus the approach in assigning the labels to each column for the final output file.


```r
## Load the libraries
library(data.table)
library(dplyr)
library(RCurl)

## Download the file from the URL provided in the project brief
if (!file.exists("./data")) dir.create("./data")

if (!file.exists("./data/UCI HAR Dataset")) {
    fileURL <- 
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    targetURL <- "./data/UCI HAR Dataset.zip"
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL, exdir="./data")
}

## Read all the data files into memory

# Read reference files
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", 
                              header=FALSE, quote="\"", 
                              stringsAsFactors=FALSE)
features <- read.table("./data/UCI HAR Dataset/features.txt",
                       header=FALSE, quote="\"")

# Read training data files
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", 
                      header=FALSE, quote="\"")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", 
                      header=FALSE, quote="\"")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", 
                            header=FALSE, quote="\"")

# Read training Inertial data files
total_acc_z_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt",
               header=FALSE, quote="\"")
total_acc_y_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt",
               header=FALSE, quote="\"")
total_acc_x_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt",
               header=FALSE, quote="\"")
body_gyro_z_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt",
               header=FALSE, quote="\"")
body_gyro_y_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt",
               header=FALSE, quote="\"")
body_gyro_x_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt",
               header=FALSE, quote="\"")
body_acc_z_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt",
               header=FALSE, quote="\"")
body_acc_y_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt",
               header=FALSE, quote="\"")
body_acc_x_train <- 
    read.table("./data/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt",
               header=FALSE, quote="\"")

# Read testing data files
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", 
                      header=FALSE, quote="\"")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", 
                      header=FALSE, quote="\"")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", 
                            header=FALSE, quote="\"")

# Read testing Inertial data files
total_acc_z_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt",
               header=FALSE, quote="\"")
total_acc_y_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt",
               header=FALSE, quote="\"")
total_acc_x_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt",
               header=FALSE, quote="\"")
body_gyro_z_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt",
               header=FALSE, quote="\"")
body_gyro_y_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt",
               header=FALSE, quote="\"")
body_gyro_x_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt",
               header=FALSE, quote="\"")
body_acc_z_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt",
               header=FALSE, quote="\"")
body_acc_y_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt",
               header=FALSE, quote="\"")
body_acc_x_test <- 
    read.table("./data/UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt",
               header=FALSE, quote="\"")
```
## Generate the metadata for analysis and comparing with information we already have.
### Information provided in the project
1.  Number of Subjects: 30
2.  Data apportionment between Training and Test:  70% & 30%
3.  Number of Feature Domain Variables (with time & frequency): 561
4.  Number of Activities measured: 9
5.  Total number of samples (readings/window) for GIRO sensor in body_giro_xyz (3 separate files): 128 per record
6.  Total number of samples (readings/window) for Acceleration sensor body_acc_xyz (3 separate files): 128 per record
7.  Total number of samples (readings/window) for Triaxial acceleration from the accelerometer total_acc_xyz (3 separate files): 128 per record

### Information dervied from above
1.  Number of Subjects in Training (70% of 30 Subjects):    21
2.  Number of Subjects in test (30% of 30 Subjects): 9

### Metadata that can be derived from the datasets provided
The following outlines the key observations made on the dataset provided. It does not 
contain all observations made, just those that provides the background rationale
on the assumptions that needs to be made to support the consolidation of the various
dataset files into a single data file  

#### Generating metadata from the first two folder levels of datasets provided

```r
## Metadata of activity_labels
str(activity_labels)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6
##  $ V2: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
```

```r
unique(activity_labels)
```

```
##   V1                 V2
## 1  1            WALKING
## 2  2   WALKING_UPSTAIRS
## 3  3 WALKING_DOWNSTAIRS
## 4  4            SITTING
## 5  5           STANDING
## 6  6             LAYING
```

```r
## Metadata of features
str(features)
```

```
## 'data.frame':	561 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 ...
```

```r
nrow(unique(features))
```

```
## [1] 561
```

```r
## Metadata of x_train and x_test
dim(x_train)
```

```
## [1] 7352  561
```

```r
dim(x_test)
```

```
## [1] 2947  561
```

```r
## Percentage of Train and Test observations
nrow(x_train)/(nrow(x_train) + nrow(x_test)) * 100
```

```
## [1] 71.38557
```

```r
nrow(x_test)/(nrow(x_train) + nrow(x_test)) * 100
```

```
## [1] 28.61443
```

```r
## Metadata of y_train and y_test
str(y_train)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
str(y_test)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
## Unique values from y_train and y_test
unique(y_train)         # If values matches those in activities_labels, this could be the Activities
```

```
##     V1
## 1    5
## 28   4
## 52   6
## 79   1
## 126  3
## 151  2
```

```r
unique(y_test)
```

```
##     V1
## 1    5
## 32   4
## 56   6
## 80   1
## 110  3
## 134  2
```

```r
## Unique values from y_train and y_test
nrow(unique(y_train))   # If it is 6 unique observation, this could be the Activities
```

```
## [1] 6
```

```r
nrow(unique(y_test))    
```

```
## [1] 6
```

```r
## Metadata of subject_train and subject_test
str(subject_train)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
```

```r
str(subject_test)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
```

```r
## Unique values from subject_train and subject_test
unique(subject_train$V1)    # Are values between 1 to 30? If so, these are the subjects
```

```
##  [1]  1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
```

```r
unique(subject_test$V1)
```

```
## [1]  2  4  9 10 12 13 18 20 24
```

```r
## Number of unique values from subject_train and subject_test
length(unique(subject_train$V1))
```

```
## [1] 21
```

```r
length(unique(subject_test$V1))
```

```
## [1] 9
```
### Analysis of Metadata of the first two folder levels of datasets
1.  "activity_labels" contains all the activities being measured
2.  There is a unique numeric value (integer) assigned to each activity label - this potentially would be an index value for the activity.  And can be used to link to the data.
3.  "features" contains all the features being measured or calculated in total 561
4.  There is a unique numeric value (integer) assigned to each feature - this potentially would be an index value for the feature.  And can be used to link to the data.
5.  There are 7352 observations and 561 variables in X_train file.  The number of variables matches the number of features being measured or calculated.  However, there is no column headers to denote which column is for which feature.
6.  There are 2947 observations and 561 variables in X_test file. The number of variables matches the number of features being measured or calculated.   However, there is no column headers to denote which column is for which feature.
7.  There are **no** potential index values found in both X_train and X_test files, based on sample data shown.
8.  The number of observations in X_train and X_test files are approximately 70%/30% (respectively) of the total observations made in both files
9.  There are 7532 obseravtions of 1 variable in y_train, and 2947 observations of 1 variable in y_test file.
10. There are 6 unique values ranging from 1 to 6 in both y_train and y_test files.  Potentially, each of this would reference the index found in the activity_labels file.
11. Also, as there are matching number of observations between y_train with x_train, and y_test with x_test, potentially, each observation in the "y" files would match one observation in the "X" files.  However, there are no key in the "X" files to determine which observation in it would match which observation in the "y" files.  An assumption would need to be made here to link these two set of files.
12.  There are 7352 observations of 1 variable made in subject_train file, and 2947 observations of 1 variable made in the subject_test files.
10. There are 21 unique values ranging from 1 to 30 in subject_train file, and 9 unique values ranging from 2 to 24.  Given that there are 30 Subjects in this experiment, potentially, each of these unique value (subject_train and subject_test) refers to a Subject.
11. Also, as there are matching number of observations between the "subject" files with the "X" set of files, potentially each of this observation matches an observation in the "X" set of files.  However, there are no key in the "X" files to determine which observation in it would match the Subject identifier in the "subject" files.  An assumption would need to be made here to link these two set of files.  
   
#### Generating metadata from the third folder level of datasets provided

```r
dim(body_acc_x_train)
```

```
## [1] 7352  128
```

```r
dim(body_acc_x_test)
```

```
## [1] 2947  128
```

```r
dim(body_acc_y_train)
```

```
## [1] 7352  128
```

```r
dim(body_acc_y_test)
```

```
## [1] 2947  128
```

```r
dim(body_acc_z_train)
```

```
## [1] 7352  128
```

```r
dim(body_acc_z_test)
```

```
## [1] 2947  128
```

```r
dim(body_gyro_x_train)
```

```
## [1] 7352  128
```

```r
dim(body_gyro_x_test)
```

```
## [1] 2947  128
```

```r
dim(body_gyro_y_train)
```

```
## [1] 7352  128
```

```r
dim(body_gyro_y_test)
```

```
## [1] 2947  128
```

```r
dim(body_gyro_z_train)
```

```
## [1] 7352  128
```

```r
dim(body_gyro_z_test)
```

```
## [1] 2947  128
```

```r
dim(total_acc_x_train)
```

```
## [1] 7352  128
```

```r
dim(total_acc_x_test)
```

```
## [1] 2947  128
```

```r
dim(total_acc_y_train)
```

```
## [1] 7352  128
```

```r
dim(total_acc_y_test)
```

```
## [1] 2947  128
```

```r
dim(total_acc_z_train)
```

```
## [1] 7352  128
```

```r
dim(total_acc_z_test)
```

```
## [1] 2947  128
```

### Analysis of Metadata of the third folder level of datasets
1.  There are 3 sets of files here, each represent either an X, Y, or Z axis of the gyro, accelerator (body estimate) and acceleration(triaxial)
2.  Each of the 9 files in "train" folder and 9 files in "test" folder consist of 128 columns - potentially representing each of the sample taken in a reading window.
3.  There are 7352 observations in each of 9 files in "train" folder, and 2947 observations in each of the 9 files in the "test" folder.  Potentially, each record matches one observation in the "X" files found in the second folder level of datasets. However, there also no identifiers available to match the records.

## Assumptions for combining the datasets into a file (based on the above observations)
1.  The 561 columns in the "X" set of files are measurements of the features found in features data, and each column number corresponds to each row number in the features data.  That is, column 1 in a "X" file is the measure for row 1 in the "features" file, column 2 in "X" file is the measure for row 2 in the "features" file, and so forth until column 561 in a "X" file is the measure for row 561 in the "features" file.
2.  The values in "y" files corresponds to the "index" value found in the activity_label file. For example, if the value in a "y" file (column 1) is 5, it refers to the activity "STANDING", or a value of 2 would refer to the activity "WALKING_UPSTAIRS", and so forth.
3.  As there are no matching key to link the X and Y files, and given that the number of observations in the "y" files corresponds to the number of observations in the "X" files, it is assumed that each row (number) of observation in "X" files corresponds to the same row (number) of observation in "y" file.  So row 1 of X_train would correspond (and linked) to row 1 of y_train.
4.  Given that there are 30 unique values in the "subject" files, each unique value refers to the Subject identifier.
5.  As there are no matching key to link the X and Y files, and given that the number of observations in the "subject files corresponds to the number of observations in "X" files, it is assumed that each row in "subject" files corresponds (and linked) to the same row in "X" files.  That is row 1 in subject_train would correspond to row 1 in X_train, and so forth.
6.  As there are 128 columns in the files from the third level folders (Inertial), and there are 128 reading/windows, it is assumed that each column refers to a reading/window for that sensor axis of x, y, and z.
7.  As there are the same number of observations for each of the files to the number of observations in the respective "X" files (X_train and X_test), it is assumed that each row in these Inertial files corresponds (and linked to ) each row in their respective "X" files.

## Resulting Design for the single data file
The resulting combined file would consist of the following columns:  
1.  Subject ID (1) - from "subject" files,  
2.  Activity (1) - from "y" files,  
3.  Features (561) - from "X" files,  
4.  Body_Giro (128 x 3) - from "body_giro_" x, y, and z files,  
5.  Body_Acc (128 x 3) - from "body_acc_" x, y, and z files,  
6.  Total_Acc (128 x 3) - from "total_acc_" x, y and z files  
  
In total, there will be 1715 columns.
  
The total number of observations would be 7352 + 2947 = 10299 observations  
  
## Resulting Design for the Tidy data file
As the project calls for submission of the mean and standard deviation variables, this would automatically exclude data from the Inertial data, as these are readings from the 128 windows.  The resulting merge and summarised file would consist of only the following columns:  
1.  Subject ID (1) - from "subject" files,  
2.  Activity (1) - from "y" files factored with labels from activity_labels,  
3.  Means and Standard Deviation of Features (86 features) - from both "X" files  
  
Please refer to codebook.md for the Data Dictionary of the Tidy data file.  
  
The following R code provides the code to combine and generate the file based on the above designs:

```r
## Common functions to be used

# Set names
set_colnames <- function (x, newnames) {
    oldnames <- names(x)
    setnames(x, oldnames, newnames)
}

# Merge data frames so that the row orders are not changed after the merge.
# This is done by creating an new column row_id and merging based on that row_id.
# Then the row_id is removed.  From analysis of the data files, there are no column
# with the name row_id.
merge_by_row <- function(x, y, ...) {
    add_id <- function(data) {
        data.frame(data, rec_id = seq_len(nrow(data)))
    }
    remove_id <- function(data) {
        data_col <- colnames(data) != "rec_id"
        data[, data_col]
    }
    tmp_x <- add_id(x)
    tmp_y <- add_id(y)
    tmp_xy <- merge(tmp_x, tmp_y)
    remove_id(tmp_xy)
}

## Start by setting the column names first for the key datasets
set_colnames(subject_train, "Subject_ID")
set_colnames(subject_test, "Subject_ID")

set_colnames(y_train, "Activity")
set_colnames(y_test, "Activity")

# Set the activity_labels column names to match for y_train and y_test header
# to facilitate merging later.
set_colnames(activity_labels, c("Activity_ID", "Activity"))

## Strip away special characters in features' names
feature_names <- gsub("\\.", "_", make.names(features$V2))

set_colnames(x_train, as.vector(feature_names))
set_colnames(x_test, as.vector(feature_names))

# Arbitrarily set the column names for each senor data for the 128 reading windows.

inertial_labels <-  as.vector(paste("body_gyro_x_", as.character(seq_len(128)), sep=""))
set_colnames(body_gyro_x_train, inertial_labels)
set_colnames(body_gyro_x_test, inertial_labels)

inertial_labels <-  as.vector(paste("body_gyro_y_", as.character(seq_len(128)), sep=""))
set_colnames(body_gyro_y_train, inertial_labels)
set_colnames(body_gyro_y_test, inertial_labels)

inertial_labels <-  as.vector(paste("body_gyro_z_", as.character(seq_len(128)), sep=""))
set_colnames(body_gyro_z_train, inertial_labels)
set_colnames(body_gyro_z_test, inertial_labels)

inertial_labels <-  as.vector(paste("body_acc_x_", as.character(seq_len(128)), sep=""))
set_colnames(body_acc_x_train, inertial_labels)
set_colnames(body_acc_x_test, inertial_labels)

inertial_labels <-  as.vector(paste("body_acc_y_", as.character(seq_len(128)), sep=""))
set_colnames(body_acc_y_train, inertial_labels)
set_colnames(body_acc_y_test, inertial_labels)

inertial_labels <-  as.vector(paste("body_acc_z_", as.character(seq_len(128)), sep=""))
set_colnames(body_acc_z_train, inertial_labels)
set_colnames(body_acc_z_test, inertial_labels)

inertial_labels <-  as.vector(paste("total_acc_x_", as.character(seq_len(128)), sep=""))
set_colnames(total_acc_x_train, inertial_labels)
set_colnames(total_acc_x_test, inertial_labels)

inertial_labels <-  as.vector(paste("total_acc_y_", as.character(seq_len(128)), sep=""))
set_colnames(total_acc_y_train, inertial_labels)
set_colnames(total_acc_y_test, inertial_labels)

inertial_labels <-  as.vector(paste("total_acc_z_", as.character(seq_len(128)), sep=""))
set_colnames(total_acc_z_train, inertial_labels)
set_colnames(total_acc_z_test, inertial_labels)

## Merge all the train data
# merge main train data
merge_df_main_train <- merge_by_row (subject_train, y_train)
merge_df_main_train <- merge_by_row (merge_df_main_train, x_train)

# merge inertial train data
merge_df_train_all <- merge_by_row (merge_df_main_train, body_gyro_x_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, body_gyro_y_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, body_gyro_z_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, body_acc_x_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, body_acc_y_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, body_acc_z_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, total_acc_x_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, total_acc_y_train)
merge_df_train_all <- merge_by_row (merge_df_train_all, total_acc_z_train)

## Merge all the test data
# merge main test data
merge_df_main_test <- merge_by_row (subject_test, y_test)
merge_df_main_test <- merge_by_row (merge_df_main_test, x_test)

# merge inertial test test
merge_df_test_all <- merge_by_row (merge_df_main_test, body_gyro_x_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, body_gyro_y_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, body_gyro_z_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, body_acc_x_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, body_acc_y_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, body_acc_z_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, total_acc_x_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, total_acc_y_test)
merge_df_test_all <- merge_by_row (merge_df_test_all, total_acc_z_test)

## Merge both Train and Test files into a single dataset

merge_list <- list(merge_df_train_all, merge_df_test_all)
merge_df_all <- rbindlist(merge_list)

merge_list <- list(merge_df_main_train, merge_df_main_test)
merge_df_main_all <- rbindlist(merge_list)
```
The merged train and test datasets, including Inertial data, are in the dataset: merge_df_all.  

The merged train and test datasets, excluding Inertial data, are in the dataset: merge_df_main_all.  This will be used to generate the final Tidy data file.  


Extracting only the measurements on the mean and standard deviation for each measurement for all the features, such as acceleration, angle, jerk, etc..


```r
## Retrieve columns that are means or standard deviations (std)
# Using only merge_df_main_all as the Inertial data would not have mean or 
# standard deviations given the column names are arbitrarily given.
mean_std_col <- names(merge_df_main_all)[grepl("mean|std", names(merge_df_main_all), ignore.case = TRUE)]

mean_std_col <- c("Subject_ID", "Activity", mean_std_col)

merge_df_select <- select(merge_df_main_all, one_of(mean_std_col))
```
The extracted measurements on the mean and standard deviation is now in the data set: merge_df_select.  


Changing the numeric activity values to appropriate labels found in activity_labels.  Assuming that 
each number corresponds to number in that file. 


```r
## Appropriately labels the data set with descriptive variable names. 
merge_df_select$Activity <- factor(merge_df_select$Activity,
                                   levels=activity_labels$Activity_ID,
                                   labels=activity_labels$Activity)
```

Creating a new tidy data set with the average of each variable for each activity and each subject


```r
## Creates an independent tidy data set with the average of each variable for each activity and each subject.

merge_select_means <- merge_df_select %>% group_by(Subject_ID, Activity) %>%
    summarise_each(funs(mean))
```
## Final Data File Generated
The new dataset is: merge_tidy.txt.  
This file contains all the averages of the means and standard deviations of all the features of accelertion, gyro, jerk, etc, group by the Subject and the Activity.
  

```r
## print(merge_select_means)
# write.csv(merge_select_means, file="merge_select_means.csv", quote=FALSE)

## Instead the following file would be created for submission: merge_tidy.txt
write.table(merge_select_means, file="merge_tidy.txt", row.name=FALSE)
```
  

## Code Book
Please refer to the codebook.md for the generated file's fields.

  
