

#Choose a directory:
dirchosen <- getwd()

varname  <- readline(prompt = "Enter immunofluorescense target:")
# name  <- paste0(varname, "*-distn.csv")
# n <- c(NA,NA,NA,NA,NA,NA,NA,NA)
# df  <- data.frame(1:7)
# df[1] <- NULL

df# generates a list of files in that directory:
allfilesandpaths <- list.files(path=dirchosen, pattern= varname, full.names=TRUE);
filesandpaths  <- grep("*-distn.csv",allfilesandpaths, value = TRUE)

df  <- data.frame(class=1:legth(filesandpaths))

for (fileandpath in filesandpaths){
  
  csv1 <- read.csv(fileandpath, colClasses=c("NULL","NULL","NULL","NULL","NULL","NULL", NA,"NULL"))
  df  <- cbind(df,csv1)

  
}
df <- transform(df, AvNorm = rowMeans(df[,-1], na.rm = TRUE))
df <- transform(df, Log2AvNorm = log2(df$AvNorm))

savename  <- paste0(varname,"_distn-summary.csv")
write.csv(df,savename);





test2$x <- test2$x/max(test2$x)
