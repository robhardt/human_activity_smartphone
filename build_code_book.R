library(plyr)
library(stringr)
build_code_book <- function() {
        featureNames <- read.table("features.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)[,2]
        interestingIndexes <- sort(c(grep("mean\\(\\)", featureNames), grep("std\\(\\)", featureNames)))
        interestingIndexNames <- as.character(featureNames[interestingIndexes])
        orig <- interestingIndexNames
        interestingIndexNames <- sub("^t(.+)", "Time.Domain.\\1", interestingIndexNames)
        interestingIndexNames <- sub("^f(.+)", "Frequency.Domain.\\1", interestingIndexNames)
        interestingIndexNames <- sub("^(Time|Frequency\\.Domain\\.)BodyBody|Body(.+)", "\\1Body.\\2", interestingIndexNames)
        interestingIndexNames <- sub("^(.+)Gravity(.+)", "\\1Gravity.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Acc(.+)", "\\1Acceleration.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Gyro-?(.+)", "\\1Angular.Velocity.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Jerk(.+)", "\\1Jerk.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)Mag(.+)", "\\1Magnitude.\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)\\.mean\\(\\)(.+)", "\\1.Mean\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)-mean\\(\\)(.+)?", "\\1Mean\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)\\.std\\(\\)(.+)", "\\1.Standard.Deviation\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)-std\\(\\)(.+)?", "\\1Standard.Deviation\\2", interestingIndexNames)
        interestingIndexNames <- sub("(.+)(Standard.Deviation|Mean)-(X|Y|Z)$", "\\1\\3.Axis.\\2", interestingIndexNames)
        interestingIndexNames <- paste("Averaged.", interestingIndexNames, sep = "")
        
        
        orig <- sub("BodyBody", "Body", orig)
        
        english.df = as.data.frame(orig)
        domain <- rep("", 66)
        timeIdx <- grep("^t", orig)
        freqIdx <- grep("^f", orig)
        domain[timeIdx] <- "in the time domain"
        domain[freqIdx] <- "in the frequency domain (via FFT)"
        
        measurement <- rep("", 66)
        meanIdx <- grep("mean\\(\\)", orig)
        stdIdx <- grep("std\\(\\)", orig)
        measurement[meanIdx] <- "mean"
        measurement[stdIdx] <- "standard deviation"
        
        mags <- rep("", 66)
        magIdx <- grep("Mag", orig)
        mags[magIdx] <- "Euclidean norm magnitude of the"
        
        jerks <- rep("", 66)
        jerkIdx <- grep("Jerk", orig)
        jerks[jerkIdx] <- "jerk"
        
        bGrav <- rep("", 66)
        bodyIdx <- grep("Body", orig)
        gravIdx <- grep("Gravity", orig)
        bGrav[bodyIdx] <- "body"
        bGrav[gravIdx] <- "gravity"
        
        
        accGyro <- rep("", 66)
        accIdx <- grep("Acc", orig)
        gyrIdx <- grep("Gyro", orig)
        accGyro[accIdx] <- "linear acceleration"
        accGyro[gyrIdx] <- "angular velocity"
        
        inst <- rep("", 66)
        inst[accIdx] <- "accelerometer"
        inst[gyrIdx] <- "gyroscope"
        
        axis <- rep("", 66)
        axisRows <- grep("[XYZ]$", orig)
        justAxes <- orig[axisRows]
        
        justAxes <- sub(".+([XYZ])$", "along the \\1 axis", justAxes)
        axis[axisRows] <- justAxes
        
        english.df <- cbind(interestingIndexNames, english.df, domain, measurement, mags, jerks, bGrav, accGyro, inst, axis)
        
        descriptions <- paste("- ", english.df$interestingIndexNames, "\n\t\t\t\"", english.df$orig, "\" in the original features list:\n\t\t\t\tAverage of all the measurements of the", english.df$measurement, "of the", english.df$mags, english.df$jerks, english.df$bGrav, english.df$accGyro, english.df$axis, "from the phone's", english.df$inst, english.df$domain, "for this particular user/activity")
        
        descriptions
}