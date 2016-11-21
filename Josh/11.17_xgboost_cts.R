# Let's try xgboost on numeric variables only
library(xgboost)

train = read.csv('../data/train.csv', nrows = 1000)
test = read.csv('../Data/test.csv', nrows = 100)

