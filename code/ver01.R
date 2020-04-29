rm(list = ls()); gc()
library(dplyr)
library(data.table)




# ---
# copy settings.json file
# 本來想要每一次修改都做儲存
# 但後來想想，其實只需要儲存default的settings.json就好
# 那這樣手動其實比較快。
# ---
dir_path <- paste0(settings_path, "save_settings")
nn_time <- Sys.time() %>% 
  substring(., 1, 19) %>% 
  gsub("[-|:]", "", .) %>% 
  gsub(" ", "T", .)
tar_dir <- paste0(dir_path, "/", nn_time)
dir.create(dir_path, showWarnings = F)
dir.create(tar_dir, showWarnings = F)
file.copy(from = paste0(settings_path, "settings.json"), 
          to = tar_dir, 
          overwrite = T, copy.date = T) #保留文件最後修改時間

# file.rename()，發現只要檔案名稱有改，檔案格式會有點小變化，從json with comment變回json。
# file.info("settings.json") %>% View()
# file.show("settings.json")




# ---
# change background
# ---
imageDT_path <- "E:/NCHC/project_small/change_terminal_background/imagelist.csv"
get.image.path <- function(imageDT_path, dir = NULL, tags = NULL, ff = NULL, id = NULL){
  DT <- fread(imageDT_path, encoding = "UTF-8", colClasses = "character")
  
  # ---
  # setting param
  if (is.null(dir)) dir <- unique(DT$cate)
  if (is.null(tags)) tags <- unique(DT$image_tags) %>% strsplit(., " ") %>% unlist() %>% unique() %>% paste0(., collapse = "|")
  if (is.null(ff)) ff <- unique(DT$file_format)
  if (is.null(id)) id <- unique(DT$aid)
  
  # ---
  # filter and sample
  idx <- DT$image_tags %>% grepl(pattern = tags, x = .)
  tmp <- DT[idx][cate%in%dir][file_format%in%ff][aid%in%id]
  pickDT <- tmp[sample(1:nrow(tmp), 1)]
  cate <- pickDT$cate
  file_format <- pickDT$file_format
  aid <- pickDT$aid
  res <- paste0(cate, "/", file_format, aid, ".", file_format)
  
  # ---
  # check result
  if (nrow(tmp)==0) {
    warning("no param result. random pick one image.")
    pickDT <- DT[sample(1:nrow(DT), 1)]
    cate <- pickDT$cate
    file_format <- pickDT$file_format
    aid <- pickDT$aid
    res <- paste0(cate, "/", file_format, aid, ".", file_format)
  }
  
  return(res)
}
get.image.path(imageDT_path = imageDT_path, tags = "cute")
new_image_path <- get.image.path(imageDT_path = imageDT_path, tags = "cute")




# ---
# read settings.json file
# replace image path in settings.json
# ---
# settings_path <- "C:/Users/littlefish/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
settings_path <- "C:/Users/NCHC/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
tmp01 <- readLines(con = settings_path, encoding = "UTF-8")
idx <- tmp01 %>% grepl(pattern = "   \"backgroundImage\":")
# tt <- tmp01[idx] %>% gregexpr(pattern = "/background/.*(gif|png|jpg)", text = .)
# tt1 <- tt[[1]] %>% as.numeric()
# tt2 <- tt1 + attr(x = tt[[1]], which = "match.length")
# substring(tmp01[idx], tt1, tt2-1)
tmp01[idx] <- tmp01[idx] %>%
  gsub(pattern = "(/background/).*(\",)", 
       replacement = paste0("\\1", new_image_path, "\\2"), 
       x = .)
new.settings <- function(settings_path, new_image_path){
  t1 <- readLines(con = settings_path, encoding = "UTF-8")
  idx <- t1 %>% grepl(pattern = "   \"backgroundImage\":")
  t1[idx] <- t1[idx] %>%
    gsub(pattern = "(/background/).*(\",)", 
         replacement = paste0("\\1", new_image_path, "\\2"), 
         x = .)
  res <- t1
  return(res)
}
new_settings <- new.settings(settings_path = settings_path, new_image_path = new_image_path)




# ---
# save new settings.json
# ---
# 這個方法是最佳解法
# eol: LF
# diff 比較文件後，是沒有差異的。
settings_path <- "C:/Users/NCHC/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
output.file <- file(description = settings_path, open = "wb")
Encoding(tmp01) <- "big5" #因為我原本的備註有中文，但別擔心，寫入後還是UTF-8。
write(x = "", file = output.file)
write.table(x = tmp01[-1], file = output.file,
            row.names = FALSE,col.names = FALSE,
            quote = FALSE, sep = "",
            append = TRUE)
close(output.file)
# ---
# eol: CRLF
# write.table(x = tmp01, file = "D:/settings.json",
#             quote = F, eol = "\n",
#             row.names = F, col.names = F, fileEncoding = "UTF-8")
# ---
# useBytes = T，才可以寫中文
# eol: CRLF
# writeLines(text = tmp01, con = "D:/settings.json", sep = "\n", useBytes = T)

save.settings.LF <- function(settings_path, new_settings){
  output.file <- file(description = settings_path, open = "wb")
  Encoding(new_settings) <- "big5" #因為我原本的備註有中文，但別擔心，寫入後還是UTF-8。
  write(x = "", file = output.file)
  write.table(x = new_settings[-1], file = output.file,
              row.names = FALSE,col.names = FALSE,
              quote = FALSE, sep = "",
              append = TRUE)
  close(output.file)
}




# ---
change.terminal.background <- function(dir_name, image_fullname, image_abbr, bgformat, aid){
  
}


