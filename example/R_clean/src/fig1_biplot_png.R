### The main project directory should be the working directory
### See setwd()
data.16 <- read.csv("projects/2016/july_biomass_survey.csv")
data.v1.1to4 <- data.16[,1:4]
data.v1.1to4 <- data.v1.1to4 * 2
data.v1.1to4.2 <- data.v1.1to4 * 2
data.16[,1:4] <- data.v1.1to4.2
png("results/fig1_biplot.png")
plot(data.16[,1:2])
dev.off()
