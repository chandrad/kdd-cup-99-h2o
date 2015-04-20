
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


# Cluster using k-means
source("h2o_kmeans.R")
print(paste("Total within SS is ", kdd_data.km@model$tot.withinss))

# count labels for each cluster
# TODO


# Train random forest
source("h2o_train_rf.R")

# predict using random forest
kdd_data.rf.pred <- h2o.predict(kdd_data.rf, newdata=kdd_corrected.hex)
head(kdd_data.rf.pred)

# get accuracy (h2o result gives problems with colums 20 and 22, don't know why...)
accuracies <- sapply(
    c(1:19,21,23), 
    function(x) {  h2o.performance(kdd_data.rf.pred[,x+1], kdd_corrected.hex$C42==label_names[x])@model$accuracy }
    )
accuracy <- mean(accuracies)

# Plot accuracies
accuracies.df <- data.frame(label=label_names[c(1:19,21,23)], accuracy=accuracies)
ggplot(data=accuracies.df, aes(x=label, y=accuracy)) +
    geom_bar(stat="identity", fill="grey") +
    xlab("Label") +
    ylab("Prediction accuracy")