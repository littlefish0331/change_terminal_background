rm(list = ls()); gc()
library(dplyr)
library(data.table)



# ---
# 抓出檔案下的路徑
imagepath <- "E:/NCHC/project_small/change_terminal_background"
all_BGpath <- list.files(path = imagepath, 
                         full.names = T, recursive = T)
idx <- all_BGpath %>% grepl(pattern = "/background/", x = .)
tmp01 <- all_BGpath[idx] %>% strsplit(x = ., split = "/|\\.")



# ---
# 正規化路徑
tmp02 <- list()
image_i <- 1
for (image_i in 1:length(tmp01)) {
  cate = tmp01[[image_i]][6]
  aid = tmp01[[image_i]][7] %>% gsub(pattern = "[^0-9]*([0-9]+)", "\\1", .)
  file_format <- tmp01[[image_i]][8]
  tmp02[[image_i]] <- data.table(cate = cate, 
                                 image_tags = "-", 
                                 file_format = file_format, 
                                 aid = aid)
}
tmp03 <- rbindlist(tmp02)




# ---
# 補足 image_tags
# 讀取舊 imagelist.csv 中的 image_tags 欄位。(因為這要保留)
old_imagelist <- fread("imagelist.csv", encoding = "UTF-8", colClasses = "character")
tmp <- merge(x = tmp03, y = old_imagelist, 
             by = c("cate", "file_format", "aid"), 
             all.x = T)
imagelist <- tmp[, `:=`(image_tags = ifelse(is.na(image_tags.y), "-", image_tags.y))
                 ][, .(cate, file_format, aid, image_tags)]





# ---
# save
# fwrite(x = imagelist, file = "./imagelist.csv", row.names = F) #不知為何不UTF-8
write.csv(x = imagelist, file = "./imagelist.csv", 
          row.names = F, quote = F,
          fileEncoding = "UTF-8")
