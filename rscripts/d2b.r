#!/usr/bin/env Rscript

#library(bioimagetools)
#library(parallel)
#library(tcltk)
require(bioimagetools)
require(parallel)
require(tcltk)


#Choose a directory:
a  <- NULL
win1 <- NULL
pathA <- function() {
  a <<- tk_choose.dir()
  setwd(a)
  tkdestroy(win1)
}
win1 <- tktoplevel()
buttonA <- tkbutton(win1, text = "Click\nto select working directory", command = pathA)
tkpack(buttonA)

#cat(paste("Working in directory:\n",a,"\n"));
#setwd(a)

classA <- readline(prompt = "Enter reference chromatin class: \n Accepted values from 1-7): \n ")
classA <- as.numeric(classA)
classB <- readline(prompt = "Enter secondary chromatin class: \n Accepted values from 0-7): \n ")
classB <- as.numeric(classB)
if(classB==0){
  classB <- NULL
}

#generates a list of files in that directory:
filesandpaths <- list.files(path=a, pattern="*SEG.tif", full.names=TRUE);

#Now we will apply all functions to the list of files:
for (fileandpath in filesandpaths){
  filename <- basename(fileandpath);
  cat(paste("Processing file:\n",filename,"\n"));
  # read segmented image
  img.classes <- readTIF (fileandpath); #This opens the seg 16bit tiff with all channels correclty
  img.classes <- round(img.classes*7)

  ##opening the 16bit tif to get resolution measurements
  #reftiffname <- gsub("_SEG.tif","-dapi_mask.tif",filename)
  #reftiffandpath <- paste(dirchosen, reftiffname, sep="/")
  #reftiff  <- readTIF("reftiffandpath")
  ##getting the resolution from the reftif file attributes
  #zres <- as.numeric(attr(reftiff, "spacing"))#this will be in um eg: 0.125
  #xres <- as.numeric(attr(reftiff, "x.resolution"))/1000 #these will be in nm eg:24.nnn so need converting to um
  #yres <- as.numeric(attr(reftiff, "y.resolution"))/1000
  ##specify size of voxel from resolution:
  #voxel <- c(xres,yres,zres)
  #FIXME: somehow the "x.resolution" and "y.resolution" are displaying incorrect values. eg 24 um nm istead of 41
  #until then this will have to be set manually:
  vox  <- c(41, 41, 125)/1000
  
  x.microns <- (dim(img.classes)*vox)[2]
  y.microns <- (dim(img.classes)*vox)[1]
  z.microns <- (dim(img.classes)*vox)[3]
    
  ##could add a mask at this point, link to mask and halt if different.
  #alternatively mask <- array(TRUE,dim(img.classes)) as default.
  #maskname <- gsub(".tif","-dapi_mask.tif",filename)
  #maskandpath <- paste(dirchosen, maskname, sep="/")
  #mask <- readTIF(maskandpath) #finds the mask
  #mask=mask==1
  #if (! identical (dim (mask), dim (chromatin)))
  #  stop ("Chromatin landscape and MASK are of different sizes"); 
  ##this should no longer happen given that both of these are taken from 
  ##the same file and not manually selected
  
  

  
  ################ Start work on 1 coordinate set:
    cat("coordinate data 1\n")
  # add here the link from image to csvs 
  csv1name <- gsub("_SEG.tif","-data_1.csv",filename);
  csv1path <- paste(a, csv1name, sep= "/");
  # read the csv:
  points <- read.csv(csv1path, header=TRUE);
  #reshape csv
  points <- points[,1:3]
  #convert from nm to um
  points <- points/1000
  #reshape from xyz to yxz for use in distance2border
  points <- data.frame(points[2],points[1],points[3])
  

  d2b <- distance2border(points,img.classes,x.microns,y.microns,z.microns,
                               class1=classA, class2=classB)
  
  #negative values in d2b represent points outside classA, 
  #but it should be the other way round according to 
  #the documentation, so fixed it: 
  d2b <- d2b*(-1)
  
  
  savename <- gsub(".csv","", csv1name);
  savename <- paste0(savename, "-d2b-C",classA,"-C",classB,".csv");
  write.csv(d2b,savename);
  
}
rm(list=ls())
