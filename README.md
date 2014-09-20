## This is the README.md file

This file describes how the run_analysis.R script works.


1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the 
   average of each variable for each activity and each subject.

Before we do any of the above it is important to set your working directory.

Load training set data X_train.txt - main dataset
Load the features list from features.txt so we can set the column names for the main dataset
Load the associated activities from y_train.txt to add to the main dataset
Load the associated subject from subject_train.txt to add to the main dataset
I've opted to add the type of data (since one is Training and one is Testing) via a settype field,
I'm thinking this may help furhter down the road if differentiation is required, it can be removed
later if not needed.

Load testing set data X_test.txt - main test dataset
Load the features list from features.txt so we can set the column names for the main test dataset
Load the associated activities from y_test.txt to add to the main dataset
Load the associated subject from subject_test.txt to add to the main dataset
I've opted to add the type of data (since one is Training and one is Testing) via a settype field,
I'm thinking this may help furhter down the road if differentiation is required, it can be removed
later if not needed.

1. Merges the training and the test sets to create one data set.

Both the training and test sets are now available as loaded in above
Note that we then add them together in a row merge operation to give 
us the complete dataset.

dataset <- rbind(xtrain, xtest)

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Find the columns with std() or mean() in their name - based on feature_info.txt documentation
Add back the activity, subject and settype, want to keep these intact
Sort to get the columns in order
Get reduced dataset of mean's and std's from the dataset

3. Uses descriptive activity names to name the activities in the data set

We match the activity_labels.txt against that in the reduced dataset

4. Appropriately labels the data set with descriptive variable names.

This has already been achieved from the outset when the
the features we set a column headings.

5. From the data set in step 4, creates a second, independent tidy data set with the 
   average of each variable for each activity and each subject.

We use the aggregate function to achieve this.

Tidy up the data set a little more before saving it by removing 
unnecessary columns; settype,activity,Activity.Name,subject

Save the tidy data set to a TXT file for uploading
