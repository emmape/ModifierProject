args = commandArgs(trailingOnly=TRUE)
setwd(args[5])
source("create_input.R")

exprMatrix <- read.csv("expressionMatrix.txt", stringsAsFactors=FALSE, sep=" ")
probeMap <- read.csv("probeMap.txt", sep=" ")
probeMap <- data.frame(probeMap)

indici1 <- strsplit(args[1], ";")
indici2 <- strsplit(args[2], ";")

#i <- create_input(exprMatrix, probeMap, indici1, indici2)
#print(i$diff_genes)
#i$correlation_p_values

#i2 <- create_input(exprMatrix, probeMap, indici1, indici2, TRUE, TRUE)
#i2$diff_genes
#i2$correlation_p_values
#i2

