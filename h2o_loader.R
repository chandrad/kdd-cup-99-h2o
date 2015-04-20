# Load data - our file is stored in the cluster NFS structure
key_name_data <- "kdd_data.hex"
kdd_data.hex <- h2o.importFile(
    jupiterH2O, 
    path = "/nfs/data/KDD99/kddcup.data", 
    key = key_name_data)

key_name_corrected <- "kdd_corrected.hex"
kdd_corrected.hex <- h2o.importFile(
    jupiterH2O, 
    path = "/nfs/data/KDD99/corrected", 
    key = key_name_corrected)

print(paste("Loaded data with", nrow(kdd_data.hex), "entries into", key_name_data))
print(paste("Loaded corrected data with", nrow(kdd_corrected.hex), "entries into", key_name_corrected))
