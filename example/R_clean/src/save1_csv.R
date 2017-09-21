### The main project directory should be the working directory
### See setwd()
data.16 <- read.csv("projects/2016/july_biomass_survey.csv")
data.v1.1to4 <- data.16[,1:4]
data.v1.1to4 <- data.v1.1to4 * 2
write.csv(data.v1.1to4,'projects/data_forestplot/save1.csv',row.names = F)
