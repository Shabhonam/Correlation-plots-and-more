# Correlation-plots-and-more

> Input data and table are directly read inside the scripts



## Table of Contents (Optional)



- [Bubbleplot reordered]
- [Correlation with single bacteria]
- [Correlation with all metabolies vs all bacteria genus]
- [Data: please email me to get the input data]


---

## Example (put the two tables in the path)

```library(gplots)
library(ggplot2)

setwd("~/Desktop/Testdata/Deborah/NewPlate/Metabolitedata/Lindsay/")

abund_table<-read.csv("genus_All_EPSandEPSminus_first36hours.csv",row.names=1,check.names=FALSE)
#Transpose the data to have sample names on rows
abund_table<-t(abund_table)
head(abund_table)
meta_table<-read.csv("BifOnly_first36hours.csv",row.names=1,check.names=FALSE)
```

---

## Installation

- No installation needed, however R studio is recommended with gplots and ggplot2 as dependency

### Clone

- Clone this repo to your local machine using `git clone command`


> To get started...

### Step 1

- **Option 1**
    - Clone the repo!

- **Option 2**
    - 👯 Set the input files, to change the font:Modify the text aguements
```p <- ggplot(aes(x=Type, y=Taxa, fill=Correlation), data=df)
p <- p + geom_tile() + scale_fill_gradient2(low="slateblue", mid="white", high="red") 
p<-p+theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
p <-p+ theme(axis.title.y = element_text(color="#993333", size=14))
p<-p+geom_text(aes(label=Significance), color="black", size=5)+labs(y=NULL, x=NULL, fill=method)
p<-p+facet_grid(. ~ Metabolite, drop=TRUE,scale="free",space="free_x",labeller=Env_labeller)
pdf(paste("Correaltion36hours.pdf",sep=""),height=15,width=10)
print(p)
p
dev.off()
```
### Step 2

- **Save it to pdf file!** 🔨🔨🔨

### Step 3

-**That's it
