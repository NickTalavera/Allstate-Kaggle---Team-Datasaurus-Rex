# Model parameters
model_method = "gbm"
model_grid <- expand.grid( n.trees = seq(300, 400, 50), 
                           interaction.depth = c(1, 7), 
                           shrinkage = 0.05,
                           n.minobsinnode = 20)

# Misc Parameters
subset_ratio = .01 # for testing purposes (set to 1 for full data)
partition_ratio = .8 # for cross-validation
cv_folds = 2 # for cross-validation 

parallelize = TRUE # parallelize the computation?
create_submission = TRUE # create a submission for Kaggle?
use_log = FALSE # take the log transform of the response?
verbose_on = TRUE
metric = 'MAE' # metric use for evaluating cross-validation

# Run the model and output results
group_path = "Group"
source(file.path(group_path, 'model_maker.R'))