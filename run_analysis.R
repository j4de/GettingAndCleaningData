## Set the working directory appropriately to point to location of the 
## unzipped datasets to work with - it may be different on your system!!
setwd("R/getdataProject/UCI HAR Dataset")

## load training set data
xtrain <- read.table("X_train.txt") ## main dataset

features <- read.table("features.txt")    ## get the features list
features$V2 <- as.character(features$V2)  ## convert from factor to char
colnames(xtrain)<-features$V2             ## set xtrain dataset column names

ytrain <- read.table("y_train.txt") ## activity
colnames(ytrain)<-c("Activity")           ## set Activity field name

xtrain$activity <- ytrain$Activity                 ## add it to the main dataset

subtrain <- read.table("subject_train.txt") ## subject/person_id
colnames(subtrain)<-c("Subject")          ## set Subject field name

xtrain$subject <- subtrain$Subject                ## add it to the main dataset

xtrain$settype <- "Training"              ## mark dataset as Training

## to view what we have at the moment
##xtrain[1:10,c(1,2,3,4,5,562,563,564)]

## Based on FAQ in discussion forum the Inertial Signals folder is not needed
## I was concerned about including it anyway so I am pleased to read this

##bgxtrain <- read.table("train/Inertial Signals/body_gyro_x_train.txt")
##bgytrain <- read.table("train/Inertial Signals/body_gyro_y_train.txt")
##bgztrain <- read.table("train/Inertial Signals/body_gyro_z_train.txt")

##taxtrain <- read.table("train/Inertial Signals/total_acc_x_train.txt")
##taytrain <- read.table("train/Inertial Signals/total_acc_y_train.txt")
##taztrain <- read.table("train/Inertial Signals/total_acc_z_train.txt")

##baxtrain <- read.table("train/Inertial Signals/body_acc_x_train.txt")
##baytrain <- read.table("train/Inertial Signals/body_acc_y_train.txt")
##baztrain <- read.table("train/Inertial Signals/body_acc_z_train.txt")

## load test set data
xtest <- read.table("X_test.txt") ## main dataset

features <- read.table("features.txt")    ## get the features list
features$V2 <- as.character(features$V2)  ## convert from factor to char
colnames(xtest)<-features$V2             ## set xtrain dataset column names

ytest <- read.table("y_test.txt") ## activity
colnames(ytest)<-c("Activity")           ## set Activity field name

xtest$activity <- ytest$Activity                 ## add it to the main dataset

subtest <- read.table("subject_test.txt") ## subject/person_id
colnames(subtest)<-c("Subject")          ## set Subject field name

xtest$subject <- subtest$Subject                ## add it to the main dataset

xtest$settype <- "Testing"              ## mark dataset as Training

## to view what we have at the moment
##xtest[1:10,c(1,2,3,4,5,562,563,564)]

## Based on FAQ in discussion forum the Inertial Signals folder is not needed
## I was concerned about including it anyway so I am pleased to read this
##bgxtest <- read.table("test/Inertial Signals/body_gyro_x_test.txt")
##bgytest <- read.table("test/Inertial Signals/body_gyro_y_test.txt")
##bgztest <- read.table("test/Inertial Signals/body_gyro_z_test.txt")

##taxtest <- read.table("test/Inertial Signals/total_acc_x_test.txt")
##taytest <- read.table("test/Inertial Signals/total_acc_y_test.txt")
##taztest <- read.table("test/Inertial Signals/total_acc_z_test.txt")

##baxtest <- read.table("test/Inertial Signals/body_acc_x_test.txt")
##baytest <- read.table("test/Inertial Signals/body_acc_y_test.txt")
##baztest <- read.table("test/Inertial Signals/body_acc_z_test.txt")

## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.

## 1. Merges the training and the test sets to create one data set.
##
## Both the training and test sets are now available as loaded in above
## Note that we then add them together in a row merge operation to give 
## us the complete dataset.

## add the training and testing datasets together
dataset <- rbind(xtrain, xtest)

## Shows the merge point
##dataset[7342:7362,c(1,2,3,562,563,564)]

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## find the columns with std() or mean() in their name - based on feature_info.txt documentation
stdcols <- features[grep("std()",features$V2),c(1)]
meancols <- features[grep("mean()",features$V2),c(1)]
stdmeancols <- c(stdcols, meancols)
## add activity, subject and settype, want to keep these intact
allcols <- c(stdmeancols, 562, 563, 564)
## sort to get the columns in order
allcols <- sort(allcols)
## get reduced dataset of mean's and std's from the dataset
meanstd_ds <- dataset[,allcols]

##meanstd_ds[7342:7362,c(1,2,3,80,81,82)]

## 3. Uses descriptive activity names to name the activities in the data set
act_lbls <- read.table("activity_labels.txt")
colnames(act_lbls)<-c("activity","Activity.Name")
act_lbls$activity <- as.factor(act_lbls$activity)

meanstd_ds$activity <- as.factor(meanstd_ds$activity)
act_ds <- merge( act_lbls, meanstd_ds, by = "activity", all.y=TRUE)

##act_ds[7342:7362,c(1,2,3,80,81,82,83)]
##table(act_ds$Activity.Name)

## 4. Appropriately labels the data set with descriptive variable names.

## I think that this has already been achieved from the outset when the
## the features we set a column headings.
## str(act_ds)

## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.

## shows number of records by activity and subject
##table(act_ds$Activity.Name, act_ds$subject)

tidy_data_set <- aggregate( x=act_ds, 
                            by=list(ActivityName=act_ds$Activity.Name, 
                                    Subject=act_ds$subject),
                            FUN="mean")

## tidy up the data set a little more before saving it by removing 
## unnecessary columns
dropcols <- c("settype","activity","Activity.Name","subject")
tidy_data_set <- tidy_data_set[,!names(tidy_data_set) %in% dropcols]

## save the tidy data set to a TXT file for uploading
write.table(tidy_data_set,file="tidy_data_set.txt",append=FALSE,quote=TRUE,sep=",",
            eol="\n",na="NA",dec=".",row.names=FALSE,
            col.names=TRUE,qmethod=c("escape","double"),
            fileEncoding="")
