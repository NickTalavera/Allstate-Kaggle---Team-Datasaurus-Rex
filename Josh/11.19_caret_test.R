## Read data
setwd("Data/")
as_train <- read.csv("train.csv")
as_test <- read.csv("test.csv")
dim(as_train)

table(as_train$cat112)
library(dplyr)
## create subset with cat112 == "E"
train_e <- as_train %>% filter(cat112 == "E") %>% select(-cat112, -id)
test_e <- as_test %>% filter(cat112 == "E") %>% select(-cat112, -id)
## log transform loss
loss_e <- log(train_e$loss + 1)
dm_train <- model.matrix(loss ~ ., data = train_e)
head(dm_train, n = 4)

dm_train <- model.matrix(loss ~ ., data = train_e)
head(dm_train, n = 4)

> library(caret)
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
RMSE(pred = predicted, obs = lossTest)

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
