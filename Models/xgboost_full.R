# Model parameters
model_method = "xgbTree"
<<<<<<< HEAD
model_grid <- expand.grid(nrounds = c(1000, 2000),
                          eta = c(0.01),
                          max_depth = c(2, 4, 8, 16),
                          gamma = 1,
                          colsample_bytree = 0.5,
                          min_child_weight = 1)
#                          subsample = 0.8)
extra_params = NULL
=======
model_grid = expand.grid(nrounds = 1000,
                         eta = .01,
                         max_depth = 12,
                         gamma = 2,
                         colsample_bytree = 0.5,
                         min_child_weight = 1,
                         subsample = 0.8)
extra_params = list(alpha = 1)
>>>>>>> ebf538d2dbc61c7d5b89c82a7d2698ae6f314789

# Cross-validation parameters
do_cv = FALSE
partition_ratio = .8 # for cross-validation
cv_folds = 10 # for cross-validation
verbose_on = TRUE # output cv folds results?
metric = 'MAE' # metric use for evaluating cross-validation

# Misc parameters
subset_ratio = 1.00 # for testing purposes (set to 1 for full data)
create_submission = TRUE # create a submission for Kaggle?
use_log = TRUE # take the log transform of the response?
