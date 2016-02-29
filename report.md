Practical Machine Learning: Course Project.
===================================

### Author: Peter Glushkov, 28 Feb 2016

### link to the repository : https://github.com/pglushkov/PracticalMachineLearning_Course

## Executive Summary

In current assignment we have to study data collected by sensors placed on a human body. The sensors were collecting
data while people performed sport exercises, namely weight lifting. Exercises were executed by 6 different people in
5 distinct ways. One of those 5 ways of execution is the correct way, while others are performed erroneously on
purpose. The goal of the research is to train a model, that can classify these types of exercise executions and later
predict them by examining input data from sensors.

By using combination of methods (namely Logistic Regression and Random Foresets) a model was trained that showed 79%
accuracy in classifying the input data.

## Dataset description (based on R manual):
Data was collected by a group of enthusiasts who take measurements about themselves regularly to improve their health,
to find patterns in their behavior. Purpose of this data set was to quantify how well they do a particular exercise.
Data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants was collected. Participants were asked
to perform barbell lifts correctly and incorrectly in 5 different ways.
More information is available from the website here: http://groupware.les.inf.puc-rio.br/har

## Step 1. Cleaning the data.

Dataset was presented inside a .csv file and originally contained over 19000 measurements of 160 variables. First step
was to thoroughly examine the data and clean it up to get rid of all bad, inconsistent or plainly absent measurements.

It was found, that about 12 variables did not contain any measurements and were simply discriptional (e.g. time
of the measurement, name of the participant, etc.). For our task these 'administrative' data does not have direct
value, because we want to train model, that works on input from sensors only. This way, about 12 variables could be
safely removed from the dataset.

Next step revealed, that many variables in the data set, that practically don't contain any actual valid data. 99% of
values contained in those variables were empty, NAN or  DIV/0 values. Training a numerical model using such inputs might
give very misleading result. Getting rid of these non-informative variables had shown, that in fact only about 30% of
variables in a given dataset can put to good use.

All in all it was found that only 52 variables from input dataset contain valid values along whole dataset samples. To
see final list of these variables and method of their extraction - refer to Appendix A.

## Step 2. Initial analysis.

After cleaning the dataset at step 1, left variables were studied more thoroughly in order to find their relation to
our outcome of interest - a 'classe' variable that labeled the type of exercise execution. In order to do that,
variables were grouped by their type and plotted in pairs. Additionally, their distributions were examined with relation
to 'classe' in order to find out which of them could be separated out and on what conditions. A few examples of plotted
graphs are shown bellow :


```r
  source('read_and_clean_data.R');
  DATA = read_and_clean_data('pml-training.csv');

  scatterplotMatrix(~ pitch_belt + roll_belt + yaw_belt|classe, data=DATA,  main="Belt angles",
        smoother="", reg.line="")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)
In given example, it can be seen that 'roll_belt' variable has a density that clearly stands for class E vs the rest of
the classes.


```r
  source('read_and_clean_data.R');
  DATA = read_and_clean_data('pml-training.csv');

  scatterplotMatrix(~ gyros_arm_x + gyros_arm_y + gyros_arm_z|classe, data=DATA,  main="Arm gyro",
				smoother="", reg.line="")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

On this graph we can distinct out class A by examining 'gyros_arm_x' variable, because its density under case 'A' is
very different from its densities under all other cases.

By manually examining all variables in such manner (there were 52 variables and about 17 graphs all-in-all), it was
found that only 37 variables seem to have some separable densities and thus can be used as indirect clues classify the
input data.

Complete list of these 37 variables and details on building the graphs can be found at Appendix B.

## Step 3. Selecting approach to train the model.

Straight ahead try of training a classification model on formed dataset failed miserably. Resulting dataset contained
37 variables and over 19000 samples. Even after dividing the dataset on training / testing set in proportion 7:3, it
still took several hours to train a one single model. Training Random Forest model took over 4hrs on Intel Core i5x2
machine under Ubuntu 14.04 and still could not be finished. Training GBM model could not be accomplished as well - 3
tries all finished in machine hanging-up completely after 40 mins of work.

Reasons of such failures were not studieddeeply, as this was not the main goal of the research. It was clear that some
less computationally expensive approach had to be found in order to complete the assignment.

## Step 4. Using logistic regression, tuning the classifier

After realizing, that direct approach could not allow any interactive training and experimentation, a different less
computationally expensive approach  was selected:

 - train a 'simple' Logistic Regression based binary classifier for each class (i.e. train one classifier that only
   recognizes class A from all the rest, that another that only recognizes class B from all the reset, etc.)
 - at prediction stage - run input sample through all trained classifiers and select the one with the maximum output -
   this maximum would be than used as a result of classification (i.e. if classifier for class C showed maximum output
   at some sample - this sample was classified as C)

Input dataset was split in 6:4 proportion on training and test sets correspondingly. 5 binary classifiers were trained -
one for each class of outcome. 37 variables from Step 2 were initially used. Model performance was evaluated on the test
set. Results are as follows:

* Accuracy of binary classifier for class A : 0.890008
* Accuracy of binary classifier for class B : 0.849223
* Accuracy of binary classifier for class C : 0.836605
* Accuracy of binary classifier for class D : 0.880321
* Accuracy of binary classifier for class E : 0.880704
* ONE-VS-ALL final model accuracy : 0.681876

Training of such model took just several seconds and its accuracy was already about 68% which seemed a promising start.

Next step was to evaluate, if throwing away some variables at Step 2 was a good move. All throwed-away variables were
taken back and binary classifiers were trained once again but this time using all 52 variables. Results were as follows:

* Accuracy of binary classifier for class A : 0.904920
* Accuracy of binary classifier for class B : 0.865409
* Accuracy of binary classifier for class C : 0.867066
* Accuracy of binary classifier for class D : 0.896890
* Accuracy of binary classifier for class E : 0.905302
* ONE-VS-ALL final model accuracy : 0.737318

Accuracy increased 5% comparing with 37-variable classifier. Training the model took a few seconds longer, and result
was considerably better.

Details on implementation of this classifiers can be found at Appendix C.

## Step 5. Staking the classifiers.

Failing to train a Random Forest based classifier or GBM-based classifier on a full dataset due to lack of computational
resources, it was decided to use model-stacking and train the Random Forest classifier on stacked outputs.

Results of binary classification of input data from training set were stacked into a dataset and 'classe' variable from
the training set was added to it as well. That gave as a training set with 5 variables and about 0.6 * 19000 samples.
Random Forest classifier that was trained on this data and its performance was evaluated on test dataset.

It took about 8 mins to train a Random Forest classifier on such input dataset and its accuracy was about 79%, which is
a general increase over initial one-vs-all based classifier.

An attempt to train GBM classifier over this new dataset still failed - PC again hung-up completely after about 10 mins
of processing. Maybe reason to this is some unfortunate combination of hardware and installed software. This issue was
not studied in detail.

For details on forming stacked dataset for Random Forest classifier please refer to Appendix D.


## Conclusions

* Combined model was used for classification. It involved stacking several Logistic Regression based binary classifiers
  into a final Random Forest based classifier
* Training the whole model took slightly more that 8 minutes
* Final model accuracy was estimated as 79% based on test set that contained 40% of initial data
* More computationally expensive approaches were not studied due to hardware limitations


# Appendix A

by looking through a data, two steps of cleaning it up were performed:

1. Removing all 'administrative' data, leaving only samples with actual measurements from sensors. This was done by
   running through names of columns in initial dataset and leaving only columns, whose names contained words 'arm',
   'belt', 'dumbbell', 'forearm'. All other columns did not contain data that was directly derived from measurements.
2. Removing all columns, data in which 99% consisted of 'NAN' or empty values or 'DIV/0'. It was found, that function
   read.csv() classified such columns as 'factor' columns. So second step basically was : remove all factor-columns from
   what is left after Step 1.

Code that performed these operations can be found in file 'read_and_clean_data.R'


# Appendix B

Data, returned by 'read_and_clean_data.R' was than analyzed by grouping variables and plotting densities and
scatterplots of pairs in those groups. Additional color labeling was made to show which sample related to which class.
Groups of variables were as follows:

* Total accelerations :     total_accel_belt + total_accel_arm + total_accel_dumbbell + total_accel_forearm
* Belt angels:              roll_belt + pitch_belt + yaw_belt
* Belt gyro:                gyros_belt_x + gyros_belt_y + gyros_belt_z
* Belt accelerometer:       accel_belt_x + accel_belt_y + accel_belt_z
* Belt magnet:              magnet_belt_x + magnet_belt_y + magnet_belt_z
* Arm angles:               roll_arm + pitch_arm + yaw_arm
* Arm gyro:                 gyros_arm_x + gyros_arm_y + gyros_arm_z
* Arm accelerometer:        accel_arm_x + accel_arm_y + accel_arm_z
* Arm magnet:               magnet_arm_x + magnet_arm_y + magnet_arm_z
* Dumbbell angels:          roll_dumbbell + pitch_dumbbell + yaw_dumbbell
* Dumbbell gyro:            gyros_dumbbell_x + gyros_dumbbell_y + gyros_dumbbell_z
* Dumbbell accelerometer:   accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z
* Dumbbell magnet:          magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z
* Forearm angels:           roll_forearm + pitch_forearm + yaw_forearm
* Forearm gyro:             gyros_forearm_x + gyros_forearm_y + gyros_forearm_z
* Forearm accelerometer:    accel_forearm_x + accel_forearm_y + accel_forearm_z
* Forearm magnet:           magnet_forearm_x + magnet_forearm_y + magnet_forearm_z

Code for plotting the graphs can be found at file 'run_analysis.R'. Few examples of plots are show in the main report.

After analyzing the graphs, only 37 variables were found informative for initial analysis, namely:

* total_accel_belt + total_accel_arm + total_accel_forearm
* accel_arm_x + accel_arm_z
* roll_arm + pitch_arm + yaw_arm
* gyros_arm_x + gyros_arm_y + gyros_arm_z
* magnet_arm_x + magnet_arm_y + magnet_arm_z
* roll_belt + pitch_belt + yaw_belt
* gyros_belt_x + gyros_belt_y + gyros_belt_z
* magnet_belt_x + magnet_belt_y + magnet_belt_z
* accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z
* roll_dumbbell + pitch_dumbbell + yaw_dumbbell
* magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z
* accel_forearm_x
* roll_forearm + pitch_forearm + yaw_forearm
* magnet_forearm_x + magnet_forearm_y

# Appendix C

Initial classifier was designed as follows:
* set of classifiers trained to distinguish one class out of all the reset were trained for each class
* resulting classifier took classification results from binary classifiers and selected one that showed maximum
  likelihood as a final result of classification

To make this work, further actions were made:

1. Initial data was acquired by means of function 'read_and_clean_data()'
2. Data then was split to specified proportion on a training and test sets
3. For each existing class: create new training set by labeling all samples of this class with 1 and all other samples
   with 0; train Logistic Regression classifier using binomial family distributions;
4. Run prediction procedure for each binary classifier using test data
5. Select classifier that shown biggest output
6. Name result of classification according to selected maximum

Results of implementation of this classifier can be found at file 'run_total_logreg.R'


# Appendix D

Stacked dataset for training Random Forest classifier was formed as follows:
* calculate predictions of each binary classifier for training dataset, call those vectors of predictions : train1,
  train2 ... trainN
* claculate predictions of each binary classifier for test dataset, call those vectors of predictions: test1, test2, ...
  testN
* form training set for Random Forest as [train1  train2 ... trainN], add 'classe' columng from initial training dataset
  to this set
* form test set for Random Forest as [test1  test2 ... testN], add 'classe' columng from initial test dataset to this
  set

Implementation of described procedures can be found in file 'run_total_logreg.R'. In fact - result of this function is
a list, containing:

1. Stacked training dataset
2. Stacked test dataset
3. List of individual trained binary classifiers

Code that creates the stacked datasets and runs model training and evaluation can be found at 'run_training,R' file.
