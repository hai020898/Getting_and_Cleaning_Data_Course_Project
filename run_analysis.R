library(reshape2)

# Load the datasets
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(y_train, s_train, x_train)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(y_test, s_test, x_test)

# Load activity labels + features
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
activity <-  read.table("./UCI HAR Dataset/activity_labels.txt")
activity[,2] <- as.character(activity[,2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# merge datasets and add labels
dataset <- rbind(train,test)
colnames(dataset) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
dataset$activity <- factor(dataset$activity, levels = activity[,1], labels = activity[,2])
dataset$subject <- as.factor(dataset$subject)


dataset.melted <- melt(dataset, id = c("subject", "activity"))
dataset.mean <- dcast(dataset.melted, subject + activity ~ variable, mean)

write.table(dataset.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

