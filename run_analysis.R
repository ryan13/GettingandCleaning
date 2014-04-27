
#1.  Merges the training and the test sets to create one data set

datTrain <- read.table("train/X_train.txt",header=FALSE)
datTest <- read.table("test/X_test.txt",header=FALSE)
## concatenate test set and train set
tmp1 <- rbind(datTrain, datTest)

##Similarly  for subject_train and subject_test  
datTrain <- read.table("train/subject_train.txt",header=FALSE)
datTest <- read.table("test/subject_test.txt",header=FALSE)
tmp2 <- rbind(datTrain, datTest)

## Same steps for y_train and y_test
datTrain <- read.table("train/y_train.txt",header=FALSE)hea
datTest <- read.table("test/y_test.txt",header=FALSE)
tmp3 <- rbind(datTrain, datTest)


## read activity label content
activity<- read.table("activity_labels.txt")
## read feature 
features <- read.table("features.txt")

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## First, get indices of instance with mean and standard deviation
id <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
## subset only these values
tmp1 <- tmp1[, id]
names(tmp1) <- features[id, 2]

# 3. Uses descriptive activity names to name the activities in the data set
## Substitute activity name for combined y trained - tested file as label
tmp3[,1] = activity[tmp3[,1], 2]

# 4. Appropriately labels the data set with descriptive activity names.
names(tmp2) <- "subjects"
names(tmp3) <- "activities"

## merging all data into one
combinedData <- cbind(tmp1, tmp2, tmp3)
write.table(combinedData, "clean_data.txt")

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

numCols = dim(combinedData)[2]
nactivities = length(activity[,1])
nsubjects = length(unique(tmp2)[,1])

## Find number of unique  subject
uSubjects = unique(tmp2)[,1]

## melt 
library(reshape)
md <- melt(combinedData, id.vars=c("activities","subjects"))
meanData <- dcast(md,subjects + activities ~ variable,mean)
write.table(meanData, "tinyData.txt", sep="\t")

