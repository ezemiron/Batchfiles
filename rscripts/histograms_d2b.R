#!/usr/bin/env Rscript
#steps for plotting results of d2b on same graph using ggplot2:


main <- function(argv){

if (length (argv) < 1)
    stop ('usage error: main_example requires 1 argument')

library (ggplot2)
#this script should be run on the directory above G1 and G0 directories
#dirchosen <- getwd()

dirchosen <- getwd()
varname <- argv[1]
#varname  <- readline(prompt = "Enter immunofluorescense target:");

allfilesandpaths <- list.files(path=dirchosen, recursive = TRUE, pattern= varname, full.names=TRUE);
filesandpaths  <- grep("*d2b-summary.csv",allfilesandpaths, value = TRUE)
path_to_G1 <- grep("G1",filesandpaths, value = TRUE)
path_to_G0 <- grep("G0",filesandpaths, value = TRUE)

G1 <- read.csv(path_to_G1)
# Could try:
# csv <- read.csv(fileandpath, colClasses=c("NULL", NA,))
# but would have to change some of the parameters below

G0 <- read.csv(path_to_G0)

##take only the distance: (but you will lose cell number)
#G1 <- as.data.frame(G1$x)
#G0 <- as.data.frame(G0$x)

#give phase ID:
G1$phase <- "G1"
G0$phase <- "G0"
#remove col names to allow compilation, then give new names:
names(G1) <- rep(NA, ncol(G1))
names(G0) <- rep(NA, ncol(G0))
comp <- rbind(G1,G0)
names(comp) <- c("index","Microns","Cell", "Phase")

#then plot:
densname  <- paste("Density plot of",varname, "d2b")
plotdens <- ggplot(comp, aes(Microns, fill = Phase)) + geom_density(alpha = 0.2) +
ggtitle(densname)

##to diplay just type:
#plothist
#to save to working directory:
savename1  <- paste0("Density_G0-G1_d2b_",varname,".png")
ggsave(savename1)


#and:
histname  <- paste("Histogram of",varname, "d2b")
plothist <- ggplot(comp, aes(Microns, fill = Phase)) + geom_histogram(alpha = 0.5, bins=100) +
ggtitle(histname)

##to diplay just type:
#plotdens
#to save to working directory:
savename2  <- paste0("Histogram_G0-G1_d2b_",varname,".png")
ggsave(savename2)

return (0)
}

if (identical (environment (), globalenv ()))
  quit (status=main (commandArgs (trailingOnly = TRUE)))


for plotting coloured scatterplots with a dataframe: x, y, z, d2b
plotxyz <- ggplot(xyzpoints,aes(x,y))
plotxyz +geom_point(aes(colour = d2b))
