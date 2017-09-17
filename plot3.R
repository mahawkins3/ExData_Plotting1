#Read data only for the two days we need (to reduce memory usage)
data <- read.table("household_power_consumption.txt", sep = ";", skip = grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")),nrows = 2880)

#Parse column headers from .txt file and name columns
headers <- read.table("household_power_consumption.txt", nrows = 1)
headers <- unlist(strsplit(as.character(headers[, 1]), split = ";"))
colnames(data) <- headers

#Merge the date and time columns, convert the new column to datetime and bind this to the left of the data (without original date and time colums)
data <- transform(data, Timestamp=paste(Date, Time, sep = " "))
data <- cbind(data$Timestamp, data[, 3:9])
dates <- as.data.frame(strptime(data[, 1], format = "%d/%m/%Y %H:%M:%S"))
data <- cbind(dates, data[, 2:8])
colnames(data)[1] <- "Timestamp"

#Plot 3 lines showing Energy sub metering over the course of the two days, with legend identifying each of the three sub_metering results
plot(data$Timestamp, data$Sub_metering_1, type = "l", xlab = "", ylab = "Engergy sub metering")
lines(data$Timestamp, data$Sub_metering_2, type = "l", col = "green")
lines(data$Timestamp, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","green","blue"), lty=1)


#Create PNG image of plot
dev.copy(png, "plot3.png")
dev.off()