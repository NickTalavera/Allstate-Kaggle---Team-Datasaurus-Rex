# Parameters
subset_ratio = 0.1
parallelize = TRUE
output = TRUE
plot.model = TRUE

# Add parallelization
if(parallelize){
  library(doParallel)
  cores.number = detectCores(all.tests = FALSE, logical = TRUE)
  cl = makeCluster(2)
  registerDoParallel(cl, cores=cores.number)
}

# Read training and test data
library(data.table)
as_train <- fread("../Data/train.csv", drop=c("id"))
as_test <- fread("../Data/test.csv", drop=c("id"))

# Subset the data
library(caret)
training_subset = createDataPartition(y = as_train$loss, p = subset_ratio, list = FALSE)
as_train <- as_train[training_subset, ]
testing_subset = createDataPartition(y = as_test$cat1, p = subset_ratio, list = FALSE)
as_test = as_train[testing_subset, ]

# Pre-processing
library(dplyr)
preProc <- preProcess(as_train %>% select(-loss), 
                      method = c("nzv", "center", "scale"))

dm_train = predict(preProc, newdata = as_train %>% select(-loss))
dm_test = predict(preProc, newdata = as_test)


# Setting up the cross-validation
set.seed(0)

# Partition training data into train and test split
trainIdx <- createDataPartition(as_train$loss, 
                                p = .8,
                                list = FALSE,
                                times = 1)
subTrain <- dm_train[trainIdx,]
subTest <- dm_train[-trainIdx,]
lossTrain <- as_train$loss[trainIdx]
lossTest <- as_train$loss[-trainIdx]

# Custom metric function for MAE
library(Metrics)
maeSummary <- function (data,
                        lev = NULL,
                        model = NULL) {
  out <- mae(data$obs, data$pred)  
  names(out) <- "MAE"
  out
}

fitCtrl <- trainControl(method = "cv",
                        number = 5,
                        verboseIter = TRUE,
                        summaryFunction = defaultSummary())

gbmGrid <- expand.grid( n.trees = seq(100), 
                        interaction.depth = c(1), 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

gbmFit <- train(x = subTrain, 
                y = lossTrain,
                method = "gbm", 
                trControl = fitCtrl,
                tuneGrid = gbmGrid,
                metric = 'RMSE',
                maximize = FALSE)

plot(gbmFit)
plot(gbmFit, plotType = "level")
gbmImp <- varImp(gbmFit, scale = FALSE)
plot(gbmImp,top = 20)

mean(gbmFit$resample$RMSE)

predicted <- predict(gbmFit, subTest)
RMSE(pred = predicted, obs = lossTest)

if(parallelize){
  stopCluster(cl)
}