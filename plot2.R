### Note: wrtten as a stand-alone

## get zip UCI file
pkgs = c("downloader") ## use "downloader" package from CRAN
if(length(new.pkgs <- setdiff(pkgs, rownames(installed.packages())))) install.packages(new.pkgs)
library(downloader)

download("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dest="household_power_consumption.zip", mode="wb")
unzip ("household_power_consumption.zip", exdir = "./")

## now load the data.table
dataFile <- "household_power_consumption.txt" 
power <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, na.strings = "?")

## for this graph, we are only looking at 2007-02-01 and 2007-02-02
power$Date <- as.Date(power$Date, format="%d/%m/%Y")
subPower <- power[(power$Date=="2007-02-01") | (power$Date=="2007-02-02"),]

## clean up our data column we're interested in
subPower$Global_active_power <- as.numeric(as.character(subPower$Global_active_power))
## clean-up dates
subPower <- transform(subPower, dtstamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

## prep the graphics device
png("plot2.png", width=480, height=480)

## plot it
with(subPower, plot(dtstamp, Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type = "l"))

## end graphics device
dev.off()

