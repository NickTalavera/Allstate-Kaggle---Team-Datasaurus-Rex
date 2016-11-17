# Perform eda on the training set
library(kknn) #Load the weighted knn library.

# Goal: Reduce the mean aboslute error

# Load and inspect the data
train = read.csv('../data/train.csv', stringsAsFactors = TRUE)
summary(train)
# 116 categorical variables
# 14 continuous variables
# continuous variables look normalized

sum(is.na(train))
# no NA values

# What shape is the loss variable?
hist(train$loss)
# Loss is heavily skewed right, looks like a poisson distribution

test = read.csv('../Data/test.csv', nrows = 10)
summary(test)

allstate.euclidean = kknn(loss ~ ., train, test) # This fails

# Let's try random forests
library(randomForest)

# Goal: Run random forests on continuous variables
cts.vars = colnames(train)[sapply(train, class) == "numeric"]
train.cts = train[ , cts.vars]
rf.allstate = tree(loss ~ ., data = train.cts)

# cat112 is probably states 

# Future Ideas
# Box plots of cts variables
# PCA on cts variables
# Check cts variables for normality
# Check response for normality