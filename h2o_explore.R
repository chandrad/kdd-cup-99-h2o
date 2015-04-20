# Add function taking mean of duration column
duration_mean <- function(df) { mean(df[,1]) }
h2o.addFunction(jupiterH2O, duration_mean)

# Apply function to groups by label
# uses h2o's ddply, since kdd_data.hex is an H2OParsedData object
res <- h2o.ddply(kdd_data.hex, "C42", duration_mean)
by_label_means <- as.data.frame(head(res,23))

# h2o seems to be inconsistent when labeling factor results
if (!is.factor(by_label_means$C42)) {
    by_label_means$C42 <- as.factor(label_names[by_label_means$C42+1])
}