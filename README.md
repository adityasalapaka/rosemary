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
> Merges the training and the test sets to create one data set.

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

### Step 2
> Extracts only the measurements on the mean and standard deviation for
each measurement.

A new object `features` is created, which is a data frame consisting of all
variable names. 

```
features <- read.table("features.txt")
```

Another object `meanStdCols` is created which contains the column numbers for
all the variables which have mean or standard deviation data. The `grep()`
function was used to match the regular expression `mean|std` with the varaible
names.

```
meanStdCols <- grep("mean|std", as.character(features$V2))
```

The relevant data is stored by subsetting `testrain` into another object
`meanStdData`.

```
meanStdData <- testrain[,c(1,2,meanStdCols + 2)]
```

### Step 3
> Uses descriptive activity names to name the activities in the data set.

A new object `activity_labels` is created which stores the activity lables.

```
activity_labels <-  read.table("activity_labels.txt")
```

A `for` loop is run over `meanStdData` which replaces activity IDs with the 
corresponding activity labels. The `sapply` function is used for this purpose.

```
for (i in 1:6){
        meanStdData[,2] <- sapply(meanStdData[,2], function(x) 
                ifelse(x == activity_labels[1][i,], 
                       as.vector(activity_labels[2][i,]), x))
}
```

### Step 4
> Appropriately labels the data set with descriptive variable names.

The variables names are taken from `features` and assigned to the columns of 
`meanStdData`. `meanStdCols` already stored the relevant column numbers.

```
colnames(meanStdData) <- c("Subject", "Activity", 
                           as.character(features$V2[meanStdCols]))
```

### Step 5
> From the data set in step 4, creates a second, independent tidy data set with
the average of each variable for each activity and each subject.

To prevent `ddply` from ordering the data by activity, the acitvity column is
forced to be ordered by the order given in `activity_labels`.

```
meanStdData$Activity <- factor(meanStdData$Activity, 
                               levels = as.vector(activity_labels$V2), 
                               ordered = TRUE)
```

The `ddply` function is used in the `plyr` package to split data by subject and
activity, and the find the average of each variable. The new data frame is 
stored in `finalData`.

```
finalData <- ddply(meanStdData, .(Subject, Activity), 
                   function(x) colMeans(x[3:81]))
```

Finally, `write.table()` is used to write `finalData` into a text file. As per
the instructions, row names are omitted. 

```
write.table(finalData, file = "tidy_data.txt", row.name = FALSE)
```

## Conclusion
To read the newly created tidy dataset, the `read.table()` function may be used 
with the argument `header = TRUE`.