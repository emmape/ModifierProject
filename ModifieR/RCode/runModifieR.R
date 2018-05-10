args = commandArgs(trailingOnly=TRUE)
setwd(args[6])
source("create_input.R")

######## Formatting input #####################
#exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
#probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
#probeMap <- data.frame(probeMap)
#indici1 <- strsplit(args[1], ";")
#indici2 <- strsplit(args[2], ";")
#label1 <- args[3]
#label2 <- args[4]

####### Creating a modifierInput object ###############

#modifierInput <- MODifieRDev::create_input(exprMatrix, probeMap, indici1, indici2, label1, label2)
#modifierInput <- create_input(exprMatrix, probeMap, indici1, indici2, label1, label2)
#write.csv(modifierInput$diff_genes, file = "tmpFilestorage/output",args[7],".csv")
write.csv("Testing testing", file = "tmpFilestorage/output",args[7],".csv")
print("After input creation!")

######## Getting PPI network, local or download ###########
#network <- read.csv("network.txt", stringsAsFactors=FALSE, sep=" ")
#source("general_functions.R")
#library("STRINGdb")
#network <- get_string_DB_ppi()

####### Performing selected analysis ######################
if(args[5] == "diamond"){
	source("R/diamond.R")
	#diamond <- diamond(network, modifierInput)
	#print(diamond$module_genes)
	print("diamond output!")
} else if(args[5] == "cliqueSum"){
	source("R/clique_sum.R")
	#cliqueSum <- clique_sum(modifierInput, network)
	#print(cliqueSum)
	print("cliqueSum output!")
}else if(args[5] == "correlationClique"){
	source("R/correlation_clique.R")
	#correlationClique <- correlation_clique(modifierInput, network)
	#print(correlationClique)
	print("correlationClique output!")
}else if(args[5] == "diffCoEx"){
	source("R/diffcoex.R")
	#diffcoex <- diffcoex(modifierInput)
	#print(diffcoex)
	print("DiffCoEx output!")
}else if(args[5] == "dime"){
	source("R/dime.R")
	#dime <- dime(modifierInput)
	#print(dime)
	print("Dime output!")  
}else if(args[5] == "mcode"){
	source("R/mcode.R")
	#mcode <- mcode(modifierInput, network)
	#print(mcode)
	print("Mcode output!")
}else if(args[5] == "moda"){
	source("R/moda.R")
	#moda <- moda(modifierInput)
	#print(moda)
	print("Moda output!")
}else if(args[5] == "moduleDiscoverer"){
  	source("R/modulediscoverer.R")
	#modulediscoverer <- modulediscoverer(modifierInput, network)
	#print(modulediscoverer)
	print("ModuleDiscoverer output!")
}

print(geterrmessage())