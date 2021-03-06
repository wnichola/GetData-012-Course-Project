## ------------------------------------------------------------------------

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


## ------------------------------------------------------------------------
## Metadata of activity_labels
str(activity_labels)
unique(activity_labels)

## Metadata of features
str(features)
nrow(unique(features))

## Metadata of x_train and x_test
dim(x_train)
dim(x_test)

## Percentage of Train and Test observations
nrow(x_train)/(nrow(x_train) + nrow(x_test)) * 100
nrow(x_test)/(nrow(x_train) + nrow(x_test)) * 100

## Metadata of y_train and y_test
str(y_train)
str(y_test)

## Unique values from y_train and y_test
unique(y_train)         # If values matches those in activities_labels, this could be the Activities
unique(y_test)

## Unique values from y_train and y_test
nrow(unique(y_train))   # If it is 6 unique observation, this could be the Activities
nrow(unique(y_test))    

## Metadata of subject_train and subject_test
str(subject_train)
str(subject_test)

## Unique values from subject_train and subject_test
unique(subject_train$V1)    # Are values between 1 to 30? If so, these are the subjects
unique(subject_test$V1)

## Number of unique values from subject_train and subject_test
length(unique(subject_train$V1))
length(unique(subject_test$V1))


## ------------------------------------------------------------------------

dim(body_acc_x_train)
dim(body_acc_x_test)

dim(body_acc_y_train)
dim(body_acc_y_test)

dim(body_acc_z_train)
dim(body_acc_z_test)

dim(body_gyro_x_train)
dim(body_gyro_x_test)

dim(body_gyro_y_train)
dim(body_gyro_y_test)

dim(body_gyro_z_train)
dim(body_gyro_z_test)

dim(total_acc_x_train)
dim(total_acc_x_test)

dim(total_acc_y_train)
dim(total_acc_y_test)

dim(total_acc_z_train)
dim(total_acc_z_test)


## ------------------------------------------------------------------------

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


## ----echo=FALSE----------------------------------------------------------

## Commented out the following as this is not required to be submitted
# write.csv(merge_df_all, file="merge_df_all.csv", quote=FALSE)


## ------------------------------------------------------------------------
## Retrieve columns that are means or standard deviations (std)
# Using only merge_df_main_all as the Inertial data would not have mean or 
# standard deviations given the column names are arbitrarily given.
mean_std_col <- names(merge_df_main_all)[grepl("mean|std", names(merge_df_main_all), ignore.case = TRUE)]

mean_std_col <- c("Subject_ID", "Activity", mean_std_col)

merge_df_select <- select(merge_df_main_all, one_of(mean_std_col))


## ----echo=FALSE----------------------------------------------------------

## Commented out the following as this is not to be submitted
# write.csv(merge_df_select, file="merge_df_select.csv", quote=FALSE)


## ------------------------------------------------------------------------

## Appropriately labels the data set with descriptive variable names. 
merge_df_select$Activity <- factor(merge_df_select$Activity,
                                   levels=activity_labels$Activity_ID,
                                   labels=activity_labels$Activity)


## ------------------------------------------------------------------------

## Creates an independent tidy data set with the average of each variable for each activity and each subject.

merge_select_means <- merge_df_select %>% group_by(Subject_ID, Activity) %>%
    summarise_each(funs(mean))


## ------------------------------------------------------------------------

## print(merge_select_means)
# write.csv(merge_select_means, file="merge_select_means.csv", quote=FALSE)

## Instead the following file would be created for submission: merge_tidy.txt
write.table(merge_select_means, file="merge_tidy.txt", row.name=FALSE)


