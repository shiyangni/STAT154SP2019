## STAT154 Machine Learning SP2019
## Project 2

- Introduction

A comprehensive practice on building and critiquing binary classifiers. 

- Reproducibility

To recreate the report, simply download the `Project Folder`, open `Project Folder/report/Report.Rmd`, and Knit. 

There is only minor content change between the final report in PDF format and the Knitted report. Most adjustments are cosmetic.

Most code is written in R. Some models are implemented in Python for speed purpose. We included the Python output in `Report.Rmd` using assignment statements. For raw Python outputs, please see relevant code under `Project Folder/code`.

#### 1 Data Collection and Exploration

* Load the txt files for the three images with the code in *STAT154Project2.Rmd* file using read.table
* Visual and quantiative EDA were performed with the *dplyr* and *ggplot2* packages. Check the:
  + Summary of the distribution of all 11 feature columns
  + 3 plots for each image distinguishing the regions according to different expert labels

#### 2 Preparation

**Data Splitting**

* Split Method 1
  + Load the code for split method 2 from *Project 2.Rmd* file.
  + Split each dataframe for each image into four quadrants using *subset* according to x and y coordinates
  + For each dataframe representing each quadrant (see the justification for this split in the project report pdf), split the train and test sets in the method described below:
  + Use *caret* package and *createDataPartition* function to split train, validation, and test data. First split the train and test data 80 to 20%, and then split the train data into train and validation sets 75 to 25%. 
  + For each split for the 12 quadrants, use *rbind* to concatenate them to the complete train, validation, and test sets.

* Split Method 2
  + Load the code for split method 1 from *Project 2.Rmd* file.
  + This method will be an iid random split. Leave the full data from *image 3* will be used as the test set. For the remaining two images, merge the two using *rbind* and use *createDataPartition* like split method 1 to randomly split 75% training and 25% validation sets.
  

**The trivial classifier**



**Feature Selection**

* histograms displaying correlation of different features were used, graphed by *ggplot2* package, to visualize and analyze the relationship between features. 


**CVGeneric Function**

```{r}
@title CVgeneric
@description A generic function that takes in a training set(label, features), a loss function,
a model, and performs K-fold validation across the training set. Folds are created using random
sampling without replacement.

train_labels and train_features are assumed to be in tidy format with mathcing number of rows.

model should be passable into R's built in predict function to generate prediction.

loss function should take in both true labels and estimated labels, and returns an error.

Notice we are assuming the labels are named "expert_label".

Further Notice we assume the two classes are encoded 0 and 1.

@return A list of three: Loss for each fold, Average Loss, and Time consumed for validation.
```{r}




