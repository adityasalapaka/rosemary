library("plyr")

## Step 1: Merges the training and the test sets to create one data set.

X_test <-  read.table("test/X_test.txt")
Y_test <-  read.table("test/Y_test.txt")
subject_test <- read.table("test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)

X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)

testrain <- rbind(test, train)

## Step 2: Extracts only the measurements on the mean and standard deviation for
## each measurement. 

features <- read.table("features.txt")

meanStdCols <- grep("mean|std", as.character(features$V2))
meanStdData <- testrain[,c(1,2,meanStdCols + 2)]

## Step 3: Uses descriptive activity names to name the activities in the data 
## set.

activity_labels <-  read.table("activity_labels.txt")

for (i in 1:6){
        meanStdData[,2] <- sapply(meanStdData[,2], function(x) 
                ifelse(x == activity_labels[1][i,], 
                       as.vector(activity_labels[2][i,]), x))
}

## Step 4: Appropriately labels the data set with descriptive variable names.

colnames(meanStdData) <- c("Subject", "Activity", 
                           as.character(features$V2[meanStdCols]))

sortedData <- meanStdData[order(meanStdData$Subject),]

## Step 5: From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.

finalData <- ddply(sortedData, .(Subject, Activity), 
                   function(x) colMeans(x[3:81]))

write.table(finalData, file = "tidy_data.txt", row.name = FALSE)