# Parameters
subset_ratio = .1
cv_folds = 5
parallelize = TRUE
output = TRUE
plot.model = TRUE
use_log = TRUE

# Add parallelization
if(parallelize){
  library(doParallel)
  cores.number = detectCores(all.tests = FALSE, logical = TRUE)
  cl = makeCluster(2)
  registerDoParallel(cl, cores=cores.number)
}

# Read training and test data
library(data.table)
as_train <- fread("../Data/train.csv", drop=c("id"), stringsAsFactors = TRUE)
as_test <- fread("../Data/test.csv", stringsAsFactors = TRUE)
test_ids = as_test$id
as_test = as_test %>% select(-id)

if(use_log){
  as_train$loss = log(as_train$loss + 1)
}

# Subset the data
library(caret)
training_subset = createDataPartition(y = as_train$loss, p = subset_ratio, list = FALSE)
as_train <- as_train[training_subset, ]

# Pre-processing
library(dplyr)
print("Pre-processing...")
preProc <- preProcess(as_train %>% select(-loss), 
                      method = c("nzv", "center", "scale"))

dm_train = predict(preProc, newdata = as_train %>% select(-loss))
dm_test = predict(preProc, newdata = as_test)
print("...Done!")


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

# Setting up the model
fitCtrl <- trainControl(method = "cv",
                        number = cv_folds,
                        verboseIter = TRUE,
                        summaryFunction = defaultSummary)

gbmGrid <- expand.grid( n.trees = seq(100, 300, 100), 
                        interaction.depth = c(1, 7), 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

# Running the model on the loss
print("Running the model...")
gbmFit <- train(x = subTrain, 
                y = lossTrain,
                method = "gbm", 
                trControl = fitCtrl,
                tuneGrid = gbmGrid,
                metric = 'RMSE',
                maximize = FALSE)
print("...Done!")

# Estimated RMSE
test.predicted <- predict(gbmFit, subTest)
estimated_rmse = postResample(pred = test.predicted, obs = lossTest)
estimated_rmse

# Train final model on all of the data with best tuning parameters
gbm_final = train(x = dm_train,
            y = as_train$loss,
            method = "gbm",
            tuneGrid = gbmFit$bestTune,
            metric = 'RMSE',
            maximize = FALSE)

# Output kaggle submission
predicted_loss = predict(gbm_final, newdata = dm_test)
if(log){
  predicted_loss = exp(predicted_loss) - 1
}
submission = data.frame(id=test_ids, loss=predicted_loss)

dir.create('../Output')
write.csv(submission, file="../Output/kaggle_submission.csv", row.names = FALSE)

# Output run time, grid, control, time stamp, and model name

# Output model plot
if(plot.model){
  plot(gbmFit)
}

if(parallelize){
  stopCluster(cl)
}