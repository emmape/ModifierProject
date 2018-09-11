#args = c("1;2;3;4;5;6;7;8;9;10;11;12;13;14;15", "16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33", "Group1", "Group2", "diamond", "C:/Users/emmae/Programmering/ModifieR/ModifierFrontAndBackend/ModifierProject/ModifieR/RCode", "7764206c-6837-496b-ab9e-b08309f60e2e")
args = commandArgs(trailingOnly=TRUE)
setwd(args[6])

if(args[5] == "combo"){
  genes <- c("2288", "6376")
  write.csv(genes, file = paste("tmpFilestorage/output","combo", args[7],".csv", sep=""), row.names=FALSE)
}else {
  
  ######## Formatting input #####################
  exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
  probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
  probeMap <- data.frame(probeMap)
  indici1 <- as.integer(strsplit(args[1],";")[[1]])
  indici2 <- as.integer(strsplit(args[2],";")[[1]])
  label1 <- args[3]
  label2 <- args[4]

  ####### Creating a modifierInput object ###############
  
  modifierInput <- MODifieRDev::create_input(exprMatrix, probeMap, indici1, indici2, label1, label2, T, T, T)

  ######## Getting PPI network, local or download ###########
  if(file.exists(paste("tmpFilestorage/network",args[7],".txt", sep=""))){
    network <- read.csv(paste("tmpFilestorage/network",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
  }else{
    library(STRINGdb)
    network <- MODifieRDev::get_string_DB_ppi(10, 900, T)
    library(igraph)
    dfNetwork <- as_long_data_frame(network)
  }
  
  ####### Performing selected analysis ######################
  if(args[5] == "diamond"){
    diamond <- MODifieRDev::diamond(modifierInput, dfNetwork)
    write.csv(diamond$module_genes, file = paste("tmpFilestorage/outputdiamond",args[7],".csv", sep=""))
    
  } else if(args[5] == "cliqueSum"){
    cliqueSum <- MODifieRDev::clique_sum(modifierInput, dfNetwork)
    write.csv(cliqueSum$module_genes, file = paste("tmpFilestorage/outputcliquesum",args[7],".csv", sep=""))
    
  }else if(args[5] == "correlationClique"){
    correlationClique <- MODifieRDev::correlation_clique(modifierInput, dfNetwork)
    write.csv(correlationClique$module_genes, file = paste("tmpFilestorage/outputcorrelationClique",args[7],".csv", sep=""))
    
  }else if(args[5] == "diffCoEx"){
    diffcoex <- MODifieRDev::diffcoex(modifierInput)
    write.csv(diffcoex$module_genes, file = paste("tmpFilestorage/outputdiffCoEx",args[7],".csv", sep=""))
    
  }else if(args[5] == "dime"){
    dime <- MODifieRDev::dime(modifierInput)
    write.csv(dime$module_genes, file = paste("tmpFilestorage/outputdime",args[7],".csv", sep=""))
    
  }else if(args[5] == "mcode"){
    mcode <- MODifieRDev::mod_mcode(modifierInput, dfNetwork)
    write.csv(mcode$module_genes, file = paste("tmpFilestorage/outputmcode",args[7],".csv", sep=""))

  }else if(args[5] == "moda"){
    moda <- MODifieRDev::moda(modifierInput, "Density", 0.1, 0.1, "tmpFilestorage" )
    write.csv(moda$module_genes, file = paste("tmpFilestorage/outputmoda",args[7],".csv", sep=""))

  }else if(args[5] == "moduleDiscoverer"){
    modulediscoverer <- MODifieRDev::modulediscoverer(modifierInput, dfNetwork)
    write.csv(modulediscoverer$module_genes, file = paste("tmpFilestorage/outputmoduleDiscoverer",args[7],".csv", sep=""))

  }
  
}
