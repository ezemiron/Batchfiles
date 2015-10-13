#this is like the distR script but runs without fltk, 
#you have to manually input the setwd() command with the path to the directory of choice. 
#this same directory will be the output.

#This script does not remove 0 values, it just indexes and produces all the results
#It is useful for cheching the distribution of index values without using the segmented landscape.
#so that one can use nclass.Sturges, nclass.scott and nclass.FD to check the optimal bin numbers




require(bioimagetools)
require(parallel)
require(EBImage)

#Choose a directory:
cat("Choose a directory: setwd(PATH)")

dirchosen <- getwd()

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
#    A bunch of normalisations
    imind1 <- imind1/max(img);
    imind1 <- imind1/max(imind1)
#    removing all 0 as these are outside the nucleus:
    imind1[imind1 == 0] <- NA
    savename <- gsub(".csv","", csv1name);
    savename <- paste0(savename, "-imind1.csv");
    
     write.csv(imind1,savename);
    
    img1 <- img/max(img)
    classnum <- as.data.frame(table(img1))
    classnum <- classnum[-c(1), ]
    savename2 <- gsub(".csv","", csv1name);
    savename2 <- paste0(savename2, "-img.csv");
    
     write.csv(classnum,savename2);
    
    
    
}








    imind1 <- round(imind1*7)

    # for normalisation find how many pixels in each class,ie:
    # count the size of bins, and remove background:
#    classnum <- as.numeric(table(img));
#    if(0 == min(img))
#    {
#      cat("Removing background \n")
#      classnum <- classnum[2:length(classnum)]
#    }else{
#    cat("No background detected \n")
#        }
#    
    classnumn <- classnum/sum(classnum);
    
    # count how many spots fell in each bin
    dist1t  <- tabulate(imind1, nbins=length(classnum))
    
    
#    dist1  <- as.numeric(table(imind1));
#     Removes spots found in background if any and warn:
##    if(0 == min(imind1))
##    {
##      bgnum <- as.numeric(table(imind1)[1])
##      tnum <- sum(table(imind1))
##      bgwarn <- paste(bgnum,"out of",tnum,"Data-1 coordinates found outside nucleus! -> Ignored \n")
##      cat(bgwarn)
###      dist1 <- dist1[2:length(dist1)]
###      dist1t <- dist1t[2:length(dist1t)]
###      dist1tnames <- dist1tnames[2:length(dist1tnames)]
##     }else{
##    cat("All coordinates in nucleus \n")
##        }
    

    
    dist1n <- dist1t/sum(dist1t);

    #Need to check for empty classes
    # divide distns by this
    # and then normalise internally to 100%
#    if (length(dist1n)==length(classnumn))
#        { norm1 <- dist1n/classnumn
#          lognorm1  <- log(norm1)
#        }
#    if (length(dist1n)<length(classnumn))
#        {diff <- data.frame(1:(length(classnumn)-length(dist1n)))
#        for (i in diff){
#                emptyclass <- length(dist1n)+i
#                spotwarn <- paste("No spots found for class",emptyclass,"\n")
#                dist1nb <- dist1n
#                dist1nb[length(dist1n)+i] <- 0
#                dist1n <- dist1nb

#                cat(spotwarn)
#                dist1b <- dist1
#                dist1b[length(dist1)+i] <- 0
#                dist1 <- dist1b
#                
#                        }
#    norm1 <- dist1n/classnumn
#    lognorm1 <- log2(norm1) 
#        }
        
    norm1 <- dist1n/classnumn
    lognorm1 <- log2(norm1) 
    compile1 <- data.frame(class=1:length(classnum),dist1t,dist1n,classnum,classnumn,norm1,lognorm1)

    savename <- gsub(".csv","", csv1name);
    savename <- paste0(savename, "-distn.csv");
    write.csv(compile1,savename);


}



