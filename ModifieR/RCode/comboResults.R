args = commandArgs(trailingOnly=TRUE)
setwd(args[1])

print("in beginning")
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
mcodeFile <-paste("tmpFilestorage/output","mcode", args[2],".csv", sep="")
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
print("before print")
write.csv("TEST!!!", file = paste("tmpFilestorage/output","combo", args[2],".csv", sep=""))


