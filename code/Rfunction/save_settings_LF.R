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