library("gdata")
library("vegan")
library("txtplot")
data.16 <- read.csv("projects/2016/july_biomass_survey.csv")
data.v1.1to4 <- data.16[, 1:4]
data.v1.1to4 <- data.v1.1to4 * 2
data.v1.1to4.2 <- data.v1.1to4 * 2
data.16[, 1:4] <- data.v1.1to4.2
png("figures_1/fig1_biplot_t2.png")
plot(data.16[, 1:2] * 2)
dev.off()
