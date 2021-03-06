#library(bioimagetools)
#library(parallel)
#library(tcltk)
#require(bioimagetools)
#require(parallel)
require(tcltk)
#require(EBImage)

#Choose a directory:
dirchosen <- tk_choose.dir(caption = "Select directory");
setwd(dirchosen)

varname  <- readline(prompt = "Enter immunofluorescense target:")
# name  <- paste0(varname, "*-distn.csv")
# n <- c(NA,NA,NA,NA,NA,NA,NA,NA)
# df  <- data.frame(1:7)
# df[1] <- NULL
df  <- data.frame(class=1:7)
#df generates a list of files in that directory:
allfilesandpaths <- list.files(path=dirchosen, pattern= varname, full.names=TRUE);
filesandpaths  <- grep("*-distn.csv",allfilesandpaths, value = TRUE)
for (fileandpath in filesandpaths){
  
  csv1 <- read.csv(fileandpath, colClasses=c("NULL","NULL",NA,"NULL","NULL","NULL","NULL","NULL"))
  df  <- cbind(df,csv1)

  
}
df <- transform(df, total = rowSums(df[,-1], na.rm = TRUE))
#df <- transform(df, Log2AvNorm = log2(df$AvNorm))

savename  <- paste0(varname,"_centroid-sum.csv")
write.csv(df,savename);
