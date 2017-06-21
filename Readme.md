## Analysis steps

The code in the run_analysis.R file was used to produce the tidy dataset for this assignment. It is described here.

The initial dataset is given by the "UCI_HAR_Dataset.zip," which unpacks into the necessary source data files. As long as the files unzip to the proper locations relative to the working directory, the run_analysis.R code should be able to find them.

First, the test and training data are read in from "test/X_test.txt" and "train/X_train.txt," resepectively. The feature labels are read in from "features.txt" and applied to the columns of both the testing and training data. The testing and training data are then bound into a single data frame.

The list of feature names is filtered with grep to find only the features of interest; those are the mean() and std() signal estimates. Dplyr's filter function is then used to reduce the data to only those features.

The activity and subject associated with each observation must be separately read in from the files "test/y_test.txt" "train/y_train.txt" "test/subject_test.txt" and "train/subject_train.txt". The activities are mapped from numeric indicators (1 through 6) to more descriptive activity labels, as indicated in "activity_labels.txt". The subject and activity labels are then bound to the data set in the same order as the observations they correspond to.

At this point, the data set is almost tidy; information has been compacted into a single file, with only the features of interest selected. However, there are still many observations per subject-activity pair.

To remedy this, observations are grouped by their subject and activity labels. The mean is then taken across all observations of the same subject-activity pair. This compacts the roughly ~10000 observations into 180, without changing the units of the data. Subject and activity are retained as distinct labels. This compacted data set is now tidy, and is output in "tidy_activity_averages.txt"
