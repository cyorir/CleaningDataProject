# dplyr is used for its modified filter() function
library(dplyr)

# read in the data
unzip("UCI_HAR_Dataset.zip")
test_dat <- read.table(file.path("test", "X_test.txt"))
train_dat <- read.table(file.path("train", "X_train.txt"))
dat_names <- read.table("features.txt")

# label the columns
colnames(test_dat) <- dat_names[,2]
colnames(train_dat) <- dat_names[,2]

# merge the test data and training data
all_dat <- rbind(test_dat, train_dat)

# extract only the columns measuring a mean or standard deviation
mean_std_cols <- filter(dat_names, grepl("mean",V2) | grepl("std",V2))
all_dat <- all_dat[,mean_std_cols[,1]]

# read in the activity for each observation
test_lab <- read.table(file.path("test","y_test.txt"))
train_lab <- read.table(file.path("train","y_train.txt"))
all_lab <- rbind(test_lab, train_lab)

# transform numeric activity labels into descriptive labels
activity_map <- read.table("activity_labels.txt")
activity <- apply(all_lab, MARGIN = 1, FUN = function(lab) {activity_map[lab,2]})

# apply activity labels to each observation
all_dat <- cbind(activity, all_dat)

# read in the subject for each observation
test_sub <- read.table(file.path("test","subject_test.txt"))
train_sub <- read.table(file.path("train","subject_train.txt"))
subject <- rbind(test_sub,train_sub)

# apply subject label to each observation
all_dat <- cbind(subject, all_dat)
colnames(all_dat)[1] <- "subject"

# output first tidy data set
write.table(all_dat, "tidy_activity.txt", row.names = FALSE)
dat_names <- colnames(all_dat)

# group data by subject and activity and take the mean
all_dat <- mutate(all_dat, subject = paste(subject, activity))
all_dat <- apply(all_dat[,c(-1,-2)], 2, function(column) tapply(column, all_dat$subject, mean))

# subject and acivity is stored in row names; recover as separate columns
subject_activity <- strsplit(row.names(all_dat), split = " ")
all_dat <- cbind(matrix(unlist(subject_activity), nrow = 180, byrow = TRUE),data.frame(all_dat))
colnames(all_dat) <- dat_names

# output second tidy data set
write.table(all_dat, "tidy_activity_averages.txt", row.names = FALSE)