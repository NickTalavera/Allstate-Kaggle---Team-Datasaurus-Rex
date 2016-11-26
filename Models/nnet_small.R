# Model parameters
model_method = "nnet"
model_grid <- expand.grid(size  = 25,
                          decay = 0)
extra_params = list(MaxNWts = 100000, linout = TRUE)

# Cross-validation parameters
do_cv = FALSE
partition_ratio = .8 # for cross-validation
cv_folds = 10 # for cross-validation
verbose_on = TRUE # output cv folds results?
metric = 'MAE' # metric use for evaluating cross-validation

# Misc parameters
subset_ratio = .1 # for testing purposes (set to 1 for full data)
create_submission = FALSE # create a submission for Kaggle?
use_log = TRUE # take the log transform of the response?
