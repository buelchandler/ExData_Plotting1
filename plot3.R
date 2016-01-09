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
subPower$Sub_metering_1 <- as.numeric(as.character(subPower$Sub_metering_1))
subPower$Sub_metering_2 <- as.numeric(as.character(subPower$Sub_metering_2))
subPower$Sub_metering_3 <- as.numeric(as.character(subPower$Sub_metering_3))
## clean-up dates
subPower <- transform(subPower, dtstamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

## prep the graphics device
png("plot3.png", width=480, height=480)

# type =“n” sets up the plot and does not fill it with data
with(subPower, plot(dtstamp, Sub_metering_1, ylab="Energy Submetering", xlab="", type = "n"))
# subsets of data are plotted here using different colors
with(subPower, lines(dtstamp, Sub_metering_1, col = "black"))
with(subPower, lines(dtstamp, Sub_metering_2, col = "red"))
with(subPower, lines(dtstamp, Sub_metering_3, col = "blue"))
legend("topright", cex=0.65, lty=c(1,1), lwd=c(1,1), col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))

## end graphics device
dev.off()

