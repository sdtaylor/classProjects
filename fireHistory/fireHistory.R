#SWS 5182 paleo climate proxies assignment
libary(plyr)
library(raster)
setwd('~/projects/classProjects/fireHistory')


fireData=data.frame(siteName=character(),
                    region=character(),
                    frequency=integer(),
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
    freq=mean(tree$Fire)
    high=max(tree$Year)
    low=min(tree$Year)
    treeData=data.frame(siteName=treeName, region=region, frequency=freq, firstYear=low, lastYear=high)
    fireData=rbind(fireData, treeData)
  }
}

sites=read.csv('sites.csv')
sites$long=sites$long*-1
#coordinates(sites)=~lat+long

map('state', resolution=0)
points(x=sites$long, y=sites$lat, col='red')
