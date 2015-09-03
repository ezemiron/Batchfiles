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
    filename <- basename(fileandpath);
    
    cat(paste("Processing file:",filename,"\n"));
    
    
    ################ Start work on 1 coordinate set:
    
    cat("coordinate data 1\n")
    # add here the link from image to csvs 
    csv1name <- gsub("_SEG.tif","-data_1.csv",filename);
    csv1path <- paste(dirchosen, csv1name, sep= "/");
    # read the csvs:
    csv1  <- read.csv(csv1path, header=TRUE);


    #  convert and round the nm distances to pixels and remove unwanted cols 
    csv1r  <- round(data.frame(csv1[1]/41, csv1[2]/41, csv1[3]/125));
    
    
    # for 3D linear index: ind <- (m.n)(z-1)+m(c-1)+r 
    # remember that
    # m = length of columns, determined by the 1st dim of img
    # n = length of rows, determined by the 2nd dim of img
    # c = column number, determined by the x coordinate
    # r = row number, determined by the y coordinate
    # z = optical plane number, determined by z coordinate
    ind1  <- ((dim(img)[1]*dim(img)[2])*(csv1r$z - 1))+((csv1r$x -1)*dim(img)[1])+csv1r$y

    # index: img(index)
    imind1 <- img[ind1];

    # for normalisation find how many pixels in each class,ie:
    # count the size of bins, and remove background:
    classnum <- as.numeric(table(img));
    if(0 == min(img))
    {
      cat("Removing background \n")
      classnum <- classnum[2:length(classnum)]
    }else{
    cat("No background detected \n")
        }
    
    classnumn <- classnum/sum(classnum);
    
    # count how many spots fell in each bin
    dist1  <- as.numeric(table(imind1));
#     Removes spots found in background if any and warn:
    if(0 == min(imind1))
    {
      bgnum <- as.numeric(table(imind1)[1])
      tnum <- sum(table(imind1))
      bgwarn <- paste(bgnum,"out of",tnum,"Data-1 coordinates found outside nucleus! -> Ignored \n")
      cat(bgwarn)
      dist1 <- dist1[2:length(dist1)]
     }else{
    cat("All coordinates in nucleus \n")
        }
    
    dist1n <- dist1/sum(dist1);

    
    # divide distns by this
    # and then normalise internally to 100%
    if (length(dist1n)==length(classnumn))
        { norm1 <- dist1n/classnumn
          lognorm1  <- log(norm1)
        }
    if (length(dist1n)<length(classnumn))
        {diff <- data.frame(1:(length(classnumn)-length(dist1n)))
        for (i in diff){
                emptyclass <- length(dist1n)+i
                spotwarn <- paste("No spots found for class",emptyclass)
                dist1nb <- dist1n
                dist1nb[length(dist1n)+i] <- 0
                dist1n <- dist1nb

                cat(spotwarn)
                dist1b <- dist1
                dist1b[length(dist1)+i] <- 0
                dist1 <- dist1b
                
                        }
    norm1 <- dist1n/classnumn
    lognorm1 <- log2(norm1) 
        }
        

    compile1 <- data.frame(class=1:length(classnum),dist1,dist1n,classnum,classnumn,norm1,lognorm1)

    savename <- gsub(".csv","", csv1name);
    savename <- paste0(savename, "-distn.csv");
    write.csv(compile1,savename);

##############For a second coordinate set, repeat the process:

#cat("coordinate data 2\n")
#    # add here the link from image to csvs 
#    csv2name <- gsub("_SEG.tif","-data_2.csv",filename);
#    csv2path <- paste(dirchosen, csv2name, sep= "/");
#    # read the csvs:
#    csv2  <- read.csv(csv2path, header=TRUE);


#    #  convert and round the nm distances to pixels and remove unwanted cols 
#    csv2r  <- round(data.frame(csv2[1]/41, csv2[2]/41, csv2[3]/125));


#    # for 3D ind <- (m.n)(z-1)+m(c-1)+r 
#    ind2  <- ((dim(img)[1]*dim(img)[2])*(csv2r$z - 1))+((csv2r$x -1)*dim(img)[1])+csv2r$y


#    # index: img(index)
#    imind2 <- img[ind2];

#    # count how many spots fell in each bin
#    dist2  <- as.numeric(table(imind2));
#    
#    if(0 == min(imind2))
#      {
#       cat("Data 2 coordinates found outside nucleus! -> Ignored")
#       dist2 <- dist2[2:length(dist2)]
#      }

#    dist2n <- dist2/sum(dist2);
#    
#    if (length(dist2n)==length(classnumn))
#        { norm2 <- dist2n/classnumn
#          lognorm2  <- log(norm2)
#        }
#    if (length(dist2n)<length(classnumn))
#           {diff2 <- data.frame(1:(length(classnumn)-length(dist2n)))
#           for (i in diff2){
#                   dist2nb <- dist2n
#                    dist2nb[length(dist2n)+i] <- 0
#                }
#        norm2 <- dist2nb/classnumn
#        lognorm2 <- log2(norm2) 
#        }
#        
#    compile2 <- data.frame(dist2,dist2n,classnum,classnumn,norm2,lognorm2)
#    savename <- gsub(".csv","", csv2name);
#    savename <- paste0(savename, "-distn.csv");
#    write.csv(compile2,savename);

}

# df <- data.frame(class=1:length(lognorm1),lognorm1, lognorm2)
# lim <- c(min(df[2:3]),max(df[2:3]))
# barplot(rbind(lognorm1,lognorm2),
#         beside= TRUE, col=c("limegreen","firebrick1"), 
#         ylab = "Fold Change",xlab = "Chromatin Classes")
