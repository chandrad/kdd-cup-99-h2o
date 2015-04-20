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

# remove this as needed - we use it for exploratory / comparison purposes
kdd_data <- read.csv("kddcup.data_10_percent", 
                     header=F,
                     col.names=kdd_colnames)
by_label_means_10_percent <- aggregate(duration~label, data=kdd_data, mean)


# Connect to H2O cluster
library(h2o)
jupiterH2O <- h2o.init(ip = '169.254.206.2', port=54321)

# Load data - our file is stored in the cluster NFS structure
kdd_data.hex <- h2o.importFile(
    jupiterH2O, 
    path = "/nfs/data/KDD99/kddcup.data", 
    key = "kdd_data.hex")
summary(kdd_data.hex)

# Add function taking mean of duration column
fun <- function(df) { sum(df[,1], na.rm = T)/nrow(df) }
h2o.addFunction(jupiterH2O, fun)

# Apply function to groups by label
# uses h2o's ddply, since kdd_data.hex is an H2OParsedData object
res <- h2o.ddply(kdd_data.hex, c(42), fun)
by_label_means <- as.data.frame(head(res,23))

# Explore results
library(ggplot2)
ggplot(data=by_label_means, aes(x=C42, y=C1)) +
    geom_bar(stat="identity", fill="grey") +
    xlab("Label") +
    ylab("Duration")

