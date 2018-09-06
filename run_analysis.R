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

# Step 1 : Merging File

X<-bind_rows(X_train,X_test)
y<-bind_rows(y_train,y_test)
subject<-bind_rows(subject_train,subject_test)
df<-bind_cols(subject,X,y)
      
# Step 4 : Label the data with descriptive variables names

names(df)<-c("subject",as.character(features[,2]),"Activity")


# Step 2 : Keeping only measurements based on mean and standard deviation
      
df<-df[,c("subject",grep("[Mm]ean\\(|[Ss]td",names(df),value = TRUE),"Activity")]



# Step 5 : Creating a tidy data with avg of each variables by activity and subject

tidydf<- df %>%
  group_by(subject,Activity) %>%
  summarize_all(funs(mean))

write.table(tidydf,file = 'tidy_data.txt',row.names = FALSE)

