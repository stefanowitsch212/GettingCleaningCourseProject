
## -------- PART 1 Merges the training and the test sets to create one data set.
## Data will be downloaded and written into ./data/ folder in working directory 

# Download & Unzip All Data 
install.packages("downloader")
library(downloader)
url = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./data")

# Load Test / Train  Data
DataTest <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
DataTrain <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")

str (DataTest)
head (DataTest, n=5) [,1:3]
tail (DataTest)
dim(DataTest)

# Load Feature List & Add Colum Names to Test Data 
Features <- read.table(file = "./data/UCI HAR Dataset/features.txt", header=FALSE, sep="")
Features
str(Features)
head(Features, n=5)
## Drop Variable in Features 
Features$V1 <- NULL
dim(Features)
head (Features, n = 5)
## Transpose 
FeaturesTransposed <- t(Features)
dim (FeaturesTransposed)

## Set Names to Test / Train Data
DataTestNamed <- setNames(DataTest, FeaturesTransposed)
head (DataTestNamed, n=5) [,1:3]
dim(DataTestNamed)
DataTrainNamed <- setNames(DataTrain, FeaturesTransposed)
head (DataTrainNamed, n=5) [,1:3]
dim(DataTrainNamed)

# Load Test Subject List & Subject Column (ok)
SubjectTest <- read.table (file = "./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
SubjectTrain <- read.table (file = "./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
str (SubjectTest)
str (SubjectTrain)

## Add Name
names(SubjectTest) <- "Subject"
names(SubjectTrain) <- "Subject"
str (SubjectTest)
str (SubjectTrain)
dim(SubjectTest)
dim(SubjectTrain)

# Connect Labled Data & Labled Subjects  (ok)
DataTestAllLabled <- cbind(SubjectTest,DataTestNamed)
DataTrainAllLabled <- cbind(SubjectTrain,DataTrainNamed)
dim (DataTestAllLabled)
dim (DataTrainAllLabled)
head(DataTestAllLabled, n=5) [,1:3]
tail(DataTrainAllLabled, n=5) [,1:3]

## Merge All Labled Test & Train Data (ok)
TestPlusTrain <- rbind(DataTestAllLabled,DataTrainAllLabled)
head(TestPlusTrain, n=5) [,1:3]
tail(TestPlusTrain, n=5) [,1:3]
head(TestPlusTrain)
dim(TestPlusTrain)
str(TestPlusTrain)

## -------- Part 2 Extracts only the measurements on the mean and standard deviation for each measurement. 

## Extract Mean Columns 
MeanCols = grep("mean", names(TestPlusTrain))
MeanColOnly = TestPlusTrain[,MeanCols]
str (TestPlusTrain[,MeanCols])

## Extract Std  Columns 
StdCols = grep("std", names(TestPlusTrain))
StdColOnly = TestPlusTrain[,StdCols]
str (TestPlusTrain[,StdCols])

## Combine Mean & Std Columns 
MeanPlusStd <- cbind (MeanColOnly, StdColOnly)
str (MeanPlusStd)

## -------- PART 3 Uses descriptive activity names to name the activities in the data set
# Get Lables 
ActivityLables <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
ActivityLables # Review Lables 

# Get Activity Data
ActivityTest <- read.table(file = "./data/UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")
ActivityTrain <- read.table(file = "./data/UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")
str (ActivityTest)
str (ActivityTrain)
head (ActivityTest)
head (ActivityTrain)
tail (ActivityTrain)

# Merge Activity Data and Lables 
ActivityTestDescript <- merge (ActivityTest, ActivityLables, all.x = TRUE, sort=F)
ActivityTrainDescript <- merge (ActivityTrain, ActivityLables, all.x = TRUE, sort=F)
str (ActivityTestDescript)
head (ActivityTestDescript)
tail (ActivityTestDescript)  # Review Results 
head (ActivityTrainDescript)
tail (ActivityTrainDescript)  # Review Results 

# Combine Train & Test Acticity Data 
TestPlusTrainActivity <- rbind(ActivityTestDescript,ActivityTrainDescript)
dim (TestPlusTrainActivity)
head (TestPlusTrainActivity)
tail (TestPlusTrainActivity)  # Review Results 

## -------------  PART 4 Appropriately labels the data set with descriptive variable names. 
AllMerged <- cbind (TestPlusTrainActivity, TestPlusTrain)
dim (AllMerged)
str (AllMerged)
names(AllMerged)[1] <- "ActivityCode"
names(AllMerged)[2] <- "Activity"
head (AllMerged, n=5)[,1:4]

## -------------  PART 5 From the data set in step 4, creates a second, independent 
# tidy data set with the average of each variable for each activity and each subject.

## aggregate by Subject
attach(AllMerged)
aggdata <-aggregate(AllMerged, by=list(Subject), FUN=mean, na.rm=TRUE)
aggdata [,1:10]
detach(AllMerged)

## Clean Out Meaningless Columns, e.g. Activity Codes
aggdata$ActivityCode <- NULL
aggdata$Activity <- NULL
aggdata$Group.1 <- NULL
aggdata [,1:5]
str (aggdata)

## Write Submission File
write.table (aggdata, file = "./data/tidydata.txt", row.name=FALSE )


