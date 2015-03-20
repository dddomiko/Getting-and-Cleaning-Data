CodeBook
========
This Codebook was generated on 2015-03-20 23:31:44.

Overview
--------

Variable name | Description
--------------|------------
subject       | Subject ID of the 30 volunteers
activity      | Activity name ()
domain        | Time domain signal or frequency domain signal (Time or Freq)
instrument    | Measuring instrument (Accelerometer or Gyroscope)
signal        | Acceleration signal (Body or Gravity)
jerk          | Jerk signal
magnitude     | Magnitude of the signals
axis          | 3-axial signals in the X, Y and Z directions (X, Y, or Z)
measure       | Measure (Mean or SD = standard deviation)
count         | Count of data points
avg           | Average of each variable for each activity and each subject

Dataset structure
-----------------


```r
str(data.tidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject   : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity  : Factor w/ 6 levels "laying","sitting",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain    : Factor w/ 2 levels "Frequency","Time": 1 1 1 1 1 1 1 1 1 1 ...
##  $ instrument: Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ signal    : Factor w/ 2 levels "Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ jerk      : Factor w/ 1 level "Jerk": NA NA NA NA NA NA NA NA 1 1 ...
##  $ magnitude : Factor w/ 1 level "Magnitude": NA NA NA NA NA NA 1 1 NA NA ...
##  $ measure   : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ axis      : Factor w/ 3 levels "X","Y","Z": 1 2 3 1 2 3 NA NA 1 2 ...
##  $ count     : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ avg       : num  -0.939 -0.867 -0.883 -0.924 -0.834 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "domain" "instrument" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

Dataset excerpt
---------------


```r
data.tidy
```

```
##        subject         activity    domain    instrument signal jerk
##     1:       1           laying Frequency Accelerometer   Body   NA
##     2:       1           laying Frequency Accelerometer   Body   NA
##     3:       1           laying Frequency Accelerometer   Body   NA
##     4:       1           laying Frequency Accelerometer   Body   NA
##     5:       1           laying Frequency Accelerometer   Body   NA
##    ---                                                             
## 11876:      30 walking_upstairs      Time     Gyroscope     NA Jerk
## 11877:      30 walking_upstairs      Time     Gyroscope     NA Jerk
## 11878:      30 walking_upstairs      Time     Gyroscope     NA Jerk
## 11879:      30 walking_upstairs      Time     Gyroscope     NA Jerk
## 11880:      30 walking_upstairs      Time     Gyroscope     NA Jerk
##        magnitude measure axis count     avg
##     1:        NA    Mean    X    50 -0.9391
##     2:        NA    Mean    Y    50 -0.8671
##     3:        NA    Mean    Z    50 -0.8827
##     4:        NA      SD    X    50 -0.9244
##     5:        NA      SD    Y    50 -0.8336
##    ---                                     
## 11876:        NA      SD    X    65 -0.7427
## 11877:        NA      SD    Y    65 -0.7433
## 11878:        NA      SD    Z    65 -0.6652
## 11879: Magnitude    Mean   NA    65 -0.7188
## 11880: Magnitude      SD   NA    65 -0.7744
```

Summary of variables
--------------------


```r
summary(data.tidy)
```

```
##     subject                   activity          domain    
##  Min.   : 1.0   laying            :1980   Frequency:4680  
##  1st Qu.: 8.0   sitting           :1980   Time     :7200  
##  Median :15.5   standing          :1980                   
##  Mean   :15.5   walking           :1980                   
##  3rd Qu.:23.0   walking_downstairs:1980                   
##  Max.   :30.0   walking_upstairs  :1980                   
##          instrument       signal       jerk          magnitude   
##  Accelerometer:7200   Body   :5760   Jerk:4680   Magnitude:3240  
##  Gyroscope    :4680   Gravity:1440   NA's:7200   NA's     :8640  
##                       NA's   :4680                               
##                                                                  
##                                                                  
##                                                                  
##  measure       axis          count           avg         
##  Mean:5940   X   :2880   Min.   :36.0   Min.   :-0.9977  
##  SD  :5940   Y   :2880   1st Qu.:49.0   1st Qu.:-0.9621  
##              Z   :2880   Median :54.5   Median :-0.4699  
##              NA's:3240   Mean   :57.2   Mean   :-0.4844  
##                          3rd Qu.:63.2   3rd Qu.:-0.0784  
##                          Max.   :95.0   Max.   : 0.9745
```

Data preparation
================

1. Download zip-file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Unzip file
3. Merge the training and test sets to create `one` dataset (`subject_test.txt`,`X_test.txt`,`y_test.txt`,`subject_train.txt`,`X_train.txt`,`y_train.txt`)
4. Name the columns (`features.txt`)
5. Extract only the measurements on the `mean` and `standard deviation` for each measurement
6. Label the target variable with the activity names (`activity_labels.txt`)
7. Reshape data from wide to long format
8. Create new variables for hidden information in the feature description
9. Calculate the average of each variable for each activity and each subject
