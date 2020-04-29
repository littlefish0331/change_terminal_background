rm(list = ls()); gc()
library(dplyr)
library(data.table)

nn <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(nn)
source(file = "./get_image_path.R")
source(file = "./new_settings.R")
source(file = "./save_settings_LF.R")

imageDT_path <- "E:/NCHC/project_small/change_terminal_background/BGimagelist.csv"
settings_path <- "C:/Users/NCHC/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
new_image_path <- get.image.path(imageDT_path = imageDT_path)
new_settings <- new.settings(settings_path = settings_path, new_image_path = new_image_path)
save.settings.LF(settings_path = settings_path, new_settings = new_settings)
