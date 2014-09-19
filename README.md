Rosemary - Course Project for Getting and Cleaning Data
========================================================

## Introduction
run_analysis.R performs analysis on the [UCI HAR Dataset]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
formed by collecting data from thirty subjects performing six activities, 
namely walking, walking upstairs, walking downstairs, sitting, standing and 
laying.

## Instructions
- Download the UCI HAR Dataset from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
- Extract the dataset. A folder named UCI HAR Dataset will be created.
- Set the UCI HAR Dataset as the working directory. This can be done by using
the setwd() command in R.
- Please do not change any file names. 
- run_analysis.R makes use of the "plyr" package. This can be installed by 
the command `install.packages("plyr")`. The script loads it when needed.

## Working

### Step 1
The *test* dataset is created. `X_test` holds the data collected, `Y_test` holds
the activity details and `subject_test` holds the subject IDs. In the absence
of any common variable to merge, I have assumed that the data is to be merged
as-is. That is, the first row in in file correspond to each other. The data
is merged using `cbind`.

```
X_test <-  read.table("test/X_test.txt")
Y_test <-  read.table("test/Y_test.txt")
subject_test <- read.table("test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)
```

Similarly, the *train* dataset is created.

```
X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)
```

Eventally, `rbind` is used to merge the *test* and *train* datasets to create
*testrain*

```
testrain <- rbind(test, train)
```
