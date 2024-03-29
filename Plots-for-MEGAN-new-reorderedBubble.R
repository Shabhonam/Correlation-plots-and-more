#install.packages("preprocessCore")
library("ecodist")
library(tidyverse)
#install.packages("remotes")
#remotes::install_github("MadsAlbertsen/ampvis2")


setwd("~/Desktop/Testdata/Deborah/NewPlate/Bubbleplots/Lindsay/")
HOT_data <- read.csv("genus_EPSMinusPhasesInfo_top10_Early.csv", header=TRUE, row.names=1,check.names=FALSE)

head(HOT_data)
## 2. Data Scaling
# alway important to plot your data to get a sense of its distribution
par(mfrow=c(1,2)) # multiple plots in one graph
hist(as.matrix(HOT_data))
hist(as.matrix(log(HOT_data + 1)))
HOT_data <- log(HOT_data + 1)
par(mfrow=c(1,1))

## 3. Distance Matrices and Clustering
HOT_data.t <- t(HOT_data) # transpose HOT_data
HOT_data.t.dist <- dist(HOT_data.t) # calculate the euclidian distance between the rows
HOT_data.t.dist
# Note that dist uses the Euclidian distance by default

# Next we will hierarhcally cluster our distance matrix using hclust
HOT_data.euclid.fit <- hclust(HOT_data.t.dist)
pdf("Euclidian-clustering.pdf",15,7)
plot(HOT_data.euclid.fit, main="Distance: Euclidian, Clustering:Complete")
dev.off()
# a popular distance with biologists is the Bray-Curtis simmilarity
try(library("ecodist"), install.packages("ecodist")) # try load, otherwise install
library("ecodist") # try to load again
HOT_data.t.bcdist <- bcdist(HOT_data.t)
HOT_data.bcdist.ward.fit <- hclust(HOT_data.t.bcdist, method="ward")
plot(HOT_data.bcdist.ward.fit, main="Distance: Bray-Curtis, Clustering:Ward's")

# a good way to visualize your clustering and distance matrix is via a heatmap
# remember to use install.packages("package_name") if you can not load
library("gplots")
library("RColorBrewer") # for colours
euclid_dend <- as.dendrogram(HOT_data.euclid.fit) # get ordering for heatmap
my_colours <- brewer.pal(8,"GnBu") # my colours
heatmap.2(as.matrix(HOT_data.t.dist), margin=c(14,14), 
          Rowv=euclid_dend, 
          Colv=euclid_dend, 
          col=my_colours, 
          trace="none", 
          denscol="black")

# do the same for the Bray-Cutris clustering
bc_dend <- as.dendrogram(HOT_data.bcdist.ward.fit) # get ordering for heatmap
my_bc_colours <- brewer.pal(8,"BuPu") # my colours
heatmap.2(as.matrix(HOT_data.t.bcdist), margin=c(14,14), 
          Rowv=bc_dend, 
          Colv=bc_dend, 
          col=my_bc_colours, 
          trace="none", 
          denscol="black")

# finally the last think is to have some statistical confidence about our clustering
# the main way is via bootstrapped p-values in the pvclust package. Its a good idea to 
# resample about 1000 times

library(pvclust)
HOT_data.pv_fit <- pvclust(HOT_data, method.hclust="complete", method.dist="euclidian", n=1000) # in this case no transform is need
plot(HOT_data.pv_fit)

# unfortunately, pvcust does not have bcdist implemented but it was not that hard to add it
try(library("devtools"), install.packages("devtools")) # used to source functions from the internet
library("devtools")
source_url('http://raw.github.com/nielshanson/mp_tutorial/master/taxonomic_analysis/code/pvclust_bcdist.R')
# alternatively, you might want to download the above function and load using source()
# e.g. source('/where/I/downloaded/pvclust_bcdist.R')
HOT_data.bcdist.pv_fit <- pvclust(HOT_data, method.hclust="ward", method.dist="bray–curtis", n=1000)
pdf("Bray-clustering-au-bp.pdf",10,7)
plot(HOT_data.bcdist.pv_fit)
dev.off()
## 4. Visualizing taxonomic abundances

# one quick way is to revisit our heatmap.2 function

my_colours <- brewer.pal(8,"Blues") # another colour scheme
HOT_heat <- heatmap.2(as.matrix(HOT_data), margin=c(14,14), 
                      col=my_colours, 
                      Colv=bc_dend, 
                      trace="none", 
                      denscol="black")

# finally a rather impressive looking bubble plot can be made with 
# the visualizion package ggplot2
library(ggplot2)
library(reshape2) # transform our Data from wide to long format
HOT_data$taxa = rownames(HOT_data) # add taxa from rownames to Data Frame
HOT_data.m <- melt(HOT_data)
colnames(HOT_data.m)[2] = "sample" # rename variable column to sample

# in order to plot things in properly, the order of each variable has to be explicitly set
name_order <- HOT_data.bcdist.ward.fit$labels[HOT_data.bcdist.ward.fit$order] # get order of samples from clustering
HOT_data.m$sample <- factor(HOT_data.m$sample, levels=name_order) # set order of samples
HOT_data.m$taxa <- factor(HOT_data.m$taxa, levels=unique(HOT_data.m$taxa)) # set order of taxa

# cut bray-curtis clustering to get groups
bc_ward_groups <- cutree(HOT_data.bcdist.ward.fit, h=0.12) # slice dendrogram for groups
HOT_data.m$clust_group <- as.vector(bc_ward_groups[as.vector(HOT_data.m[,"sample"])])
HOT_data.m$clust_group <- as.factor(HOT_data.m$clust_group) # set group numbers as factors
HOT_data.m
#write.csv( HOT_data.m,"Bubble_data.csv") #for tweaking the bubble plot data
#HOT_data.m <-read.csv("Bubble_data.csv")
# finally create the bubble plot
g <- ggplot(subset(HOT_data.m, value >0), aes(x=reorder(sample), y=taxa, color=taxa))
g <- g + geom_point(aes(size=value)) # plot the points and scale them to value
g <- g + theme_bw() # use a white background
g <- g + theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "Samples") # rotate and centre labels
g


pdf("Bubble_top10_EPSMinus_early.pdf",10,10)
g
dev.off()

p<-ggplot(subset(HOT_data.m, value >0), aes(x=taxa, y=value, fill=taxa)) +
  geom_violin(trim=FALSE)+
  geom_boxplot(width=0.1) + theme_minimal() 
p <-p+scale_fill_brewer(palette="Dark2")
p
# Change violin plot colors by groups
p<-ggplot(HOT_data.m, aes(x=sample, y=value, fill=taxa)) +
  geom_violin(trim=FALSE)
p


p<-ggplot(subset(HOT_data.m, value >0), aes(x=sample, y=mean(HOT_data.m$value), group=taxa)) +
  geom_line(aes(color=taxa))+
  geom_point(aes(color=taxa))
p
