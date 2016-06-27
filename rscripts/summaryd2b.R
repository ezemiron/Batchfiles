#!/usr/bin/env Rscript
##
## Copyright (C) 2016 Ezequiel Miron <eze.miron@bioch.ox.ac.uk>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.


#This script needs to have a prior setwd() to that of the Makefile.
# that is so that ./results is posible
dirchosen  <- readline(prompt = "Enter path to directory of Makefile so that ./results is possible. \n  ie: \"~/Documents/papers/chrom_marks\".\nIf already in Makefile directory hit enter\n")

if (! dirchosen == ""){
setwd(dirchosen)
} else {
dirchosen <- getwd()
}

dir_names <- list.dirs("results/G1")
dir_names <- dir_names[2:length(dir_names)]

var_names <- list.dirs("results/G1", full.names=FALSE)
var_names <- var_names[2:length(var_names)]

for (dir_name in dir_names){

    newdir <- paste(dirchosen, dir_name, sep ="/")
    setwd(newdir)
    dir_num <- which(dir_names == dir_name)
    var_name <- var_names[dir_num]

    df <- data.frame(NA)
    #df <- cbind(df,df)
    names(df) <- NA
    
    allfilesandpaths <- list.files(pattern= var_name, full.names=TRUE);
    filesandpaths  <- grep("*_d2b
    .csv",allfilesandpaths, value = TRUE)

    for (fileandpath in filesandpaths){
        d2b <- read.csv(fileandpath, colClasses=c("NULL", NA))
        cell_num <- which(filesandpaths == fileandpath)
        d2b$cell <- cell_num
        names(d2b) <- rep(NA, ncol(d2b))
        df <- rbind(df,d2b)
    }

    df <- df[2:nrow(df),]
    names(df) <- c("Microns", "Cell")
#    df <- transform(df, AvNorm = rowMeans(df[,-1], na.rm = TRUE))
#    df <- transform(df, Log2AvNorm = log2(df$AvNorm))

    savename  <- paste0(var_name,"_d2b-summary.csv")
    write.csv(df,savename);
}

