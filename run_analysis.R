### Miscellaneaous #############################################################

# Import packages
library(data.table)

# Working directory
wd <- getwd()

### Data #######################################################################

# Download the zipped file in the data folder and unzip file in the same folder.
# The data will only be loaded/extracted once.

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



