# The Code Book

###Code Book regarding the run_analysis.R script.
#### More information regarding the analysis can be found after the initial project info.
Below i have included important information regarding the data used in the projects.

Human Activity Recognition Using Smart phones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

=========================================================================================================================================

## Steps that i have used to merge and tidy the data

###Step 1. Stored the training and the test sets into separate r objects called
subjectTrain, activityTrain, featuresTrain, subjectTest, activityTest, featuresTest 

###Step 2. Merge the training and the test set using row bind rbind() function and renamed them into m.training, m.testing and m.features. 

###Step 3. Transpose the feauture vector which contains all the feature names so it can be used to name the columns of our dataframe. 
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. 
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz
to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals 
(tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###Step 4. Combine all the merged dataframes into one using column bind

Question: Extracts only the measurements on the mean and standard deviation for each measurement.
###Step 5. We identify the corresponding columns using the grep function and the following pattern 
```
".*[Mm]ean.*|.*[Ss]td.*"
```
###Step 6. We add the Activity and the Subject Columns to make our dataframe more descriptive since those two columns did not contain the above pattern.

Question: Uses descriptive activity names to name the activities in the data set
###Step 7.  Using the following information we assigned the following character strings to the integers.
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

###Step 8.  Using the gsub function we try to replace as many column names as possible. Some of the pattern and replacements are shown below.
```
names(extractedData)<-gsub("^t", "Time", names(extractedData))

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
```
Question: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
###Step 9. Used the dpyr and piping operation to perform the following operations
```
extractedData %>% 

      group_by(Subject, Activity) %>%
      
      summarize_each(funs(mean)) %>%
      
      group_by(Activity) %>%
      
      arrange(Activity, Subject) %>%
      
      write.table(file = "./data/Assignment/UCI HAR Dataset/Tidydata.txt", row.names = F)
```













