knitr::opts_chunk$set(echo = FALSE)
# load HSAUR2 
library("HSAUR2")
# Forbes2000
data("Forbes2000")

library(knitr)
kable(head(Forbes2000))
str(Forbes2000)
nlevels(Forbes2000[,"country"])
levels(Forbes2000[,"country"])
top20 <- droplevels(subset(Forbes2000,rank<=20))
levels(top20[,"country"])
table(top20[,"country"])
levels(Forbes2000[,"category"])
table(Forbes2000[,"category"])
summary(Forbes2000[,"sales"])
layout(matrix(1:4, nrow = 2,ncol=2))
hist(Forbes2000$marketvalue, col="lightgrey",main="Histogram of market value")
hist(log(Forbes2000$marketvalue),col="lightgrey",main="Histogram of log(market value)")
boxplot(Forbes2000$marketvalue, col="lightgrey",main="Boxplot of market value")
boxplot(log(Forbes2000$marketvalue),col="lightgrey",main="Boxplot of log(market value)")
layout(matrix(1:2, nrow = 2))
plot(marketvalue ~ sales, data = Forbes2000, pch = ".")
plot(log(marketvalue) ~ log(sales), data = Forbes2000, pch = ".")
library(ggplot2)
#?qplot
qplot(marketvalue,data = Forbes2000)
qplot(log(marketvalue),  data = Forbes2000)
qplot(marketvalue,sales, data=Forbes2000)
qplot(log(marketvalue),log(sales),size=assets,alpha = I(0.1),data=Forbes2000)
library(calibrate)
profits_all = na.omit(Forbes2000$profits)  # all_profts without No data
order_profits = order(profits_all)     # index of the profitable companies in decreasing order
top_50 = rev(order_profits)[1:50]      # top 50 profitable companies

sales = Forbes2000$sales[top_50]       # sales of the 50 top profitable companies
assets = Forbes2000$assets[top_50]     # assets of the 50 top profitable companies
countries = Forbes2000$country[top_50] # countries where the 50 top profitable companies are found

plot(assets,sales,pch =1)
textxy(assets,sales, abbreviate(countries,2),col = "blue",cex=0.5)  # used to put the countries where the companies are found
title(main = "Sales and Assets in billion USD \n of the 50 most profitable companies ", col.main = "gray")
tmp <- subset(Forbes2000,
        country %in% c("United Kingdom", "Germany","India", "Turkey"))
tmp$country <- tmp$country[,drop = TRUE]
plot(log(marketvalue) ~ country, data = tmp, col = 3:6,
       ylab = "log(marketvalue)", varwidth = TRUE)
library(lattice)
xyplot(log(marketvalue)~log(sales)|country,data=tmp)
data("USmelanoma",package="HSAUR2")
library(knitr)
kable(USmelanoma)
xr <- range(USmelanoma$mortality) * c(0.9, 1.1)
#layout(matrix(1:2, nrow = 2))
boxplot(USmelanoma$mortality, ylim = xr, horizontal = TRUE,xlab = "Mortality")
hist(USmelanoma$mortality, xlim = xr, xlab = "", main = "",axes = FALSE, ylab = "")
axis(1)
plot(mortality ~ ocean, data = USmelanoma, xlab = "Contiguity to an ocean", ylab = "Mortality")
dyes <- with(USmelanoma, density(mortality[ocean == "yes"]))
dno <- with(USmelanoma, density(mortality[ocean == "no"]))
plot(dyes, lty = 1, xlim = xr, main = "", ylim = c(0, 0.018))
lines(dno, lty = 2)
legend("topright", lty = 1:2, legend = c("Coastal State","Land State"), bty = "n")
layout(matrix(1:2, ncol = 2))
plot(mortality ~ -longitude, data = USmelanoma)
plot(mortality ~ latitude, data = USmelanoma)
plot(-USmelanoma$longitude,USmelanoma$latitude,asp=1.5,cex=.3,pch=19,col="blue")
library("sp")
library("maps")
library("maptools")
library("RColorBrewer")
map("state")
points(-USmelanoma$longitude,USmelanoma$latitude,asp=1.5,cex=.3,pch=19,col="blue")
#Create a function to generate a continuous color palette
rbPal <- colorRampPalette(c('blue','grey','red'))
#This adds a column of color values
# based on the y values
USmelanoma$Col <- (rbPal(10)[as.numeric(cut(USmelanoma$mortality,breaks = 10))])
map("state",xlim=c(-135,-65))
points(-USmelanoma$longitude,USmelanoma$latitude,col=USmelanoma$Col,asp=1.5,pch=19,cex=1.2)
legend("topleft",title="Decile",legend=quantile(USmelanoma$mortality,seq(0.1,1,l=10)),col =rbPal(10),pch=15,cex=1.,box.col = NA)
states <- map("state", plot = FALSE, fill = TRUE)
IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
rownames(USmelanoma) <- tolower(rownames(USmelanoma))

us1 <- map2SpatialPolygons(states, IDs=IDs,proj4string = CRS("+proj=longlat +datum=WGS84"))
us2 <- SpatialPolygonsDataFrame(us1, USmelanoma)

col <- colorRampPalette(c('blue', 'gray80','red'))

spplot(us2, "mortality", col.regions = col(200),par.settings = list(axis.line = list(col =  'transparent')),main="Map of the US showing malignant melanoma mortality rates")
## library(knitr)
## purl("Ch0.Rmd",output="Ch0.R", documentation = 1)
