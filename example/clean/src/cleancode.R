# This code creates output: fig1_biplot.png
# codecleanR Fri Jul 14 19:10:09 2017
data.16 <- read.csv("projects/2016/july_biomass_survey.csv")
data.v1.1to4 <- data.16[,1:4]
data.v1.1to4 <- data.v1.1to4 * 2
data.v1.1to4.2 <- data.v1.1to4 * 2
data.16[,1:4] <- data.v1.1to4.2
png('figures_1/fig1_biplot.png')
plot(data.16[,1:2])
dev.off()
