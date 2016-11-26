# Model parameters
model_method = "nnet"
model_grid = expand.grid(size  = c(60,80),
                         decay = c(0.6, 0.7))
#model_grid = NULL
extra_params = list(MaxNWts = 100000, linout = TRUE)

# Cross-validation parameters
partition_ratio = .8 # for cross-validation
cv_folds = 10 # for cross-validation
verbose_on = TRUE # output cv folds results?
metric = 'MAE' # metric use for evaluating cross-validation

# Misc parameters
subset_ratio = 0.01 # for testing purposes (set to 1 for full data)
create_submission = TRUE # create a submission for Kaggle?
use_log = TRUE # take the log transform of the response?
