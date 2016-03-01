#Getting and Cleaning Data Course Projectless 
#
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#       
#       http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 


# A few lines of code to make sure you have the required packages for this script
# if not the code will automatically install them
# making sure that dplyr is installed in the system
if ('dplyr' %in% rownames(installed.packages())){
      library(dplyr)
}else{ install.packages('dplyr')
      library(dplyr)}

#making sure that data.table is installed in the system
if ('data.table' %in% rownames(installed.packages())){
      library(data.table)
}else{ install.packages('data.table')
      library(data.table)}

# #making sure that sqldf is installed in the system (not required)
# if ('sqldf' %in% rownames(installed.packages())){
#       library(sqldf)
# }else{ install.packages('sqldf')
#       library(sqldf)}


# Downloading the data for the project:
getwd()  
setwd('C:\\Users\\kwnstantinos\\Desktop\\Getting and Cleaning Data Coursera')
fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileurl, destfile = './data/project.zip') #downloads the file to the data dir
unzip('./data/project.zip',exdir = './data/Assignment') #extracts the data to the Assignment dir which is inside the data dir


##lists all the files
path <- file.path('./data/Assignment/UCI HAR Dataset/')
files <- list.files(path, recursive = T)
#files

#Read features and activitylabels
features <- read.table("./data/Assignment/UCI HAR Dataset/features.txt")
activityLabels <- read.table("./data/Assignment/UCI HAR Dataset/activity_labels.txt", header = FALSE)


# Format training and test data sets
# Both training and test data sets are split up into subject, activity and features. They are present in three different files.

##Read training data
subjectTrain <- read.table("./data/Assignment/UCI HAR Dataset/train/subject_train.txt")
activityTrain <- read.table("./data/Assignment/UCI HAR Dataset/train/y_train.txt")
featuresTrain <- read.table("./data/Assignment/UCI HAR Dataset/train/X_train.txt")

##Read test data
subjectTest <- read.table("./data/Assignment/UCI HAR Dataset/test/subject_test.txt")
activityTest <- read.table("./data/Assignment/UCI HAR Dataset/test/y_test.txt")
featuresTest <- read.table("./data/Assignment/UCI HAR Dataset/test/X_test.txt")


##Merges the training and the test sets to create one data set.

m.subject <- rbind(subjectTrain, subjectTest)
m.activity <- rbind(activityTrain, activityTest)
m.features <- rbind(featuresTrain, featuresTest)

####################
# Naming the columns
# The columns in the features data set can be named from the metadata in featureNames
# ncol(m.features) 561 columns
# nrow(features) 561 rows
# to combine them we must use transpose turning the rows into columns

colnames(m.features) <- t(features[2])

##########################
#1. Merge the data
# The data in features,activity and subject are merged 
# and the complete data is now stored in completeData.

colnames(m.activity) <- "Activity" #only one column, we name it Activity
colnames(m.subject) <- "Subject" #only one column, we name it Activity
mergedData <- cbind(m.subject,m.activity, m.features) #column bind all the data together
View(mergedData)
#nrow(mergedData)

####################################
#2. Extracts only the measurements on the mean and standard deviation for each measurement.

#finding the columns with mean on std in their title using grep
columnsWithMeanOrStd <- grep(".*[Mm]ean.*|.*[Ss]td.*", names(mergedData))

#adding Subjects and activity column, indices columns variable
indColumns <- c( 1, 2, columnsWithMeanOrStd) 

# We create extractedData with the selected columns in requiredColumns. 

extractedData <- mergedData[,indColumns]
View(extractedData)
#dim(extractedData)

##############################################
#3. Uses descriptive activity names to name the activities in the data set

#The activity field in extractedData is originally of numeric type. We need to change its type to character so that it can accept activity names. The activity names are taken from metadata activityLabels.
# my method is quite slow maybe later i would think of a better one
for (i in 1:nrow(extractedData)){
      
      if (extractedData$Activity[i]=='1'){
            extractedData[i,2] <- 'WALKING'
      }else if(extractedData$Activity[i]=='2'){
            extractedData[i,2] <- 'WALKING_UPSTAIRS'
      }else if(extractedData$Activity[i]=='3'){
            extractedData[i,2] <- 'WALKING_DOWNSTAIRS'
      }else if(extractedData$Activity[i]=='4'){
            extractedData[i,2] <- 'SITTING'
      }else if(extractedData$Activity[i]=='5'){
            extractedData[i,2] <- 'STANDING'
      }else if(extractedData$Activity[i]=='6'){
            extractedData[i,2] <- 'LAYING'
      }
      
}
View(extractedData)


#We need to factor the activity variable, once the activity names are updated.

extractedData$Activity <- as.factor(extractedData$Activity)

###########################################
#4. Appropriately labels the data set with descriptive variable names.

names(extractedData) #identify the problematic column names

# Proposed changes
# Acc can be replaced with Accelerometer
# Gyro can be replaced with Gyroscope
# BodyBody can be replaced with Body
# Mag can be replaced with Magnitude
# Character f can be replaced with Frequency
# Character t can be replaced with Time
# we are going to try to replace every title possible by running multiple global substitutions

names(extractedData)<-gsub("^t", "Time", names(extractedData));
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))



#################################################
# From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject

# make sure Subjects are factor and not integers
class(extractedData$Subject) #integer class (wrong)
extractedData$Subject <- as.factor(extractedData$Subject)
# data.table library required
library(data.table)
extractedData <- data.table(extractedData) 


# we are going to use piping operations for this parts
# makes sure that library dplyr is loaded
extractedData %>% 
      group_by(Subject, Activity) %>%
      summarize_each(funs(mean)) %>%
      group_by(Activity) %>%
      arrange(Activity, Subject) %>%
      write.table(file = "./data/Assignment/UCI HAR Dataset/Tidydata.txt", row.names = F)
      # saving the data to a text file
      # if we set row.names to False its like having two Subject columns



# Alternative way      
# #We create tidyData as a data set with average for each activity and subject. 
# #Then, we order the enties in tidyData and write it into data file Tidy.txt that contains the processed data.
#       
# tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
# tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
#       
# write.table(tidyData, file = "Tidydata.txt", row.names = FALSE)
#       
#       











