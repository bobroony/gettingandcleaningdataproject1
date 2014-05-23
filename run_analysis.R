# This script will download wearable computing data from UC Irvine,
# manipulate the resulting data to produce a tidy data set which will
# be written to "wearable_tidy_data_set.txt" in the currenty
# directory

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="wearable.zip", method="curl")
unzip("wearable.zip")

# load the data
labels <- read.table("UCI HAR Dataset/features.txt",colClasses="character",header=FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",colClasses="character",header=FALSE)
test_set_x <- read.delim("UCI HAR Dataset/test/X_test.txt",colClasses="numeric",sep="",header=FALSE)
test_set_y <- read.table("UCI HAR Dataset/test/y_test.txt",colClasses="numeric",header=FALSE)
test_set_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt",colClasses="numeric",header=FALSE)
train_set_x <- read.delim("UCI HAR Dataset/train/X_train.txt",colClasses="numeric",sep="",header=FALSE)
train_set_y <- read.table("UCI HAR Dataset/train/y_train.txt",colClasses="numeric",header=FALSE)
train_set_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt",colClasses="numeric",header=FALSE)

# rename the activities
activity_labels$V1 <- NULL
test_set_y <- apply(test_set_y,2,function(x) activity_labels[x,1])
train_set_y <- apply(train_set_y,2,function(x) activity_labels[x,1])

# append the subject number and y value to both sets
test_set_x <- cbind(test_set_x,test_set_subjects)
test_set_x <- cbind(test_set_x,test_set_y)
train_set_x <- cbind(train_set_x,train_set_subjects)
train_set_x <- cbind(train_set_x,train_set_y)

# combine the training data
combined_set <- rbind(test_set_x,train_set_x)

# change labels of the new data set
combined_labels <- labels[,2]
combined_labels <- append(combined_labels,"Subject")
combined_labels <- append(combined_labels,"Activity")
colnames(combined_set) <- combined_labels

# get the column indexes for standard deviation (std) and mean
std_index <- grep(".*std.*",combined_labels,perl=TRUE,value=TRUE)
mean_index <- grep(".*mean.*",combined_labels,perl=TRUE,value=TRUE)

# create data set that has only std and mean, but still need
# subject and activity
combined_set_1 <- combined_set[std_index]
combined_set_1 <- cbind(combined_set_1,combined_set[mean_index])
combined_set_1 <- cbind(combined_set_1,combined_set[,"Subject"])
combined_set_1 <- cbind(combined_set_1,combined_set[,"Activity"])
names(combined_set_1)[80] <- "Subject"
names(combined_set_1)[81] <- "Activity"

# melt the data by subject and activity, dcast the means
# of each variable for each activity for each subject
m1 <- melt(combined_set_1, id=c("Subject","Activity"))
tidy <- dcast(m1,Subject+Activity~variable,mean)

#write out the data
write.table(tidy,"wearable_tidy_data_set.txt")