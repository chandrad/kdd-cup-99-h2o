# Connect to H2O cluster
library(h2o)
h2o_ip <- '169.254.206.2'
h2o_port <- 54321
jupiterH2O <- h2o.init(ip = h2o_ip, port=h2o_port)
