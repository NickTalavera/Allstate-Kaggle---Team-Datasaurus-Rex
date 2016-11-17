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
trainData_cat <- cbind(trainData[,1:117],trainData[,-1])
head(trainData_cat)
trainData_num <- cbind(trainData[,118:ncol(trainData)])
head(trainData_num)

# trainData[, grepl("cont", names(trainData))]
head(trainData)
testData$loss = NA
testData$cont

dataBoth = rbind(testData,trainData)
ultimateData = kNN(dataBoth, variable = "loss")
head(ultimateData)
