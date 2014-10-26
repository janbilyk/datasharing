#READ TO TEST DATA FRAME
testing = read.csv("UCI HAR Dataset/test/Y_test.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
#ADD SUBJECT ID
testing[,2] = read.csv("UCI HAR Dataset/test/subject_test.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
#ADD SMARTPHONE READS TO TEMPORARY VARAIBLE
tmp = read.csv("UCI HAR Dataset/test/X_test.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
testing <- cbind(testing, tmp)
#REMOVE TEMPORARY VARIABLE
rm(tmp)


#READ TO TRAINING DATA FRAME
training = read.csv("UCI HAR Dataset/train/Y_train.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
#ADD SUBJECT ID
training[,2] = read.csv("UCI HAR Dataset/train/subject_train.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
#ADD SMARTPHONE READS TO TEMPORARY VARAIBLE
tmp = read.csv("UCI HAR Dataset/train/X_train.txt",  sep="", header=FALSE, skipNul = TRUE, colClasses="character")
training <- cbind(training, tmp)
#REMOVE TEMPORARY VARIABLE
rm(tmp)

#MERGE TWO DATA FRAMES
completeset <- rbind(training, testing)
#REMOVE UNNECESSARY SOURCE DATA FRAMES
rm(training)
rm(testing)

#READ ACTIVITY LABELS WITH SPACE AS SEPARATOR
activity_labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE)

#READ FEATURES
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
# REMOVE UNNECESSARY COLUMNS
features <- features[colsWeWant,]
# ADD SUBJECT AND ACTIVITY
colsWeWant <- c(colsWeWant, 1, 2)
# REMOVE UNNECESSARY COLUMNS
completeset <- completeset[,colsWeWant]
# ADD FEATURES TO COMPLETESET
colnames(completeset) <- c(features$V2, "Activity", "Subject")
colnames(completeset) <- tolower(colnames(completeset))

currentActivity = 1
for (currentActivityLabel in activity_labels$V2) {
  completeset$activity <- gsub(currentActivity, currentActivityLabel, completeset$activity)
  currentActivity <- currentActivity + 1
}

completeset$activity <- as.factor(completeset$activity)
completeset$subject <- as.factor(completeset$subject)

tidy = aggregate(completeset, by=list(activity = completeset$activity, subject=completeset$subject), mean)
# REMOVE SUBJECT AND ACTIVITY COLUMN
tidy[,1] = NULL
tidy[,2] = NULL
write.table(tidy, "tidy.txt", sep="\t")