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
library(plyr)
setwd('/Users/nicktalavera/Coding/NYC_Data_Science_Academy/Projects/Allstate-Kaggle---Team-Datasaurus-Rex')
dataFolder = './Data/'
if (!exists("testData")) { 
  testData = read.csv(paste0(dataFolder,'test.csv'))
}
if (!exists("trainData")) { 
  trainData = read.csv(paste0(dataFolder,'train.csv'))
}
trainData_cat <- cbind(trainData[,1:117])
trainData_num <- cbind(trainData[,118:ncol(trainData)])
# head(trainData_num)
# trainData_num.describe()
# trainData[, grepl("cont", names(trainData))]
# head(trainData)
testData$loss = NA

chiSquareAllColumns = function(data){
  chiResults = data.frame(matrix(ncol = 0, nrow = ncol(data)))
  head(chiResults)
  for(columnNameInner in names(data)){
    print(paste("columnNameInner:", columnNameInner))
    chiResults[,columnNameInner] = apply(data, 2 , function(i) chisq.test(table(data[,columnNameInner] , i ))$p.value)
    print(summary(chiResults))
  }
  chiResults[chiResults > 0.05] = 'Inisgnificant'
  return(chiResults)
}
chiSquareAllColumns(trainData_num)