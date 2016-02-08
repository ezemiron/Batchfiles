#library(bioimagetools)
#library(parallel)
#library(tcltk)
require(bioimagetools)
require(parallel)
require(tcltk)
require(EBImage)

#Choose a directory:
dirchosen <- tk_choose.dir(caption = "Select directory");
setwd(dirchosen)

varname  <- readline(prompt = "Enter immunofluorescense target:")
classA <- readline(prompt = "Enter first reference chromatin class (1-7):")
classB <- readline(prompt = "Enter second reference chromatin class (0-7):")
# name  <- paste0(varname, "*-distn.csv")
# n <- c(NA,NA,NA,NA,NA,NA,NA,NA)
# df  <- data.frame(1:7)
# df[1] <- NULL



#df generates a list of files in that directory:
allfilesandpaths <- list.files(path=dirchosen, pattern= varname, full.names=TRUE);
filesandpaths  <- grep("*-distn.csv",allfilesandpaths, value = TRUE)
for (fileandpath in filesandpaths){
  
  df  <- data.frame(class=1:7)
  csv1 <- read.csv(fileandpath, colClasses=c("NULL","NULL","NULL","NULL","NULL","NULL", NA,"NULL"))
  df  <- cbind(df,csv1)

  
}
df <- transform(df, AvNorm = rowMeans(df[,-1], na.rm = TRUE))
df <- transform(df, Log2AvNorm = log2(df$AvNorm))

savename  <- paste0(varname,"_distn-summary.csv")
write.csv(df,savename);
