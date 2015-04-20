# Load data - our file is stored in the cluster NFS structure
key_name <- "kdd_data.hex"
kdd_data.hex <- h2o.importFile(
    jupiterH2O, 
    path = "/nfs/data/KDD99/kddcup.data", 
    key = key_name)

print(paste("Loaded data with", nrow(kdd_data.hex), "entries into", key_name))