# Will cluster for k = 40 (at least we have 23 different labels in our dataset)
# Won't use the label, of course
# k-means works just on numeric data, we can't use some predictors like they are
# right now: protocol, service, and flag 
kdd_data.km <- h2o.kmeans(
    data = kdd_data.hex, 
    centers = 40, 
    cols = c(1,5:41), 
    normalize=T,
    iter.max=10)
print(kdd_data.km)
