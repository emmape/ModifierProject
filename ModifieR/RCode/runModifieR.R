args = commandArgs(trailingOnly=TRUE)
sum <- 5+5
print(args[1])
print(sum)

aFunction <- function (astring){
  print(astring)
}
aFunction(args[2]) 
#aFunction("Here is some input!!!")


#source("create_input.R")

#exprMatrix <- read.csv("expression_matrix.csv", stringsAsFactors=FALSE, sep=" ")
#nrow(exprMatrix)
#ncol(exprMatrix)
#typeof(exprMatrix)

#probeMap <- read.csv("probe_map.csv", sep=" ")
#nrow(probeMap)
#ncol(probeMap)
#typeof(probeMap)
#probeMap <- data.frame(probeMap)

#indici1 <- c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15)
#indici2 <- c(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34)

#i <- create_input(exprMatrix, probeMap, indici1, indici2)
#i$diff_genes
#i$correlation_p_values

#i2 <- create_input(exprMatrix, probeMap, indici1, indici2, TRUE, TRUE)
#i2$diff_genes
#i2$correlation_p_values
#i2

