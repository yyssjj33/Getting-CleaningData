# Project: run_analysis.R
# Goals: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 
#
# BY: YANG Ji


# Read features and activity_labels
features <- read.table("./UCI HAR Dataset/features.txt", 
                       header = FALSE, sep = "", stringsAsFactors = FALSE, 
                       col.names = c("obs", "feature_label"))
# Remove the - ,  ( and )
features$feature_label <- gsub(pattern = "-", replacement = "", 
                               x = features$feature_label, fixed = TRUE)
features$feature_label <- gsub(pattern = "(", replacement = "", 
                               x = features$feature_label, fixed = TRUE)
features$feature_label <- gsub(pattern = ")", replacement = "", 
                               x = features$feature_label, fixed = TRUE)
features$feature_label <- gsub(pattern = ",", replacement = "", 
                               x = features$feature_label, fixed = TRUE)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                              header = FALSE, sep = "",
                              stringsAsFactors = FALSE,
                              col.names = c("activity", "activity_label"))


# Read train and test subject and combine
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header = FALSE, sep = "", col.names = "subject")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           header = FALSE, sep = "", col.names = "subject")
subject <- rbind(subject_train, subject_test)


# Read X_train, X_test, Y_train and Y_test data sets. 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, 
                      sep = "", col.names = features$feature_label)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, 
                     sep = "", col.names = features$feature_label)
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, 
                      sep = " ", quote = "", 
                      col.names = "activity")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, 
                     sep = " ", quote = "", 
                     col.names = "activity")


# Combine X, subject and Y, then combine train and test to the fulldata
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)

fulldata <- cbind(Y, subject, X[, grep("mean|std", colnames(X))])


# Average for each activity and each subject and write to working directory
library(plyr)
finaldata <- ddply(fulldata, .(activity, subject), colwise(mean))
finaldata2 <- merge(activity_labels, finaldata, by.x = "activity", 
                    by.y = "activity", all = TRUE)

# Output the tidy data
write.table(finaldata2, file ="finaldata.txt", row.names = FALSE)

