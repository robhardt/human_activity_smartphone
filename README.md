Human Activity Recognition Using Smartphones Data Set 
=========================

Work on the "Human Activity Recognition Using Smartphones" data set from UC Irvine

Background
-----

This repository contains a script that works with the Work on the "Human Activity Recognition Using Smartphones" data set from UC Irvine.  More info about this data set can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The raw data set can be found here:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Script Overview
-----

This repository contains a script (**run_analysis.R**) and documentation that allow a researcher to do the following:

1. read the data from the "Human Activity Recognition Using Smartphones" data set into an R data.frame
2. merge the training and testing sets (the measurements were randomly split 70/30 into training and testing sets)
3. extract out the mean and standard deviation measurements from the data set
4. give meaningful, understandable names to the various activities performed by the subjects
5. give meaningful, understandable names to the measurements we are working with
6. aggregate the data by calculating the average for each subject/activity
7. return a 'Tidy' data set as per Hadley Wickham's criteria <link>http://vita.had.co.nz/papers/tidy-data.pdf</link>

Script Steps
-----
Here is a breakdown of how the **run_analysis.R** script accomplishes each step:

####1.  Read the Data into a Data Table####
First, we need to go into the 'test' and 'train' directories and pull the data into an R Datatable.  This involves taking the 3 relevant files (*subject_test.txt, X_test.txt, and Y_test.txt* in the test directory), reading them each into a table, and then combining them with *cbind*.

####2.  Merge Training and Testing####
Once we have executed step 1 for both the training and testing sets, we can simply combine them with *rbind* and sort at will.

####3.  Extract Out Only Mean and Standard Deviation Measurements from the Dataset####
This involves removing all of the 561 features that don't directly capture a mean or standard deviation.  According to the **features_info.txt** file, there were several variables that were estimated over a single signal within a sliding time window.  Two of these variables were *mean()* and *std()*.  I took the other instances of 'mean' such as *tBodyAccMean* to be averages of multiple signals and not intended to be included in the final dataset.  So to extract out these variables, I was able to limit the columns to those with *mean()* or *std()* in their name.

####4. Give Meaningful, Understandable Names to Activities####
This was done by reading **activity_labels.txt**, which was included with the dataset, into a data table and using it as a lookup table for the numeric activity designations in the *Y_test.txt* or *Y_train.txt* files.

####5. Give Meaningful, Understandable Names to Measurements####
This was accomplished by applying a series of regex substitutions to the column names to make them both human-readable and R-legal.

####6. Aggregate the Data & Return a Tidy Dataset
At this point the data was already tidy, so we simply apply a simple aggregation function to the data to group it by subject/activity and calculate the mean.


Tidy Data
-----

To briefly summarize what makes the output file of this script Tidy Data, the output will have the following characteristics (borrowed from http://jtleek.com/modules/03_GettingData/01_03_componentsOfTidyData/#4)

1.  Each variable you measure should be in one column
2.  Each different observation of that variable should be in a different row
3.  There should be one table for each "kind" of variable
4.  If you have multiple tables, they should include a column in the table that allows them to be linked


Getting Started with run_analysis.R
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

      setwd("<working directory>/UCI HAR dataset")
      source("run_analysis.R")
      my.analysis = run_analysis()
      write.table(my.analysis, file="test1.txt", row.names = FALSE)


Dataset Overview
-----
This repository also contains a tidy dataset, **tidy_hca_output.txt**, that you can read in and peruse using the following command:

      tidy_hca <- read.table("tidy_hca_output.txt", header = TRUE)
      
Dataset Notes
-----
The data set represents the 'wide' interpretation of tidy data.  To make this dataset tidy in its strictest sense, there would be only 4 columns (subject, activity, variable, measurement).  However, this dataset takes the approach that all 66 measurements for a particular subject/activity could also be considered a single observation.


