#SWS 5182 paleo climate proxies assignment
library(plyr)
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
siteNameRef=data.frame(siteName=sort(unique(fireData$siteName)), siteNum=c(1:length(unique(fireData$siteName))+5))
fireData=merge(fireData, siteNameRef, by='siteName')
fireDataYearReference=merge(fireDataYearReference, siteNameRef, by='siteName')

####################################
#Tree data range graph with dots fore fires
  ggplot()+
  theme_bw()+
  geom_segment(data=fireDataYearReference, mapping=aes(x=firstYear, y=siteNum, xend=lastYear, yend=siteNum))+
  geom_point(data=fireData[fireData$Fire==1,], mapping=aes(x=Year, y=siteNum),size=3, colour='red')+
  xlab('Year')+
  ylab('Trees')+
  theme(axis.text.y=element_blank(), text=element_text(size=50))

####################################    
#Analysis

freqData=data.frame(period=integer(),
                    siteName=character(),
                    freq=integer(),
                    region=character())

beg=min(fireData$Year)
end=max(fireData$Year)
step=10
thisStep=beg
while(thisStep<end){
  thisStepData=fireData[fireData$Year>thisStep & fireData$Year<thisStep+10,]
  thisStepFreq=ddply(thisStepData, c('siteName','region'), summarize, freq=mean(Fire))
  thisStepFreq$period=thisStep
  freqData=rbind(freqData, thisStepFreq)
  thisStep=thisStep+step
}

freqData=ddply(freqData, c('region','period'), summarize, freq=mean(freq))

for(thisRegion in unique(freqData$region)){
  print(with(freqData[freqData$region==thisRegion,], plot(freq~period, type='l',main=thisRegion, ylab='Fire Frequency',xlab='Year', col='red',lwd=9.5, ylim=c(0,1), xlim=c(1100, 2000))))
}


ggplot(freqData, aes(x=period, y=freq, colour=region, group=region))+geom_line(size=3)+
  theme_bw()+
  xlab('Year')+
  ylab('Fire Frequency')+
  theme(legend.position=c(0.8,0.8))+
  theme(text=element_text(size=50))+
  theme(legend.text=element_text(size=50))+
  theme(legend.position=c(0.8,0.8))

  
##############################
  #plot all the sites on a map

sites=read.csv('sites.csv')
sites$long=sites$long*-1
#coordinates(sites)=~lat+long

map('state', resolution=0)
points(x=sites$long, y=sites$lat, col='red')
