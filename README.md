Human Activity Recognition Using Smartphones Data Set 
=========================

Work on the "Human Activity Recognition Using Smartphones" data set from UC Irvine

Background
-----

This repository contains a script that works with the Work on the "Human Activity Recognition Using Smartphones" data set from UC Irvine.  More info about this data set can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The raw data set can be found here:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Overview
-----

This repository contains a script (**run_analysis.R**) and documentation that allow a researcher to do the following:

* read the data from the "Human Activity Recognition Using Smartphones" data set into an R data.frame
* merge the training and testing sets (the measurements were randomly split 70/30 into training and testing sets)
* extract out the mean and standard deviation measurements from the data set
* give meaningful, understandable names to the various activities performed by the subjects
* give meaningful, understandable names to the measurements we are working with
* aggregate the data by calculating the average for each subject/activity
* return a 'Tidy' data set as per Hadley Wickham's criteria <link>http://vita.had.co.nz/papers/tidy-data.pdf</link>


Tidy Data
-----

To briefly summarize what makes the output file of this script Tidy Data, the output will have the following characteristics (borrowed from http://jtleek.com/modules/03_GettingData/01_03_componentsOfTidyData/#4)

1.  Each variable you measure should be in one column
2.  Each different observation of that variable should be in a different row
3.  There should be one table for each "kind" of variable
4.  If you have multiple tables, they should include a column in the table that allows them to be linked


Getting Started
-----
Please note that this script uses the Plyr and Stringr libraries, so please make sure you have installed those packages before running


      install.packages(c("plyr", "stringr"))


Next, it is expected that the  script will be copied into the root directory of the UCI HAR Dataset.  So in order to run the <b>run_analysis.R</b> script, your directory structure should look like this:



* *working directory*
  * UCI HAR dataset
    * activity_labels.txt
    * features_info.txt
    * features.txt
    * README.txt
    * **run_analysis.R**
    * test
    * train


Finally, here is how you would load the tidy dataset into a local variable and write it out to a text file using the **run_analysis.R** script:

      setwd("*working directory*/UCI HAR dataset")
      source("run_analysis.R")
      my.analysis = run_analysis()
      write.table(my.analysis, file="tidy_output.txt")



