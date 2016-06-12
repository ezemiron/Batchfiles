#!/usr/bin/env Rscript

#library(bioimagetools)
#library(parallel)
#library(tcltk)
require(bioimagetools)
require(parallel)
require(tcltk)
#require(EBImage)

#Choose a directory:
dirchosen <- tk_choose.dir(caption = "Select directory");
setwd(dirchosen)

#generates a list of files in that directory:
allfilesandpaths <- list.files(path=dirchosen, pattern=".tif", full.names=TRUE);
filesandpaths <- list.files(path=dirchosen, pattern="*THR.tif", full.names=TRUE);

#Now we will apply all functions to the list of files:
for (fileandpath in filesandpaths){
    # load file:
    img <- readTIF (fileandpath); #This opens the 16bit tiff with all channels correclty
    chromatin <- img[ , ,2, ] #finds the chromatin channel
    
    filename <- basename(fileandpath)
    maskname <- gsub(".tif","_THR_mask.tif",filename)
    maskandpath <- paste(dirchosen, maskname, sep="/")
    matchtest <- is.na((match(maskandpath, allfilesandpaths)))

    if ( matchtest == FALSE){ 
      mask <- readTIF(maskandpath) #finds the mask
      mask=mask==1
      if (! identical (dim (mask), dim (chromatin)))
      stop ("Chromatin landscape and MASK are of different sizes"); 
  #this should no longer happen given that both of these are taken from 
  #the same file and not manually selected
      
      cat(paste("Segmenting file:",filename,"\n" ))
  #    The segmentation:
      seg<-segment(chromatin,7,0.1,1/3,mask=mask, maxit=30,varfixed=TRUE,inforce.nclust=TRUE,start="equal");
      
  #    Rescaling so imageJ lut can read the output
      segscale=seg$class/length(seg$mu)
      
      savename <- gsub(".tif","_SEG.tif",filename)
      savepath <- paste(dirchosen, savename, sep="/")
      writeTIF (segscale, savename);
    }

}






#stuff<-read.csv(file.choose(),header=TRUE)

#Steps needed to segment:
##setwd ()
## e.g. setwd ('/Users/Ezequiel/Documents/R_tests/test1/')
## eg: setwd ('/Volumes/wolf4192/data...')
#mask_filepath <- file.choose();
#mask <- readImage (mask_filepath);

#mask = (mask == 1);

#dapi_filepath <- file.choose();
#dapi <- readImage(dapi_filepath);
##(there is a problem with libtiff causing an error in files channel split from fiji,but not imageJ, this is fixed in libtif 4.0.4 released soon)

#if (! identical (dim (mask), dim (dapi)))
#   stop ("DAPI and MASK are of different sizes");

#img.seg<-segment(dapi,7,0.1,1/3,mask=mask, maxit=30,varfixed=TRUE,inforce.nclust=TRUE,start="equal");

### unique (as.vector(img.seg$class))

#img.seg$class= img.seg$class/7;

###ff = unique(as.vector(img.seg$class))

###for (f in ff) cat (max (dapi[img.seg$class == f]) * 65535, "\n")

#writeImage (x=img.seg$class, file=paste(dapi_filepath, "_segmented.tif", sep=""));
