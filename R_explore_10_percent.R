kdd_colnames <- c("duration","protocol_type","service","flag",
                  "src_bytes","dst_bytes","land","wrong_fragment",
                  "urgent","hot","num_failed_logins","logged_in",
                  "num_compromised","root_shell","su_attempted",
                  "num_root","num_file_creations","num_shells",
                  "num_access_files","num_outbound_cmds",
                  "is_host_login","is_guest_login","count",
                  "srv_count","serror_rate","srv_serror_rate","rerror_rate",
                  "srv_rerror_rate","same_srv_rate","diff_srv_rate",
                  "srv_diff_host_rate","dst_host_count",
                  "dst_host_srv_count","dst_host_same_srv_rate",
                  "dst_host_diff_srv_rate","dst_host_same_src_port_rate",
                  "dst_host_srv_diff_host_rate","dst_host_serror_rate",
                  "dst_host_srv_serror_rate","dst_host_rerror_rate",
                  "dst_host_srv_rerror_rate","label")

# Load train and test data
kdd_data_10_percent <- read.csv("../kddcup.data_10_percent", 
                     header=F,
                     col.names=kdd_colnames)

kdd_data_corrected <- read.csv("../corrected", 
                                          header=F,
                                          col.names=kdd_colnames)

# complete factor levels where needed
# Add a new level
levels(kdd_data_10_percent$service) <- c(levels(kdd_data_10_percent$service), "Other")
levels(kdd_data_corrected$service) <- c(levels(kdd_data_corrected$service), "Other")
# Get top 40 frequent levels
top_service_levels_train <- names(tail(sort(table(kdd_data_10_percent$service)),40))
top_service_levels_test <- names(tail(sort(table(kdd_data_corrected$service)),40))
# Assign less frequent levels to "Other"
kdd_data_10_percent[!kdd_data_10_percent$service %in% top_service_levels_train,]$service <- "Other"
kdd_data_corrected[!kdd_data_corrected$service %in% top_service_levels_test,]$service <- "Other"
# drop empty levels
kdd_data_10_percent$service <- factor(kdd_data_10_percent$service)
kdd_data_corrected$service <- factor(kdd_data_corrected$service)
# Get all levels
all_service_levels <- union(
    levels(kdd_data_10_percent$service), 
    levels(kdd_data_corrected$service)
)
# Assign the same levels to train and test
levels(kdd_data_10_percent$service) <- all_service_levels
levels(kdd_data_corrected$service) <- all_service_levels

# train a RF with all variables (this is in the order of 1-2h to complete)
library(randomForest)
kdd_rf_model <- randomForest(label~., data=kdd_data_10_percent, method="class", ntrees=10)
summary(kdd_rf_model)

# Predict on the test set
kdd_rf_pred <- predict(kdd_rf_model, newdata=kdd_data_corrected, type="response")


# TODO
# calculate accuracy

# Do some aggregates
by_label_means_10_percent <- aggregate(duration~label, data=kdd_data_10_percent, mean)

# And plots
library(ggplot2)
ggplot(data=by_label_means_10_percent, aes(x=label, y=duration)) +
    geom_bar(stat="identity", fill="grey") +
    xlab("Label") +
    ylab("Duration")
