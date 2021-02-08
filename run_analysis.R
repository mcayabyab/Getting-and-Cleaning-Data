#Problem 1: Merge the training and the test sets to create one data set.

#set working directory as downloads folder
setwd("~/Downloads")

#download file
downloadfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(downloadfile,"wk4project.zip", method = "curl")

#read .txt files into data frames
activity_labels <- read.table("./UCI HAR DATASET/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#add features as column name for x_train and x_test
names(x_train) <- features$V2
names(x_test) <- features$V2

#add column name "ID" for subject files
names(subject_train) <- "ID"
names(subject_test) <- "ID"

#add column name "activity" for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

#combine subject, x and y files for both train and test files
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)

#combine test and train data frames into one
all <- rbind(train,test)



#Problem 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#create logical vector where column names contain "mean", "std", "ID" or "activity"
meanstd <- grepl("mean()", names(all)) | grepl("std()", names(all)) | grepl("ID", names(all)) | grepl("activity", names(all))

#subset the combined data using logcal vector
all <- all[,meanstd]



#Problem 3: Uses descriptive activity names to name the activities in the data set
#Problem 4: Appropriately labels the data set with descriptive variable names. 

#Create vector from 2nd column of activity_labels dataframe
labels <- c(activity_labels$V2)

#change class of "activity" column from integer to factor
all$activity <- as.factor(all$activity)

#use activity labels as levels for "activity" column
levels(all$activity) <- labels



#Problem 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library("reshape2")
data <- melt(all, id = c("ID", "activity"))
tidy <- dcast(data, ID + activity ~ variable, mean)
write.table(tidy, "tidy_data.txt", sep = ",")
