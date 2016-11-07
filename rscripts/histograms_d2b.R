
#steps for plotting results of d2b on same graph using ggplot2:

library (ggplot2)

G1 <- read.csv("path_to_G1")
# Could try
# csv <- read.csv(fileandpath, colClasses=c("NULL", NA,))
G0 <- read.csv("path_to_G0")

#take only the distance:
G1 <- as.data.frame(G1$x)
G0 <- as.data.frame(G0$x)

#give phase ID:
G1$phase <- "G1"
G0$phase <- "G0"

#remove col names to allow compilation, then give new names:
names(G1) <- rep(NA, ncol(G1))
names(G0) <- rep(NA, ncol(G0))
comp <- rbind(G1,G0)
names(comp) <- c("Microns", "Phase")

#different ways of plotting:
#density graph:
ggplot(comp, aes(Microns, fill = Phase)) + geom_density(alpha = 0.2)
#histogram:
ggplot(comp, aes(Microns, fill = Phase)) + geom_histogram(alpha = 0.5)


for plotting coloured scatterplots with a dataframe: x, y, z, d2b
plotxyz <- ggplot(xyzpoints,aes(x,y))
plotxyz +geom_point(aes(colour = d2b))
