setwd("~/Desktop/Testdata/Deborah/NewPlate/Metabolitedata/Lindsay/")

abund_table<-read.csv("genus_All_EPSandEPSminus_first36hours.csv",row.names=1,check.names=FALSE)
#Transpose the data to have sample names on rows
abund_table<-t(abund_table)
head(abund_table)
meta_table<-read.csv("BifOnly_first36hours.csv",row.names=1,check.names=FALSE)
head(meta_table)
#Filter out samples with fewer counts
abund_table<-abund_table[rowSums(abund_table)>0,]

#Extract the corresponding meta_table for the samples in abund_table
meta_table<-meta_table[rownames(abund_table),]
#Sulfate_prostate	SMCSO_prostate	ITCs	Indoles	SMCSO	Cruciferous	Alium
#You can use sel_env to specify the variables you want to use and sel_env_label to specify the labes for the pannel


# sel_env<-c("Onepropanol", "TwoHydroxyisovalerate", "Twomethylbutyricifr", "FiveAminopentanoate", "Acetate","Aspartate","Betaine","Butyrate","Ethanol","Formate","Glutamate","Isobutyrate","Isocaproate","Isovalerate","Lactate","NAcetylaspartate","Propionate","Succinate","Trimethylamine","Valerate","glucose5mMifr","betaAlanine","Bifidobacterium_breve","Bifidobacterium")
# sel_env_label <- list(
#   'Onepropanol'="1-propanol",
#   'TwoHydroxyisovalerate'="2-Hydroxyisovalerate",
#   'Twomethylbutyricifr'="2-methylbutyric_ifr",
#   'FiveAminopentanoate'="5-Aminopentanoate",
#   'Acetate'="Acetate",
#   'Aspartate'="Aspartate",
#   'Betaine'="Betaine",
#   'Butyrate'="Butyrate",
#   'Ethanol'="Ethanol",
#   'Formate'="Formate",
#   'Glutamate'="Glutamate",
#   'Isobutyrate'="Isobutyrate",
#   'Isocaproate'="Isocaproate",
#   'Isovalerate'="Isovalerate",
#   'Lactate'="Lactate",
#   'NAcetylaspartate'="N-Acetylaspartate",
#   'Propionate'="Propionate",
#   'Succinate'="Succinate",
#   'Trimethylamine'="Trimethylamine",
#   'Valerate'="Valerate",
#   'glucose5mMifr'="Glucose5mM",
#   'betaAlanine'="beta-Alanine",
#   'Bifidobacterium_breve'="Bifidobacterium breve",
#   'Bifidobacterium' = "Bifidobacterium"
#   
# 
# )



sel_env <-c("Bifidobacterium_breve","Bifidobacterium")
sel_env_label <-list(
  'Bifidobacterium_breve'="Bifidobacterium breve",
  'Bifidobacterium' = "Bifidobacterium")

# sel_env <-c("Bacteroides","Buttiauxella","Enterobacter","Escherichia","Klebsiella","Lelliottia","Haemophilus","Actinomyces","Bifidobacterium","Corynebacterium","Rothia","Cutibacterium","Staphylococcus","Granulicatella","Enterococcus","Streptococcus","Clostridium","Agathobacter","Anaerosporobacter","Anaerostipes","Blautia","Coprococcus","Dorea","Lachnoclostridium","Roseburia","Sellimonas","Tyzzerella","Clostridioides","Intestinibacter","Terrisporobacter","Faecalibacterium","Ruminococcus","Erysipelatoclostridium","Faecalitalea")
# sel_env_label <-list(
#   'Bacteroides'="Bacteroides",
#   'Buttiauxella'="Buttiauxella",
#   'Enterobacter'="Enterobacter",
#   'Escherichia'="Escherichia",
#   'Klebsiella'="Klebsiella",
#   'Lelliottia'="Lelliottia",
#   'Haemophilus'="Haemophilus",
#   'Actinomyces'="Actinomyces",
#   'Bifidobacterium'="Bifidobacterium",
#   'Corynebacterium'="Corynebacterium",
#   'Rothia'="Rothia",
#   'Cutibacterium'="Cutibacterium",
#   'Staphylococcus'="Staphylococcus",
#   'Granulicatella'="Granulicatella",
#   'Enterococcus'="Enterococcus",
#   'Streptococcus'="Streptococcus",
#   'Clostridium'="Clostridium",
#   'Agathobacter'="Agathobacter",
#   'Anaerosporobacter'="Anaerosporobacter",
#   'Anaerostipes'="Anaerostipes",
#   'Blautia'="Blautia",
#   'Coprococcus'="Coprococcus",
#   'Dorea'="Dorea",
#   'Lachnoclostridium'="Lachnoclostridium",
#   'Roseburia'="Roseburia",
#   'Sellimonas'="Sellimonas",
#   'Tyzzerella'="Tyzzerella",
#   'Clostridioides'="Clostridioides",
#   'Intestinibacter'="Intestinibacter",
#   'Terrisporobacter'="Terrisporobacter",
#   'Faecalibacterium'="Faecalibacterium",
#   'Ruminococcus'="Ruminococcus",
#   'Erysipelatoclostridium'="Erysipelatoclostridium",
#   'Faecalitalea'="Faecalitalea"
#   )

sel_env_label<-t(as.data.frame(sel_env_label))

sel_env_label<-as.data.frame(sel_env_label)
colnames(sel_env_label)<-c("Trans")

sel_env_label$Trans<-as.character(sel_env_label$Trans)

#Now get a filtered table based on sel_env
meta_table_filtered<-meta_table[,sel_env]
meta_table_filtered
abund_table_filtered<-abund_table[rownames(meta_table_filtered),]
#Apply normalisation (either use relative or log-relative transformation)
#x<-abund_table_filtered/rowSums(abund_table_filtered)
x<-log((abund_table_filtered+1)/(rowSums(abund_table_filtered)+dim(abund_table_filtered)[2]))

x<-x[,order(colSums(x),decreasing=TRUE)]
#Extract list of top N Taxa
N<-51
taxa_list<-colnames(x)[1:N]
#remove "__Unknown__" and add it to others
taxa_list<-taxa_list[!grepl("Unknown",taxa_list)]
N<-length(taxa_list)
x<-data.frame(x[,colnames(x) %in% taxa_list])
y<-meta_table_filtered
x
#Get grouping information
grouping_info<-data.frame(row.names=rownames(abund_table),t(as.data.frame(strsplit(rownames(abund_table),"_"))))
# > head(grouping_info)
# X1 X2 X3
# T_2_1   T  2  1
# T_2_10  T  2 10
# T_2_12  T  2 12
# T_2_2   T  2  2
# T_2_3   T  2  3
# T_2_6   T  2  6

#Let us group on countries
groups<-grouping_info[,1]
groups
#You can use kendall, spearman, or pearson below:
method<-"kendall"
colnames(x)
colnames(y)
a
b
i
#Now calculate the correlation between individual Taxa and the environmental data
df<-NULL
for(i in colnames(x)){
  for(j in colnames(y)){
    for(k in unique(groups)){
      a<-x[groups==k,i,drop=F]
      b<-y[groups==k,j,drop=F]
      tmp<-c(i,j,cor(a[complete.cases(b),],b[complete.cases(b),],use="everything",method=method),cor.test(a[complete.cases(b),],b[complete.cases(b),],method=method)$p.value,k)
      if(is.null(df)){
        df<-tmp  
      }
      else{
        df<-rbind(df,tmp)
      }    
    }
  }
}

df<-data.frame(row.names=NULL,df)
df
colnames(df)<-c("Taxa","Metabolite","Correlation","Pvalue","Type")
df$Pvalue<-as.numeric(as.character(df$Pvalue))
df$AdjPvalue<-rep(0,dim(df)[1])
df$Correlation<-as.numeric(as.character(df$Correlation))

#You can adjust the p-values for multiple comparison using Benjamini & Hochberg (1995):
# 1 -> donot adjust
# 2 -> adjust Env + Type (column on the correlation plot)
# 3 -> adjust Taxa + Type (row on the correlation plot for each type)
# 4 -> adjust Taxa (row on the correlation plot)
# 5 -> adjust Env (panel on the correlation plot)
adjustment_label<-c("NoAdj","AdjEnvAndType","AdjTaxaAndType","AdjTaxa","AdjEnv")
adjustment<-5

if(adjustment==1){
  df$AdjPvalue<-df$Pvalue
} else if (adjustment==2){
  for(i in unique(df$Metabolite)){
    for(j in unique(df$Type)){
      sel<-df$Metabolite==i & df$Type==j
      df$AdjPvalue[sel]<-p.adjust(df$Pvalue[sel],method="BH")
    }
  }
} else if (adjustment==3){
  for(i in unique(df$Taxa)){
    for(j in unique(df$Type)){
      sel<-df$Taxa==i & df$Type==j
      df$AdjPvalue[sel]<-p.adjust(df$Pvalue[sel],method="BH")
    }
  }
} else if (adjustment==4){
  for(i in unique(df$Taxa)){
    sel<-df$Taxa==i
    df$AdjPvalue[sel]<-p.adjust(df$Pvalue[sel],method="BH")
  }
} else if (adjustment==5){
  for(i in unique(df$Metabolite)){
    sel<-df$Metabolite==i
    df$AdjPvalue[sel]<-p.adjust(df$Pvalue[sel],method="BH")
  }
}

#Now we generate the labels for signifant values
df$Significance<-cut(df$AdjPvalue, breaks=c(-Inf, 0.001, 0.01, 0.05, Inf), label=c("***", "**", "*", ""))

#We ignore NAs
df 
df<-df[complete.cases(df),]
write.csv(df,"df-table-breve.csv")
#We want to reorganize the Env data based on they appear
df$Metabolite<-factor(df$Metabolite,as.character(df$Metabolite))
df <-read.csv("df-table-breve.csv") #supplying modified  table
#We use the function to change the labels for facet_grid in ggplot2
Env_labeller <- function(variable,value){
  return(sel_env_label[as.character(value),"Trans"])
}
df
p <- ggplot(aes(x=Type, y=Taxa, fill=Correlation), data=df)
p <- p + geom_tile() + scale_fill_gradient2(low="slateblue", mid="white", high="red") 
p<-p+theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
p <-p+ theme(axis.title.y = element_text(color="#993333", size=14))
p<-p+geom_text(aes(label=Significance), color="black", size=3)+labs(y=NULL, x=NULL, fill=method)
p<-p+facet_grid(. ~ Metabolite, drop=TRUE,scale="free",space="free_x",labeller=Env_labeller)
pdf(paste("Correaltion36hours.pdf",sep=""),height=15,width=10)
print(p)
p
dev.off()

