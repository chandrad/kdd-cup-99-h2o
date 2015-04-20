# Try with every single predictor
kdd_data.rf <- h2o.randomForest(y = 42, x = c(1:41), data = kdd_data.hex, ntree = 100, depth = 500)
print(kdd_data.rf)
