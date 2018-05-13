args = commandArgs(trailingOnly=TRUE)
setwd(args[6])
#setwd("C:/Users/emmae/Programmering/ModifieR/ModifierFrontAndBackend/ModifierProject/ModifieR/RCode")
#source("create_input.R")

######## Formatting input #####################
exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
#exprMatrix <- read.csv("tmpFilestorage/expressionMatrix50b52162-5427-4876-96ed-f9c54beee1a2.txt", stringsAsFactors=FALSE, sep=" ")
probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
#probeMap <- read.csv("tmpFilestorage/probeMap50b52162-5427-4876-96ed-f9c54beee1a2.txt", sep=" ")
probeMap <- data.frame(probeMap)
indici1 <- strsplit(args[1], ";")
#indici1 <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
indici2 <- strsplit(args[2], ";")
#indici2 <- c(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33, 34)
label1 <- args[3]
#label1 <- "Control"
label2 <- args[4]
#label2 <- "Disease"

####### Creating a modifierInput object ###############

#modifierInput <- MODifieRDev::create_input(exprMatrix, probeMap, indici1, indici2, label1, label2, T, T, T)
#modifierInput <- create_input(exprMatrix, probeMap, indici1, indici2, label1, label2)
#write.csv(modifierInput$diff_genes, file = paste("tmpFilestorage/output","50b52162-5427-4876-96ed-f9c54beee1a2",".csv", sep=""))
write.csv("Testing testing", file = paste("tmpFilestorage/output",args[7],".csv", sep=""))
#print(args[7])

######## Getting PPI network, local or download ###########
#network <- read.csv("network.txt", stringsAsFactors=FALSE, sep=" ")
#networkDF <- data.frame(network)
#source("general_functions.R")
#library("STRINGdb")
#network <- MODifieRDev::get_string_DB_ppi()

####### Performing selected analysis ######################
if(args[5] == "diamond"){
	#source("R/diamond.R")
	#diamond <- MODifieRDev::diamond(modifierInput, network)
	#print(diamond$module_genes)
	print("diamond output!")
} else if(args[5] == "cliqueSum"){
#	source("R/clique_sum.R")
	#cliqueSum <- MODifieRDev::clique_sum(modifierInput, network)
	#print(cliqueSum)
	print("cliqueSum output!")
}else if(args[5] == "correlationClique"){
	#source("R/correlation_clique.R")
	#correlationClique <- MODifieRDev::correlation_clique(modifierInput, network)
	#print(correlationClique)
	print("correlationClique output!")
}else if(args[5] == "diffCoEx"){
	#source("R/diffcoex.R")
	#diffcoex <- MODifieRDev::diffcoex(modifierInput)
	#print(diffcoex)
	print("DiffCoEx output!")
}else if(args[5] == "dime"){
	#source("R/dime.R")
	#dime <- MODifieRDev::dime(modifierInput)
	#print(dime)
	print("Dime output!")  
}else if(args[5] == "mcode"){
	#source("R/mcode.R")
	#mcode <- MODifieRDev::mod_mcode(modifierInput, network)
	#print(mcode)
	print("Mcode output!")
}else if(args[5] == "moda"){
	#source("R/moda.R")
	#moda <- MODifieRDev::moda(modifierInput, "Density", 0.1, 0.1, "tmpFilestorage" )
	#print(moda)
	print("Moda output!")
}else if(args[5] == "moduleDiscoverer"){
  #source("R/modulediscoverer.R")
	#modulediscoverer <- MODifieRDev::modulediscoverer(modifierInput, network)
	#print(modulediscoverer)
	print("ModuleDiscoverer output!")
}

#print(geterrmessage())