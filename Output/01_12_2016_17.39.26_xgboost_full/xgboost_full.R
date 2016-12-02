# Model parameters
model_method = "xgbTree"
model_grid = expand.grid(nrounds = seq(500, 3000, 500),
                         eta = c(0.01, 0.05, 0.1),
                         max_depth = c(4, 8, 12),
                         gamma = c(0, 1, 2),
                         colsample_bytree = 0.5,
                         min_child_weight = 1,
                         subsample = 0.8)
extra_params = list(alpha = 1)

# Cross-validation parameters
do_cv = TRUE
partition_ratio = .8 # for cross-validation
cv_folds = 2 # for cross-validation
verbose_on = TRUE # output cv folds results?
metric = 'MAE' # metric use for evaluating cross-validation

# Misc parameters
subset_ratio = 1.00 # for testing purposes (set to 1 for full data)
create_submission = TRUE # create a submission for Kaggle?
use_log = TRUE # take the log transform of the response?
