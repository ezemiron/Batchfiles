
#steps for plotting results of d2b on same graph using ggplot2:

library (ggplot)

G1 <- read.csv("path_to_G1")
G0 <- read.csv("path_to_G0")

#take only the distance:
G1 <- G1$x
G0 <- G0$x

#give phase ID:
G1$phase <- "G1"
G0$phase <- "G0"

#remove col names to allow compilation, then give new names:
names(G1) <- rep(NA, ncol(G1))
names(G0) <- rep(NA, ncol(G0))
comp <- rbind(G1,G0)
names(comp) <- c("microns", "phase")

#different ways of plotting:
#density graph:
ggplot(comp1, aes(microns, fill = phase)) + geom_density(alpha = 0.2)
#histogram:
ggplot(comp1, aes(microns, fill = phase)) + geom_histogram(alpha = 0.5)

