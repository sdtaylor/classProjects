#SWS 5182 paleo climate proxies assignment
libary(plyr)
library(raster)
setwd('~/projects/classProjects/fireHistory')

site1=read.csv('iwSites.csv')
sites=read.csv('sites.csv')
sites$long=sites$long*-1
#coordinates(sites)=~lat+long

map('state', resolution=0, myborder=-2)
points(x=sites$long, y=sites$lat, col='red')
