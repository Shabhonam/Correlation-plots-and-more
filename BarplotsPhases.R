library(scales)
library(tidyverse)
library(plotly)
library(ggplot2)

######################EARLY#################

setwd("~/Desktop/Testdata/Deborah/NewPlate/Bubbleplots/Lindsay/")
HOT_data_early <- read.csv("genus_EPSMinusPhasesInfo_top10_Early.csv", header=TRUE,check.names=FALSE)
head(HOT_data_early)
data_melt_early <-melt(HOT_data_early)
head(data_melt_early)
#write.csv( data_melt,"melteddata_EPSMinusPhases.csv") #add a column manually for time points for line plots
#data_melt <-read.csv("melteddata_EPSMinusPhases.csv")
g <- ggplot(subset(data_melt_early, value >0), aes(x=reorder(variable), y=Taxa, color=Taxa))
g <- g + geom_point(aes(size=value)) # plot the points and scale them to value
g <- g + theme_bw() # use a white background
g <- g + theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "") # rotate and centre labels
pdf("Early_EPSMinus_bubble.pdf", 10, 10)
g
dev.off()

q <-ggplot(data=subset(data_melt_early, value >0), aes(x=Taxa, y=value)) + geom_bar(stat="identity", fill="blue")
q <-q +theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "") + ylim(0, 70000)# rotate and centre labels
pdf("Early_EPSMinus_geombar.pdf", 10, 10)
q
dev.off()

######################Mid#################

HOT_data_mid <- read.csv("genus_EPSMinusPhasesInfo_top10_Mid.csv", header=TRUE,check.names=FALSE)
head(HOT_data_mid)
data_melt_mid <-melt(HOT_data_mid)
head(data_melt_mid)

g <- ggplot(subset(data_melt_mid, value >0), aes(x=reorder(variable), y=Taxa, color=Taxa))
g <- g + geom_point(aes(size=value)) # plot the points and scale them to value
g <- g + theme_bw() # use a white background
g <- g + theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "") # rotate and centre labels
pdf("Mid_EPSMinus_bubble.pdf", 10, 10)
g
dev.off()

q <-ggplot(data=subset(data_melt_mid, value >0), aes(x=Taxa, y=value)) + geom_bar(stat="identity", fill="steelblue")
q <-q +theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "")+ ylim(0, 70000) # rotate and centre labels
pdf("Mid_EPSMinus_geombar.pdf", 10, 10)
q
dev.off()


######################Late#################


HOT_data_late <- read.csv("genus_EPSMinusPhasesInfo_top10_Late.csv", header=TRUE,check.names=FALSE)
head(HOT_data_late)
data_melt_late <-melt(HOT_data_late)
head(data_melt_late)

g <- ggplot(subset(data_melt_late, value >0), aes(x=reorder(variable), y=Taxa, color=Taxa))
g <- g + geom_point(aes(size=value)) # plot the points and scale them to value
g <- g + theme_bw() # use a white background
g <- g + theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "")  # rotate and centre labels
pdf("Late_EPSMinus_bubble.pdf", 10, 10)
g
dev.off()

q <-ggplot(data=subset(data_melt_late, value >0), aes(x=Taxa, y=value)) + geom_bar(stat="identity", fill="navy")
q <-q +theme(axis.text.x = element_text(angle = 60, vjust = 0.8, hjust = 1.0)) +labs(x = "") + ylim(0, 70000) # rotate and centre labels
pdf("Late_EPSMinus_geombar.pdf", 10, 10)
q
dev.off()



