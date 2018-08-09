args = commandArgs(trailingOnly=TRUE)
#setwd(args[6])
setwd("C:/Users/emmae/Programmering/ModifieR/ModifierFrontAndBackend/ModifierProject/ModifieR/RCode")
#source("create_input.R")

######## Formatting input #####################
#exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
exprMatrix <- read.csv("tmpFilestorage/expressionMatrixbcc3e775-8325-45da-88c1-5c411b6ef7e5.txt", stringsAsFactors=FALSE, sep=" ")
#probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
probeMap <- read.csv("tmpFilestorage/probeMapbcc3e775-8325-45da-88c1-5c411b6ef7e5.txt", sep=" ")
probeMap <- data.frame(probeMap)
#indici1 <- strsplit(args[1], ";")
indici1 <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
#indici2 <- strsplit(args[2], ";")
indici2 <- c(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33, 34)
#label1 <- args[3]
label1 <- "Control"
#label2 <- args[4]
label2 <- "Disease"

####### Creating a modifierInput object ###############
exampleInput <- readRDS("C:/Users/emmae/Documents/Emmas/Bioinformatik/Master Thesis/FreshFolderForModifier/modifier_stuff180516/example_input.rds", refhook = NULL)
examplePpi <- readRDS("C:/Users/emmae/Documents/Emmas/Bioinformatik/Master Thesis/FreshFolderForModifier/modifier_stuff180516/example_ppi.rds", refhook = NULL)
modifierInput <- MODifieRDev::create_input(exprMatrix, probeMap, indici1, indici2, label1, label2, T, T, T)
#modifierInput <- create_input(exprMatrix, probeMap, indici1, indici2, label1, label2)
write.csv(modifierInput$diff_genes, file = paste("tmpFilestorage/output","50b52162-5427-4876-96ed-f9c54beee1a2",".csv", sep=""))
#write.csv("Testing testing", file = paste("tmpFilestorage/output",args[7],".csv", sep=""))
#print(args[7])

######## Getting PPI network, local or download ###########
if(file.exists("network.txt")){
  network <- read.csv("network.txt", stringsAsFactors=FALSE, sep=" ")
}else{
  network <- MODifieRDev::get_string_DB_ppi()
}
network <- read.csv("network.txt", stringsAsFactors=FALSE, sep=" ")
networkDF <- data.frame(network)
#source("general_functions.R")
#library("STRINGdb")
#network <- MODifieRDev::get_string_DB_ppi()

args <- c("0", "1", "2", "3", "combo", "6")
args[5]

if(args[5]=="combo"){
  print("funkar????")
}
else{
  
}

####### Performing selected analysis ######################
if(args[5] == "diamond"){
	#source("R/diamond.R")
	diamond <- MODifieRDev::diamond(modifierInput, examplePpi)
	#print(diamond$module_genes)
	print("diamond output!")
} else if(args[5] == "cliqueSum"){
#	source("R/clique_sum.R")
	cliqueSum <- MODifieRDev::clique_sum(exampleInput, examplePpi)
	cliqueSum
	#print(cliqueSum)
	print("cliqueSum output!")
}else if(args[5] == "correlationClique"){
	#source("R/correlation_clique.R")
	correlationClique <- MODifieRDev::correlation_clique(exampleInput, examplePpi)
	#print(correlationClique)
	print("correlationClique output!")
}else if(args[5] == "diffCoEx"){
	#source("R/diffcoex.R")
	diffcoex <- MODifieRDev::diffcoex(exampleInput)
	#print(diffcoex)
	print("DiffCoEx output!")
}else if(args[5] == "dime"){
	#source("R/dime.R")
	dime <- MODifieRDev::dime(exampleInput)
	#print(dime)
	print("Dime output!")  
}else if(args[5] == "mcode"){
	#source("R/mcode.R")
	mcode <- MODifieRDev::mod_mcode(exampleInput, examplePpi)
	mglist<-list()
	for(i in 1:length(mcode)){
	  mg1 <- mcode[[i]]$module_genes
	  mg1<-mg1[1:1000]
	  mg1df <- data.frame(mg1)
	  colnames(mg1df) <- paste("Module", i, sep=" ")
	  mglist<-c(mglist, mg1df)
	}
	write.csv(mglist, file = paste("tmpFilestorage/output","TEST",".csv", sep=""),row.names=FALSE)
	
}else if(args[5] == "moda"){
	#source("R/moda.R")
	moda <- MODifieRDev::moda(exampleInput, "Density", 0.1, 0.1, "tmpFilestorage" )
	#print(moda)
	print("Moda output!")
}else if(args[5] == "moduleDiscoverer"){
  #source("R/modulediscoverer.R")
	modulediscoverer <- MODifieRDev:::modulediscoverer(exampleInput, examplePpi)
	#print(modulediscoverer)
	print("ModuleDiscoverer output!")
}

exampeDiamond <- examplePpi <- readRDS("C:/Users/emmae/Documents/Emmas/Bioinformatik/Master Thesis/FreshFolderForModifier/modifier_stuff180516/diamond_module.rds", refhook = NULL)
exampeCorrelationClique <- examplePpi <- readRDS("C:/Users/emmae/Documents/Emmas/Bioinformatik/Master Thesis/FreshFolderForModifier/modifier_stuff180516/correlation_module.rds", refhook = NULL)
exampecliqueSum <- examplePpi <- readRDS("C:/Users/emmae/Documents/Emmas/Bioinformatik/Master Thesis/FreshFolderForModifier/modifier_stuff180516/clique_module.rds", refhook = NULL)

modules <- list(exampeDiamond$module_genes, exampecliqueSum$module_genes, exampecliqueSum$module_genes)
moduleList <- list(exampecliqueSum, exampecliqueSum, exampeDiamond)
mcodeList <- c(mcode)
mcode[[1]]
class(mcode[[1]])
resultList <- MODifieRDev::get_module_list(mcode)
interssections <- MODifieRDev::get_intersections(mcode)
interssections
exampeDiamond$module_genes
write.csv(df, file = paste("tmpFilestorage/outputTEST",".csv", sep=""),row.names=FALSE)
df <- data.frame(exampeDiamond$module_genes)

mglist<-list()
for(i in 1:length(mcode)){
  mg1 <- mcode[[i]]$module_genes
  mg1<-mg1[1:1000]
  mg1df <- data.frame(mg1)
  colnames(mg1df) <- paste("Module", i, sep=" ")
  mglist<-c(mglist, mg1df)
}
write.csv(mglist, file = "tmpFilestorage/outputTEST.csv",row.names=FALSE)






####################################################################
####################################################################
#args = commandArgs(trailingOnly=TRUE)
#setwd(args[1])
#source("create_input.R")

resultList<-list()

cliquesumFile <-paste("tmpFilestorage/output","cliqueSum", args[2],".csv", sep="")
if(file.exists(cliquesumFile)){
  cliqueSumRes <- read.csv(cliquesumFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, cliqueSumRes)
}
correlationCliqueFile <-paste("tmpFilestorage/output","correlationClique", args[2],".csv", sep="")
if(file.exists(correlationCliqueFile)){
  correlationCliqueRes <- read.csv(correlationCliqueFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, correlationCliqueRes)
}
diamondFile <-paste("tmpFilestorage/output","diamond", args[2],".csv", sep="")
if(file.exists(diamondFile)){
  diamondRes <- read.csv(diamondFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, diamondRes)
}
diffCoExFile <-paste("tmpFilestorage/output","diffCoEx", args[2],".csv", sep="")
if(file.exists(diffCoExFile)){
  diffCoExRes <- read.csv(diffCoExFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, diffCoExRes)
}
dimeFile <-paste("tmpFilestorage/output","dime", args[2],".csv", sep="")
if(file.exists(dimeFile)){
  dimeRes <- read.csv(dimeFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, dimeRes)
}
mcodeFile <-paste("tmpFilestorage/output","mcode", "3a4133af-52ba-482a-9611-cc79998c1efa",".csv", sep="")
if(file.exists(mcodeFile)){
  mcodeRes <- read.csv(mcodeFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, mcodeRes)
}
modaFile <-paste("tmpFilestorage/output","moda", args[2],".csv", sep="")
if(file.exists(modaFile)){
  modaRes <- read.csv(modaFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, modaRes)
}
moduleDiscovererFile <-paste("tmpFilestorage/output","moduleDiscoverer", args[2],".csv", sep="")
if(file.exists(moduleDiscovererFile)){
  moduleDiscovererRes <- read.csv(moduleDiscovererFile, stringsAsFactors=FALSE, sep=",")
  resultList <- c(resultList, moduleDiscovererRes)
}
genes <- c("2288", "6376")
write.csv(genes, file = paste("tmpFilestorage/output","combo",".csv", sep=""), row.names=FALSE)

print("in beginning")

######################################################
get_intersections <- function(module_list){
  intersection_table <- table(unlist(sapply(X = module_list, FUN = function(x)x$module_genes)))
  intersections <- list()
  for (i in 1:length(module_list)){
    intersections[[i]] <- names(intersection_table[intersection_table > i])
  }
  names(intersections) <- paste("size", 1:length(module_list), "module", sep = "_")
  return(intersections)
}


