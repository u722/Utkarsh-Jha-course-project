# read activity labels
activity<- read.table("activity_labels.txt", col.names=c("symbol", "act")) 

# read data description
features<- read.table("features.txt", col.names=c("signals", "signal_features"))

#read train data
X<- read.table("X_train.txt")
Y<- read.table("Y_train.txt")
S<- read.table("subject_train.txt")

#read test data
X1<- read.table("X_test.txt")
Y1<- read.table("Y_test.txt")

S1<- read.table("subject_test.txt")

#merges training set and test set 
Xtotal<- rbind(X, X1)
Ytotal<- rbind(Y, Y1)
Stotal<- rbind(S, S1)

#Uses descriptive activity names to name the activities in the data set
for( i in 1:nrow(Ytotal))
{for(j in 1:nrow(activity))
{if(Ytotal$V1[i]==activity$symbol[j])
Ytotal$V1[i]<- activity$act[j]}
}


#appropriately lables the data set with descriptive variable name
names(Xtotal)<- features$signal_features
names(Xtotal)<- sub("-","", names(Xtotal))
names(Ytotal)<- "symbol"
names(Stotal)<- "subject"

library(dplyr)

#Extracts only the measurements on the mean and std deviation for each measurement
Xtotal<- select(Xtotal, contains("mean()")|contains("std()"))


#Merges the training set and the test set along with all the labels and subjects to create 1 dataset
totalset<- cbind(Xtotal, Ytotal, Stotal)

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyset<- totalset %>% group_by(Ytotal, volunteer) %>% summarize_each(funs(mean))

write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)


