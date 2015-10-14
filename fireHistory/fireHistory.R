#SWS 5182 paleo climate proxies assignment
libary(plyr)
library(ggplot2)
#library(raster)
setwd('~/projects/classProjects/fireHistory')


fireData=data.frame(siteName=character(),
                    region=character(),
                    Fire=integer(),
                    year=integer())

fireDataYearReference=data.frame(siteName=character(),
                                 region=character(),
                                 firstYear=integer(),
                                 lastYear=integer())


dataFiles=c('iwSites.csv','ncSites.csv','pnwSites.csv','swSites.csv')
for(thisFile in dataFiles){
  site=read.csv(thisFile)
  trees=colnames(site)[-1]
  for(treeName in trees){
    tree=site[,c('Year',treeName)]
    rownames(tree)=NULL
    colnames(tree)=c('Year','Fire')
    tree=tree[!is.na(tree$Fire),]
    tree=tree[tree$Fire>0,]
    tree$Fire=tree$Fire-1
    
    region=strsplit(thisFile,'S')[[1]][1]
    #freq=mean(tree$Fire)
    high=max(tree$Year)
    low=min(tree$Year)
    #treeData=data.frame(siteName=treeName, region=region, frequency=freq, firstYear=low, lastYear=high)
    treeYears=data.frame(siteName=treeName, region=region,firstYear=low, lastYear=high)
    tree$region=region
    tree$siteName=treeName
    fireData=rbind(fireData, tree)
    fireDataYearReference=rbind(fireDataYearReference, treeYears)
  }
}
#fireData=fireData[fireData$region=='iw',]
#fireDataYearReference=fireDataYearReference[fireDataYearReference$region=='iw',]

siteNameRef=1:length(unique(fireData$siteName))
siteNameRef=data.frame(siteName=sort(unique(fireData$siteName)), siteNum=1:length(unique(fireData$siteName)))
fireData=merge(fireData, siteNameRef, by='siteName')
fireDataYearReference=merge(fireDataYearReference, siteNameRef, by='siteName')


  ggplot()+
  theme_bw()+
  geom_segment(data=fireDataYearReference, mapping=aes(x=firstYear, y=siteNum, xend=lastYear, yend=siteNum))+
  geom_point(data=fireData[fireData$Fire==1,], mapping=aes(x=Year, y=siteNum),size=3, colour='red')+
  xlab('Year')+
  ylab('Trees')+
  theme(axis.text.y=element_blank(), text=element_text(size=50))
    

  
##############################
  #plot all the sites on a map

sites=read.csv('sites.csv')
sites$long=sites$long*-1
#coordinates(sites)=~lat+long

map('state', resolution=0)
points(x=sites$long, y=sites$lat, col='red')
