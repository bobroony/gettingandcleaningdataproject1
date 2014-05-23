## Introduction

This script will download wearable computing data from UC Irvine, manipulate the resulting data to produce a tidy data set which will be written to "wearable_tidy_data_set.txt" in the currenty directory.

* <b>Dataset</b>: <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">Wearable Computing</a>

## How the script works

The script grabs the data from the following files:

* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

The script renames the activities in the y_* files using the mapping found in the activity_labels.txt file.  It then appends the subject number, found in the subject_* files and the newly constructed y_* files to the X_* as column vectors.  Once both the training set and test set have been constructed, they are appended to eachother by row, creating a new dataset.

On this new dataset, the proper labels are applied using the information from features.txt.  The columns that match the regular expression ".*std.*" for standard deviation and ".*mean.*" for means are extracted from the combined dataset and form a new dataset on their own.  The data is then melted by subject and activity, and dcast the means of each variable for each activity for each subject.
