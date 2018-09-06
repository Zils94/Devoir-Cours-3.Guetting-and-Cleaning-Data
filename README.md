# Geting and Cleanning Data Project : Human Activity Recognition Using Smartphones Data Set

## Introduction:

The goal of this project is to clean raw data in order to create a tidy data set that can be used for later analysis.

The data source provided is can be found here : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Along with some explanation : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Run_analysis.R:

We started by loading data file :

    # Library

    library(dplyr)

    # Define Working Directory

    wd<-"/Users/Zils2/Downloads/UCI HAR Dataset/"
    setwd(wd)

    # Open file

    #Data

    features<-read.table("features.txt")
    activity<-read.table("activity_labels.txt")

    #Test
    X_test<-read.table("test/X_test.txt")
    y_test<-read.table("test/y_test.txt")
    subject_test<-read.table("test/subject_test.txt")

    #Train
    X_train<-read.table("train/X_train.txt")
    y_train<-read.table("train/y_train.txt")
    subject_train<-read.table("train/subject_train.txt")

Then we bind the "test" data with the "train" data for the X's variables,y variable and subject variable:

    # Step 1 : Merging File

    X<-bind_rows(X_train,X_test)
    y<-bind_rows(y_train,y_test)
    subject<-bind_rows(subject_train,subject_test)
    df<-bind_cols(subject,X,y)

We rename the variable of this dataset so that they can be descriptive :

    # Step 4 : Label the data with descriptive variables names

    names(df)<-c("subject",as.character(features[,2]),"Activity")

We then select only measurement based on mean and std :

    # Step 2 : Keeping only measurements based on mean and standard deviation
      
    df<-df[,c("subject",grep("[Mm]ean\\(|[Ss]td",names(df),value = TRUE),"Activity")]
    

We use the descriptive activity names :

A way to do it is to merge our df with the data activity and then retain only the variable V2 (then changing its name to "activity")

    # Step 3 : Use descriptive activity names to name the variable Activity

    df<-merge(df,activity,by.x = 'Activity', by.y = 'V1', all.x = TRUE)
    df <- df %>%
    select(-Activity) %>%
    rename(Activity = V2)

Finally, we create a tidy data set which give the mean of all variables grouping by Activity and subject :

    # Step 5 : Creating a tidy data with avg of each variables by activity and subject

    tidydf<- df %>%
    group_by(subject,Activity) %>%
    summarize_all(funs(mean))

    write.table(tidydf,file = 'tidy_data.txt',row.names = FALSE)

