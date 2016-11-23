prefix = "22_11_gbm_small" #The beginning of the name of the files you want to run eg. "22_11" or "" for all

# Directory parameters
local_dir = '~/Courses/nyc_data_science_academy/projects/Allstate-Kaggle---Team-Datasaurus-Rex/'
server_dir = '~/ML'
if(dir.exists(local_dir)){
  setwd(local_dir)
} else if(dir.exists(server_dir)) {
  setwd(server_dir)
}
stopifnot(dir.exists('Data'))

models_dir = 'Models'
modelFiles = list.files(path = paste0(getwd(),"/",models_dir), pattern= paste0(prefix,"*.R$"), full.names = TRUE, ignore.case = TRUE)
modelFiles[modelFiles != 'Run_All_Models.R']
modelFiles[modelFiles != 'model_template.R']
sapply(modelFiles, source)