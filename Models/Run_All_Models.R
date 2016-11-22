# Directory parameters
local_dir = '~/Courses/nyc_data_science_academy/projects/Allstate-Kaggle---Team-Datasaurus-Rex/Josh/'
server_dir = '~/ML'
if(dir.exists(local_dir)){
  setwd(local_dir)
} else{
  setwd(server_dir)
}
models_dir = 'Models'
modelFiles = list.files(path = paste0(getwd(),"/",models_dir), pattern="*.R$", full.names = TRUE, ignore.case = TRUE)
modelFiles[modelFiles != 'Run_All_Models.R']
sapply(modelFiles, source)