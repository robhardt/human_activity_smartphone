library(plyr)
library(stringr)
## ###########################################################################################
## run_analysis.R
## Rob Hardt
##
## this script is designed to be run from the 'UCI HAR dataset' root directory from the
## extracted getdata-projectfiles-UCI HAR Dataset.zip file from:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## copy this script into the root directory, and run:
## source("run_analysis.R")
## run_analysis()
## more info is available in README.md
## 
## ###########################################################################################
run_analysis <- function() {
        
        ## ###########################################################################################
        ## 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
        ## ###########################################################################################
        
        ## read all the feature names from the features.txt file
        featureNames <- read.table("features.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)[,2]
        ## get the indexes of all the features that we're interested in, i.e. those containing 'mean()' or 'std()'
        interestingIndexes <- sort(c(grep("mean\\(\\)", featureNames), grep("std\\(\\)", featureNames)))
        
        ## ###########################################################################################
        ## 4.  Appropriately labels the data set with descriptive variable names. 
        ## ###########################################################################################
        
        ## pull the feature names from those indexes
        interestingIndexNames <- as.character(featureNames[interestingIndexes])
        
        ## through a series of regex substitutions, convert the provided feature names into human readable ones
        ## t/f to Time/Frequency Domain
        interestingIndexNames <- sub("^t(.+)", "Time.Domain.\\1", interestingIndexNames)
        interestingIndexNames <- sub("^f(.+)", "Frequency.Domain.\\1", interestingIndexNames)
        ## fix the BodyBody type, and separate out 'Body'
        interestingIndexNames <- sub("^(Time|Frequency\\.Domain\\.)BodyBody|Body(.+)", "\\1Body.\\2", interestingIndexNames)
        ## separate out 'Gravity'
        interestingIndexNames <- sub("^(.+)Gravity(.+)", "\\1Gravity.\\2", interestingIndexNames)
        ## separate out Acceleration/Angular Velocity
        interestingIndexNames <- sub("(.+)Acc(.+)", "\\1Acceleration.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Gyro-?(.+)", "\\1Angular.Velocity.\\2", interestingIndexNames)
        ## separate out 'Jerk' and 'Magnitude'
        interestingIndexNames <- sub("(.+)Jerk(.+)", "\\1Jerk.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Mag(.+)", "\\1Magnitude.\\2", interestingIndexNames)
        ## rewrite 'Mean' and 'Standard Deviation' according to convention
        interestingIndexNames <- sub("(.+)\\.mean\\(\\)(.+)", "\\1.Mean\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)-mean\\(\\)(.+)?", "\\1Mean\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)\\.std\\(\\)(.+)", "\\1.Standard.Deviation\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)-std\\(\\)(.+)?", "\\1Standard.Deviation\\2", interestingIndexNames)
        ## populate X/Y/Z axis
        interestingIndexNames <- sub("(.+)(Standard.Deviation|Mean)-(X|Y|Z)$", "\\1\\3.Axis.\\2", interestingIndexNames)
        ## prepend 'Averaged' since our output will be the mean of multiple measurements
        interestingIndexNames <- paste("Averaged.", interestingIndexNames, sep = "")
        
        ## ###########################################################################################
        ## 3.  Uses descriptive activity names to name the activities in the data set
        ## ###########################################################################################
        
        ## read in the activity_labels.txt file to use as a lookup table for our numbered activities in the dataset
        activity_labels <- read.table("activity_labels.txt", col.names=c("activityNumber", "activityName"))
        
        
        ## takes a directory as an argument, combines multiple sources
        buildCompositeDf <- function(dir) {
                ## read in X_train.txt or X_test.txt
                mainBlock <- read.table(paste("./", dir, "/X_", dir, ".txt", sep=""), header=FALSE)[,interestingIndexes]
                ## give the results our human-readable column names
                colnames(mainBlock) <- interestingIndexNames
                ## read in the numbered activities from Y_train.txt or Y_test.txt
                activities <- read.table(paste("./", dir, "/Y_", dir, ".txt", sep=""), header=FALSE, col.names="activityNumber", stringsAsFactors=FALSE)
                ## replace them with their activity name using the lookup table we created previously
                activity.name <- join(activities, activity_labels, by="activityNumber")[,2]
                ## read in the subject associated with each observation
                subjects <- read.table(paste("./", dir, "/subject_", dir, ".txt", sep=""), header=FALSE, col.names="subject")
                ## throw them all together with cbind
                cbind(subjects, activity.name, mainBlock)
        }
        
        ## ###########################################################################################
        ## 1.  Merges the training and the test sets to create one data set.
        ## ###########################################################################################
        
        ## call the builder function to load the test set into a data table
        test_set <- buildCompositeDf("test")
        ## call the builder function to load the training set into a data table
        train_set <- buildCompositeDf("train")
        ## combine the test and training sets with rbind
        combined <- rbind(test_set, train_set)
        
        ## ###########################################################################################
        ## 5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
        ## ###########################################################################################
        
        ## aggregate all columns from 3 on with the mean function.  Aggregate by columns 1 & 2 (subject & activity)
        aggregated_results <- aggregate(combined[,3:68], combined[,1:2], FUN=mean)
        aggregated_results
}
