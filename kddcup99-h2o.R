
# Connect to h2o cluster
source("h2o_connect.R")

# Load data into h2o
source("h2o_loader.R")

summary(kdd_data.hex)
is.factor(kdd_data.hex[,42])
label_names <- levels(kdd_data.hex[,42])

# Explore data a bit
source("h2o_explore.R")

# plot results
library(ggplot2)
ggplot(data=by_label_means, aes(x=C42, y=C1)) +
    geom_bar(stat="identity", fill="grey") +
    xlab("Label") +
    ylab("Duration")

