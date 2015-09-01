#!/usr/bin/env Rscript

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

#generates a list of files in that directory:
filesandpaths <- list.files(path=dirchosen, pattern="*SEG.tif", full.names=TRUE);

#Now we will apply all functions to the list of files:
for (fileandpath in filesandpaths){
    # read segmented image
    img <- readTIF (fileandpath); #This opens the seg 16bit tiff with all channels correclty
    filename <- basename(fileandpath)
    # add here the link from image to csvs 
    csv1name <- gsub("_SEG.tif","-data_1.csv",filename)
    csv1path <- paste(dirchosen, csv1name, sep= "/")
    # read the csvs:
    csv1  <- read.csv(csv1path, header=TRUE)


    #  convert and round the nm distances to pixels and remove unwanted cols 
    csv1r  <- round(data.frame(csv1[1]/41, csv1[2]/41, csv1[3]/125))

        
    # linear index of these rounded tables (sub 2 ind)
    # x <- csv1r$x
    # y <- csv1r$y
    # z <- csv1r$z
    # for 3D ind <- (m.n)(z-1)+m(c-1)+r 
    ind1  <- ((dim(img)[1]*dim(img)[2])*(csv1r$z - 1))+((csv1r$y -1)*dim(img)[1])+csv1$x


    # index: img(index)
    imind1 <- img[ind1]

    # count how many spots fell in each bin
    dist1  <- as.numeric(table(imind1))

#    distn <- as.numeric(names(table(imind1)))
    classnum  <- as.numeric(table(img))
    # for normalisation find how many pixels in each class
    dist1n <- dist1/sum(dist1)

    classnumn <- classnum/sum(classnum)
    # divide distns by this
    # and then normalise internally to 100%
    if (length(dist1n)==length(classnumn))
        { norm1 <- dist1n/classnumn
          lognorm1  <- log(norm1)
        }
    if (length(dist1n)<length(classnumn))
        {diff <- c((length(classnumn)-length(dist1n)):1)
        for (i in diff){
                dist1n[length(dist1n)+i] <- 0
                        }
    norm1 <- dist1n/classnumn
    lognorm1 <- log2(norm1) 
        }
    savename <- gsub(".csv","", csv1name)
    savename <- paste0(savename, "-distn.csv")
    write.csv(lognorm1,savename)

##For a second csv, repeat the process:

#    csv2  <- read.csv(csv1path, header=TRUE)

#    csv2r  <- round(csv2 / c(41, 41, 125))

#    ind2  <- ((dim(img)[1]*dim(img)[2])*(csv2r$z - 1))+((csv2r$y -1)*dim(img)[1])+dim(img)[3]

#    imind2 <- img[ind2]

#    dist2  <- as.numeric(table(imind2))

#    dist2n <- dist2/sum(dist2)

#    if (length(dist2n)==length(classnumn))
#       {norm2 <- dist2n/classnumn
#       lognorm2  <- log(norm2)
#       }
#    if (length(dist2n)<length(classnumn))
#       {diff <- c((length(classnumn)-length(dist2n)):1)
#       for (i in diff){
#              dist2n[length(dist2n)+i] <- 0
#                      }
#    norm2 <- dist2n/classnumn
#    lognorm2 <- log2(norm2) 
#       }
## csv write


}

