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
