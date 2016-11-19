rm(list = ls()) #If I want my environment reset for testing.

library(data.table)
library(dplyr)
library(caret)

if (dir.exists('/Users/nicktalavera/Coding/NYC_Data_Science_Academy/Projects/Allstate-Kaggle---Team-Datasaurus-Rex/Data')) {
  setwd('/Users/nicktalavera/Coding/NYC_Data_Science_Academy/Projects/Allstate-Kaggle---Team-Datasaurus-Rex/Data')
} else if (dir.exists("~/Allstate-Kaggle---Team-Datasaurus-Rex")) {
  setwd("~/Allstate-Kaggle---Team-Datasaurus-Rex")
} else if (dir.exists("Data/")) {
  setwd("Data/")
}

cores.Number = max(1,detectCores(all.tests = FALSE, logical = TRUE)-1)
cl <- makeCluster(2)
registerDoParallel(cl, cores=cores.Number)

as_train <- fread("train.csv", stringsAsFactors = TRUE)
as_test <- fread("test.csv", stringsAsFactors = TRUE)
dim(as_train)

table(as_train$cat112)

## create subset with cat112 == "E"
train_e <- as_train %>% filter(cat112 == "E") %>% select(-cat112, -id)
test_e <- as_test %>% filter(cat112 == "E") %>% select(-cat112, -id)
## log transform loss
loss_e <- log(train_e$loss + 1)
dm_train <- model.matrix(loss ~ ., data = train_e)
head(dm_train, n = 4)

dm_train <- model.matrix(loss ~ ., data = train_e)
head(dm_train, n = 4)


preProc <- preProcess(dm_train,
                      method = "nzv")
preProc

dm_train <- predict(preProc, dm_train)
dim(dm_train)

set.seed(321)
trainIdx <- createDataPartition(loss_e, 
                                p = .8,
                                list = FALSE,
                                times = 1)
subTrain <- dm_train[trainIdx,]
subTest <- dm_train[-trainIdx,]
lossTrain <- loss_e[trainIdx]
lossTest <- loss_e[-trainIdx]

lmFit <- train(x = subTrain, 
               y = lossTrain,
               method = "lm")

summary(lmFit)

lmImp <- varImp(lmFit, scale = FALSE)
lmImp

plot(lmImp,top = 20)

mean(lmFit$resample$RMSE)

predicted <- predict(lmFit, subTest)
# RMSE(pred = predicted, obs = lossTest)

plot(x = predicted, y = lossTest)

fitCtrl <- trainControl(method = "cv",
                        number = 5,
                        verboseIter = TRUE,
                        summaryFunction=defaultSummary)

gbmGrid <- expand.grid( n.trees = seq(100,500,50), 
                        interaction.depth = c(1,3,5,7), 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

gbmFit <- train(x = subTrain, 
                y = lossTrain,
                method = "gbm", 
                trControl = fitCtrl,
                tuneGrid = gbmGrid,
                metric = 'RMSE',
                maximize = FALSE)
stopCluster(cl)