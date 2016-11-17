# rm(list = ls())
library(class)
library(qdapRegex)
library(kknn) #Load the weighted knn library.
library(VIM) #For the visualization and imputation of missing values.
library(ggplot2)
library(stringr)
library(Hmisc)
library(stringi)
library(dplyr)
setwd('/Users/nicktalavera/Coding/NYC_Data_Science_Academy/Projects/Allstate-Kaggle---Team-Datasaurus-Rex')
dataFolder = './Data/'
nrows= 1000
testData = read.csv(paste0(dataFolder,'test.csv'), nrows = nrows)
trainData = read.csv(paste0(dataFolder,'train.csv'), nrows = nrows)
cat_var <- names(trainData)[which(sapply(trainData, is.character))]
num_var <- names(trainData)[which(sapply(trainData, is.numeric))]
num_var <- setdiff(num_var, c("id", "loss"))
trainData_cat <- dt_train[,.SD, .SDcols = cat_var]
trainData_num <- dt_train[,.SD,.SDcols = num_var]

# trainData[, grepl("cont", names(trainData))]
head(trainData)
testData$loss = NA
dataBoth = rbind(testData,trainData)
ultimateData = kNN(dataBoth, variable = "loss")
head(ultimateData)
