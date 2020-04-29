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