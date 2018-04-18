args = commandArgs(trailingOnly=TRUE)
setwd(args[6])
source("create_input.R")

exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
probeMap <- data.frame(probeMap)

indici1 <- strsplit(args[1], ";")
indici2 <- strsplit(args[2], ";")
label1 <- args[3]
label2 <- args[4]

#i <- create_input(exprMatrix, probeMap, indici1, indici2, label1, label2)
#network <- read.csv("network.txt", stringsAsFactors=FALSE, sep=" ")
if(args[5] == "diamond"){
	source("R/diamond.R")
	#diamond <- diamond(network, i)
	#print(diamond$module_genes)
	print("diamond output!")
} else if(args[5] == "cliqueSum"){
	source("R/clique_sum.R")
	#cliqueSum <- clique_sum(i, network)
	#print(cliqueSum)
	print("cliqueSum output!")
}else if(args[5] == "correlationClique"){
	source("R/correlation_clique.R")
	#correlationClique <- correlation_clique(i, network)
	#print(correlationClique)
	print("correlationClique output!")
}else if(args[5] == "diffCoEx"){
	source("R/diffcoex.R")
	#diffcoex <- diffcoex(i)
	#print(diffcoex)
	print("DiffCoEx output!")
}else if(args[5] == "dime"){
	source("R/dime.R")
	#dime <- dime(i)
	#print(dime)
	print("Dime output!")  
}else if(args[5] == "mcode"){
	source("R/mcode.R")
	#mcode <- mcode(i, network)
	#print(mcode)
	print("Mcode output!")
}else if(args[5] == "moda"){
	source("R/moda.R")
	#moda <- moda(i)
	#print(moda)
	print("Moda output!")
}else if(args[5] == "moduleDiscoverer"){
  	source("R/modulediscoverer.R")
	#modulediscoverer <- modulediscoverer(i, network)
	#print(modulediscoverer)
	print("ModuleDiscoverer output!")
}

