### Miscellaneaous #############################################################

# Import packages
library(data.table)
library(reshape2)

# Working directory
wd <- getwd()
data.wd <- file.path(wd,"data","UCI HAR Dataset")

### Data #######################################################################

## Download the zipped file in the data folder and unzip file in the same folder.
## The data will only be loaded/extracted once.

# Data source
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Create folder
if(!file.exists(file.path(wd,"data"))){
  dir.create(file.path(wd,"data"))
}

# Download zipped file
if(!file.exists(file.path(wd,"data","data.zip"))){ 
  download.file(url, file.path(wd,"data","data.zip")) 
}

# Extract files from data.zip
if(!file.exists(file.path(wd,"data","UCI HAR Dataset"))){ 
  unzip(file.path(wd,"data","data.zip"), exdir = file.path(wd,"data"))
}

# Check data
list.files(file.path(wd,"data"))

# Import data
data.train.x       <- read.table(file.path(data.wd,"train","X_train.txt"))
data.train.y       <- read.table(file.path(data.wd,"train","Y_train.txt"))
data.train.subject <- read.table(file.path(data.wd,"train","subject_train.txt"))

data.test.x        <- read.table(file.path(data.wd,"test","X_test.txt"))
data.test.y        <- read.table(file.path(data.wd,"test","Y_test.txt"))
data.test.subject  <- read.table(file.path(data.wd,"test","subject_test.txt"))


### Task 1 ---------------------------------------------------------------------

## Merge the training and the test sets to create one data set.

# Merge subject & Y & X 
data.train <- cbind(data.train.subject, data.train.y, data.train.x)
data.test  <- cbind(data.test.subject,  data.test.y,  data.test.x)

# Merge train & test
data <- rbind(data.train, data.test)
colnames(data) <- c("subject","y",colnames(data)[-(1:2)])

# Convert to data.table
data <- data.table(data)

### Task 2 ---------------------------------------------------------------------

## Extract only the measurements on the mean and standard deviation for each 
## measurement. 

# Import features.txt
data.features <- read.table(file.path(data.wd,"features.txt"), 
                            stringsAsFactors = FALSE)
colnames(data.features) <- c("feature","description")

# Set colnames
setnames(data,colnames(data),c("subject","y",data.features$description))

# Extract all variables containing "mean()" of "std()"
data <- data[,c(1,2,grep("(mean|std)\\(\\)", colnames(data))), with = FALSE]

### Task 3 ---------------------------------------------------------------------

## Use descriptive activity names to name the activities in the data set.

# Import activity names
data.activity.names <- read.table(file.path(data.wd,"activity_labels.txt"))
colnames(data.activity.names) <- c("y","activity")
data.activity.names$activity <- tolower(data.activity.names$activity)
data.activity.names <- data.table(data.activity.names)

# Merge activity names to the main data set
setkey(data, subject, y)
setkey(data.activity.names, y)

data <- merge(data, data.activity.names, by = "y", all.x = TRUE)

### Task 4 ---------------------------------------------------------------------

## Appropriately label the data set with descriptive variable names. 

# Reshape data from wide to long format
setkey(data, subject, y, activity)
data <- data.table(melt(data, key(data)))

data[,activity := as.factor(activity)]

# create new variables for hidden information in the feeature description.
# (see http://vita.had.co.nz/papers/tidy-data.pdf)

# Domain signals (t = Time; f = Frequency)
data[, domain := factor(ifelse(substr(variable,1,1) == "t", "Time", 
                               ifelse(substr(variable,1,1) == "f", "Frequency", NA)))]

# Measuring instrufmen (Acc = Accelerometer; Gyro = Gyroscope)
data[, instrument := factor(ifelse(grepl("Acc", variable), "Accelerometer", 
                                   ifelse(grepl("Gyro", variable), "Gyroscope", NA)))]

# Acceleration signal (BodyAcc = Body; GravityAcc = Gravity)
data[, signal := factor(ifelse(grepl("BodyAcc", variable), "Body",
                              ifelse(grepl("GravityAcc", variable), "Gravity", NA)))]

# Measure (mean = Mean, SD = Standard deviation)
data[, measure := factor(ifelse(grepl("mean()", variable), "Mean",
                              ifelse(grepl("std()", variable), "SD", NA)))]

# Jerk signals (Jerk = Jerk)
data[, jerk := factor(ifelse(grepl("Jerk", variable), "Jerk", NA))]

# Magnitude (Mag = Magnitude)
data[, magnitude := factor(ifelse(grepl("Mag", variable), "Magnitude", NA))]

# Axis (X,Y,Z)
data[, axis := factor(ifelse(grepl("-X", variable), "X",
                               ifelse(grepl("-Y", variable), "Y", 
                                      ifelse(grepl("-Z", variable), "Z", NA))))]

# drop variable & y
data[, variable := NULL]
data[, y := NULL]

# save data
save(data,file=file.path(wd,"data","data.RData"))

### Task 5 ---------------------------------------------------------------------

## From the data set in step 4, create a second, independent tidy data set with 
## the average of each variable for each activity and each subject.


setkey(data, subject, activity, domain, instrument, signal, 
       jerk, magnitude, measure)
data.tidy <- data[, list(count = .N, avg = mean(value)), by = key(data)]

# save data
save(data.tidy,file=file.path(wd,"data","data_tidy.RData"))


