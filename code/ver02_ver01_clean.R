# pass parameter to windows bat file
# https://stackoverflow.com/questions/50256138/passing-parameters-to-an-r-script-via-cmd-or-batch
# !/usr/bin/Rscript
rm(list = ls()); invisible(gc())
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(docopt))


# ---
# passs param into R file
doc <- 
"
Usage: test.R [-h] [--cate dir] [--ff format] [--aid aid] [--tag tag]

-c --cate dir       image directory category
-f --ff format      image format, one of (png, jpg, gif)
-i --aid aid        image aid, numeric from 1 to 99
-t --tag tag        image tag
-h --help           show this help text
"

# -t --tag    tag       image tag [default: NULL]
opt <- docopt(doc)          # docopt parsing

# print(opt)
# print(opt$cate) #可以輸入中文
# print(opt$ff)
# print(opt$aid)
# print(opt$tag)






imageDT_path <- "E:/NCHC/project2020/change_terminal_background/imagelist.csv"
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
# get.image.path(imageDT_path = imageDT_path, tags = "cute")
# new_image_path <- get.image.path(imageDT_path = imageDT_path, tags = "cute")
new_image_path <- get.image.path(imageDT_path = imageDT_path, 
                                 dir = opt$cate, 
                                 tags = opt$tag, 
                                 ff = opt$ff, 
                                 id = opt$aid)




settings_path <- "C:/Users/NCHC/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
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







settings_path <- "C:/Users/NCHC/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
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
save.settings.LF(settings_path = settings_path, new_settings = new_settings)
