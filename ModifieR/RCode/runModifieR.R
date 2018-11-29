args = commandArgs(trailingOnly=TRUE)
setwd(args[6])

print("Starting")
if(args[5] == "combo"){
  resultsFound <- 0
  moduleList <- ""
  if(file.exists(paste("tmpFilestorage/outputdiamond",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputdiamond",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputcliqueSum",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputcliqueSum",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputcorrelationClique",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputcorrelationClique",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputdiffCoEx",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputdiffCoEx",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    for(col in 1:(ncol(content))){
      moduleList<-c(moduleList, content[,col])
      resultsFound <- resultsFound+1
    }
    moduleList <- moduleList[!is.na(moduleList)]
  }  
  if(file.exists(paste("tmpFilestorage/outputdime",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputdime",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputmoda",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputmoda",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputmoduleDiscoverer",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputmoduleDiscoverer",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    moduleList<-c(moduleList, content[,ncol(content)])
    resultsFound <- resultsFound+1
  }  
  if(file.exists(paste("tmpFilestorage/outputmcode",args[7],".csv", sep=""))){
    content <- read.csv(paste("tmpFilestorage/outputmcode",args[7],".csv", sep=""), header = TRUE, sep = ",", quote = "\"",
                        dec = ".", fill = TRUE)
    for(col in 2:(ncol(content))){
      moduleList<-c(moduleList, content[,col])
      resultsFound <- resultsFound+1
    }
    moduleList <- moduleList[!is.na(moduleList)]
  }
  
  n_occur <- data.frame(table(moduleList))
  multipleOccurances <- ""
  foundInNumberOfModules<-0
  for(numModule in 1:resultsFound){
    if(length(n_occur[n_occur$Freq > numModule,]$moduleList)>4){
      foundInNumberOfModules<-numModule+1
      multipleOccurances <- n_occur[n_occur$Freq > numModule,]$moduleList
    }
  }
  multipleOccurances <- data.frame(multipleOccurances)
  colnames(multipleOccurances)<- paste("Genes found in at least ", foundInNumberOfModules, " modules", sep="")
  write.csv(multipleOccurances, file = paste("tmpFilestorage/output","combo", args[7],".csv", sep=""), row.names=FALSE)
  
}else {
  
  ######## Formatting input #####################
  exprMatrix <- read.csv(paste("tmpFilestorage/expressionMatrix",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
  probeMap <- read.csv(paste("tmpFilestorage/probeMap",args[7],".txt", sep=""), sep=" ")
  probeMap <- data.frame(probeMap)
  indici1 <- as.integer(strsplit(args[1],";")[[1]])
  indici2 <- as.integer(strsplit(args[2],";")[[1]])
  label1 <- args[3]
  label2 <- args[4]
  
  print("Read Input")
  
  ####### Creating a modifierInput object ###############
  
  modifierInput <- MODifieRDev::create_input(
    expression_matrix=exprMatrix, 
    annotation_table=probeMap, 
    group1_indici=indici1, 
    group2_indici=indici2, 
    group1_label=label1, 
    group2_label=label2)
  print("Created Modifier:input_object")
  
  ######## Getting PPI network, local or download ###########
  
  if(file.exists(paste("tmpFilestorage/network",args[7],".txt", sep=""))){
    
    network <- read.csv(paste("tmpFilestorage/network",args[7],".txt", sep=""), stringsAsFactors=FALSE, sep=" ")
    print("Using Existing network")
    
  }else{
    
    network <- MODifieRDev::ppi_network
    print("Using String PPI")
    
  }
  
  ####### Performing selected analysis ######################
  if(args[5] == "diamond"){
    print("Starting diamond")
    diamond <- MODifieRDev::diamond(
      MODifieR_input=modifierInput, 
      ppi_network=network)
    write.csv(diamond$module_genes, file = paste("tmpFilestorage/outputdiamond",args[7],".csv", sep=""))
    print("Done with diamond")
    
  } else if(args[5] == "cliqueSum"){
    print("Starting cliquesum")
    cliqueSum <- MODifieRDev::clique_sum(
      MODifieR_input=modifierInput, 
      ppi_network=network)
    write.csv(cliqueSum$module_genes, file = paste("tmpFilestorage/outputcliqueSum",args[7],".csv", sep=""))
    print("Done with cliqueSum")
    
  }else if(args[5] == "correlationClique"){
    print("Starting correlation clique")
    correlationClique <- MODifieRDev::correlation_clique(
      MODifieR_input=modifierInput, 
      ppi_network=network)
    write.csv(correlationClique$module_genes, file = paste("tmpFilestorage/outputcorrelationClique",args[7],".csv", sep=""))
    print("Done with correlation clique")
    
  }else if(args[5] == "diffCoEx"){
    print("Starting diffcoex")
    diffcoex <- MODifieRDev::diffcoex(
      MODifieR_input=modifierInput)
    diffcoexdf <- data.frame(1:50)
    for(diffcoexmodule in diffcoex){
      dcem <- diffcoexmodule$module_genes
      if(length(dcem)<50){
        m[seq(length(m)+1,50)] <- ""
        diffcoexdf <- data.frame(diffcoexdf, dcem)
      }
    }
    diffcoexdf$X1.50=NULL
    write.csv(diffcoexdf, file = paste("tmpFilestorage/outputdiffCoEx",args[7],".csv", sep=""))
    print("Done with diffcoex")
    
  }else if(args[5] == "dime"){
    print("Starting dime")
    dime <- MODifieRDev::dime(modifierInput)
    write.csv(dime$module_genes, file = paste("tmpFilestorage/outputdime",args[7],".csv", sep=""))
    print("Done with dime")
    
  }else if(args[5] == "mcode"){
    print("Starting mcode")
    mcode <- MODifieRDev::mod_mcode(
      MODifieR_input=modifierInput, 
      ppi_network=network)
    moduledf <- data.frame(1:50)
    for(module in mcode){
      m <- module$module_genes
      if(length(m)<50){
        m[seq(length(m)+1,50)] <- ""
        moduledf <- data.frame(moduledf, m)
      }
    }
    moduledf$X1.50=NULL
    write.csv(moduledf, file = paste("tmpFilestorage/outputmcode",args[7],".csv", sep=""))
    print("Done with mcode")
    
  }else if(args[5] == "moda"){
    print("Starting moda")
    moda <- MODifieRDev::moda(
      MODifieR_input = modifierInput,
      group_of_interest=2)
    write.csv(moda$module_genes, file = paste("tmpFilestorage/outputmoda",args[7],".csv", sep=""))
    print("Done with moda")
    
  }else if(args[5] == "moduleDiscoverer"){
    print("Starting moduleDiscoverer")
    modulediscoverer <- MODifieRDev::modulediscoverer(
      MODifieR_input=modifierInput, 
      ppi_network=network)
    write.csv(modulediscoverer$module_genes, file = paste("tmpFilestorage/outputmoduleDiscoverer",args[7],".csv", sep=""))
    print("Done with moduleDiscoverer")
    
  }
  
}
