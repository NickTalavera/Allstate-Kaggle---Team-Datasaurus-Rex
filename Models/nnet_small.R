# Model parameters
#model_method = "neuralnet"
model_method = "nnet"
<<<<<<< HEAD
#model_grid <- NULL
#model_grid <- expand.grid(layer1 = c(5), layer2 = c(1), layer3 = c(1))
model_grid <- expand.grid(size = c(5), decay = c(0.0))
extra_params = list(MaxNWts = 100000, linout = TRUE)
=======
model_grid = NULL
extra_params = NULL
>>>>>>> ebf538d2dbc61c7d5b89c82a7d2698ae6f314789

# Cross-validation parameters
do_cv = TRUE
partition_ratio = .8 # for cross-validation
cv_folds = 2 # for cross-validation
verbose_on = TRUE # output cv folds results?
metric = 'MAE' # metric use for evaluating cross-validation

# Misc parameters
<<<<<<< HEAD
subset_ratio = .10 # for testing purposes (set to 1 for full data)
parallelize = TRUE # parallelize the computation?
=======
subset_ratio = .01 # for testing purposes (set to 1 for full data)
>>>>>>> ebf538d2dbc61c7d5b89c82a7d2698ae6f314789
create_submission = FALSE # create a submission for Kaggle?
use_log = TRUE # take the log transform of the response?
