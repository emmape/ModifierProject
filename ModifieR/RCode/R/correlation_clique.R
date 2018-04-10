#' Clique_correlation
#'
#' A clique based method to find a disease module from correlated gene expression
#'
#'@param pval_matrix A nx2 dataframe of the entrez ids and their respective p-values
#'@param correlation_matrix A nxn matrix of Correlated p-values of n genes 
#'@param ppi_network A dataframe of PPI network of your choice
#'@param perturbation Number of iterations to be performed
#'@param cutoffRank Score cutoff of the string PPI network
#'@param cliquetestCriteria type of test to be perfomed for enrichment of cliques (default = "FisherTest")
#'@param probabailitySacleFactor Scale for enriched cliques 
#'@param frequency_cutoff Numeric significance out of number of iterations performed (default = 0.05) 
#' @return A MODifieR class object with disease module and settings
#'@export
correlation_clique <- function (pval_matrix, correlation_matrix, ppi_network,
                                frequency_cutoff = .5,cutOffRank = 700,
                                probabilityScaleFactor = 0.6,
                                pertubation = 10, cliqueTestCritera = "FisherTest"){

  # Retrieve settings
  default_args <- formals()
  user_args <- as.list(match.call(expand.dots = T)[-1])
  settings <- c(user_args, default_args[!names(default_args) %in% names(user_args)])

  springConnection <- springConnection[,1:3]

  ## Script
  probabilityMatrix <- SortDataForCliqueFunction(springConnection, pValueMatrix, corrPvalues, cutOffRank)
  pValueMatrix$V2 <- -log(pValueMatrix$V2)
  zeroRows_finder <- rowSums(probabilityMatrix , na.rm = T)

  zeroRows <- which(zeroRows_finder == 0)
  probabilityMatrix <- probabilityMatrix[!(rownames(probabilityMatrix) %in% names(zeroRows)) ,!(colnames(probabilityMatrix) %in% names(zeroRows))]

  pValueMatrix <- pValueMatrix[!(pValueMatrix$V1 %in% names(zeroRows)) ,]

  probabilityMatrix <- probabilityMatrix*probabilityScaleFactor


  allCliqueData <- list()
  allCliqueCellSignificant <- list()
  allTotalNumberOfChances <- list()
  rand_allCliqueData <- list()
  rand_allCliqueCellSignificant <- list()
  rand_allTotalNumberOfChances <- list()
  for (h in 1:pertubation){
    SigClique5_data <- SigCliqueFunction5(probabilityMatrix, pValueMatrix, cliqueTestCritera)
    allCliqueData[[h]] <- SigClique5_data[[1]]
    allCliqueCellSignificant[[h]] <- SigClique5_data[[2]]
    allTotalNumberOfChances[[h]] <- SigClique5_data[[3]]
  }

  tabled_frequencies <- table(unlist(allCliqueCellSignificant)) / pertubation

  module_genes <- names(tabled_frequencies[tabled_frequencies >= frequency_cutoff])

  new_correlation_clique_module <- list("module_genes" = module_genes,
                                        "settings" = settings)

  class( new_correlation_clique_module) <- c("MODifieR_module", "Correlation_clique")

  return( new_correlation_clique_module)
}


## Functions
SortDataForCliqueFunction <- function(springConnection, pValueMatrix, corrPvalues, cutOffRank){
  p1 <- corrPvalues
  colnames(p1) <- p1[1,]
  rownames(p1) <- p1[,1]
  pValueData <- pValueMatrix
  pValueData[,2] <- -log(pValueData[,2])
  overlap <- springConnection$V1 %in% pValueData$V1
  overlap_true <- which(overlap == TRUE)
  springConnection <- springConnection[overlap_true,]
  overlap <- springConnection$V2 %in% pValueData$V1
  overlap_true <- which(overlap == TRUE)
  springConnection <- springConnection[overlap_true,]

  #cutOffRank <- info_var$cutOffRank
  springConnection <- springConnection[which(springConnection$V3 > cutOffRank),]
  springConnection$V3 <- springConnection$V3/1000
  print("Creating matrix from list")
  networkMatrix = adjecentMatrixCreator(springConnection)
  #networkMatrix[1,1] <- 0
  p1 <- p1[-1 , -1]
  p2 <- as.data.frame(matrix(NA, ncol = length(p1), nrow = length(p1)))
  rownames(p2) <- rownames(p1)
  colnames(p2) <- colnames(p1)


  p2[rownames(networkMatrix) , colnames(networkMatrix)] <- networkMatrix

  probabilityMatrix = sqrt(p1*p2)

  return(probabilityMatrix)
}
adjecentMatrixCreator <- function(springConnection){
  springConnection <- springConnection[with(springConnection, order(springConnection[,2])),]
  springConnection <- springConnection[with(springConnection, order(springConnection[,1])),]
  g <- igraph::graph.data.frame(springConnection)
  networkMatrix <- igraph::get.adjacency(g , attr = "V3")
  networkMatrix <- as.data.frame(as.matrix(networkMatrix))
}
maximalCliques2 <- function(networkMatrix){

  rownames(networkMatrix) <- 1:length(networkMatrix)
  colnames(networkMatrix) <- 1:length(networkMatrix)

  for (i in 2:length(networkMatrix)){
    networkMatrix[i,2:i] <- 0
  }

  z <- igraph::graph.adjacency(as.matrix(networkMatrix[-1,-1]))
  z1 <- igraph::simplify(z)
  z2 <- igraph::maximal.cliques(z1)

  cliques <- list()
  cliques_len <- c()
  for (i in 1:length(z2)){
    cliques[[i]] <- as.numeric(rownames(as.matrix(unlist(z2[[i]]))))
  }

  return(cliques)

}
CreateBackGround_pvalues <- function(clique_distribtuion,pValueMatrix,bootstrapValue,sig_value){
  clique_dist_wide <- dim(clique_distribtuion)
  tmp_pval <- matrix(0,bootstrapValue,clique_dist_wide[1])

  for (i in 1:bootstrapValue){
    for (j in 1:clique_dist_wide[1]){
      tmp <- sample(pValueMatrix[,2], clique_distribtuion[j,1])
      tmp_pval[i,clique_dist_wide[1]-j+1] <- mean(tmp)
    }
  }
  backGround_pValue <- tmp_pval
  numberOfHigher <- bootstrapValue * sig_value

  pValueToBeat <- c()
  for (i in 1:clique_dist_wide[1]){
    backGround_pValue[,i] <- sort(backGround_pValue[,i], decreasing = TRUE)
    #pValueToBeat[i] <- backGround_pValue[numberOfHigher,i]
  }

  return(apply(t(backGround_pValue),2,rev))
}
SigCliqueFunction5 <- function(probabilityMatrix, pValueMatrix, cliqueTestCritera){

  len <- length(probabilityMatrix)-1
  randomMatrix <- matrix(runif(len*len), len, len)
  randomMatrix <- as.data.frame((randomMatrix + t(randomMatrix))/2)


  networkMatrix = as.data.frame(matrix(0, ncol = length(probabilityMatrix), nrow = length(probabilityMatrix)))
  networkMatrix[,1] <- probabilityMatrix[,1]
  networkMatrix[1,] <- probabilityMatrix[1,]

  networkMatrix[-1,-1] <- (probabilityMatrix[-1,-1] > randomMatrix)*1

  numberOfChances <- as.data.frame(matrix(0, nrow = length(randomMatrix), ncol = 3))
  numberOfChances[,1] <- as.numeric(networkMatrix[1,-1])
  interaction_counter <- c()
  for (i in 1:length(networkMatrix)-1){
    interaction_counter[i] <- sum(networkMatrix[i+1,-1])
  }
  numberOfChances[,2] <- interaction_counter
  numberOfChances[,3][which(numberOfChances[,2] > 0)] <- 1

  zeroRows2 <- which(numberOfChances[,3] < 1)
  numberOfChances <- numberOfChances[-c(zeroRows2),]
  networkMatrix <- networkMatrix[-c(zeroRows2),]
  networkMatrix <- networkMatrix[,-c(zeroRows2)]

  MC <- maximalCliques2(networkMatrix)
  clique_distribtuion <- as.data.frame(matrix(0, nrow = length(networkMatrix), ncol = 2))
  clique_distribtuion$V1 <- c(1:length(networkMatrix))

  counter <- 1
  cliqueCell <- list()
  for (j in 1:length(MC)){
    clique <- MC[[j]]
    clique_len <- length(clique)
    clique_distribtuion[clique_len,2] <- clique_distribtuion[clique_len,2]+1
    if (clique_len > 2){
      cliqueCell$clique[[counter]] <- networkMatrix[c(clique),1]
      cliqueCell$pVal[[counter]] <- sum(pValueMatrix[which(pValueMatrix$V1 %in% c(networkMatrix[c(clique),1]) == TRUE),2])/clique_len
      counter <- counter + 1
    }
  }
  clique_dist_pos <- which(clique_distribtuion$V2 >0)
  clique_dist_pos <- tail(clique_dist_pos, n=1)
  clique_distribtuion <- clique_distribtuion[1:clique_dist_pos,]

  ## Create background p-Values and sort p-Values
  bootstrapValue <- 10000


  backGround_pValue <- CreateBackGround_pvalues(clique_distribtuion, pValueMatrix, bootstrapValue, 0.01)

  cliqueCell[[3]] <- 0
  cliqueCell[[4]] <- 0
  for (k in 1:length(cliqueCell[[1]])){
    aveX <- cliqueCell[[2]][k]
    yrand <- backGround_pValue[length(cliqueCell[[1]][[k]])-1,]
    nrand <- 10000

    p <- length(which(yrand > aveX))/length(yrand)
    z <- (aveX - mean(yrand))/sd(yrand)
    or <- aveX / mean(yrand)

    if ( p < 10/nrand){
      p <- one.sample.z(data = z, null.mu = 0, sigma = 1, "upper.tail")
    }

    cliqueCell[[3]][k] <- p
    cliqueCell[[4]][k] <- 0


  }

  Q <- fdrtool::fdrtool(cliqueCell[[3]], statistic = "pvalue", plot = FALSE, cutoff.method = "fndr")
  for (p in 1:length(Q)){
    cliqueCell[[4]][p] <- Q$qval[p]
  }
  cliqueCell[[5]] <- 0
  for(j in 1:length(cliqueCell$clique)){
    clique <- unlist(cliqueCell$clique[j])
    clique_pvals <- pValueMatrix[which(pValueMatrix[,1] %in% clique == TRUE),2]

    a <- sum(clique_pvals > -log(0.05))
    b <- sum(clique_pvals < -log(0.05))
    c <- sum(pValueMatrix[which(!(pValueMatrix[,1] %in% clique) == TRUE),2] > -log(0.05))
    d <- sum(pValueMatrix[which(!(pValueMatrix[,1] %in% clique) == TRUE),2] < -log(0.05))

    fisher_input <- matrix(c(a,b,c,d), ncol=2)
    fisher_result <- fisher.test(fisher_input, alternative = "greater")
    cliqueCell[[5]][j] <- fisher_result$p.value
  }
  significant_cliques <- which(cliqueCell[[5]] < 0.01)

  cliqueCellSignificant <- matrix(list(), nrow = 5, ncol = length(significant_cliques))
  if (length(significant_cliques) == 0){
    cliqueCellSignificant <- 0
  } else {
    for (j in 1:length(significant_cliques)){
      for (l in 1:5){
        cliqueCellSignificant[[l,j]] <- cliqueCell[[l]][significant_cliques[j]]
      }
    }
  }

  networkMatrixNoIDs <- networkMatrix
  rownames(networkMatrixNoIDs) <- NULL
  colnames(networkMatrixNoIDs) <- 1:length(networkMatrixNoIDs)
  edgeListAfterRandom <- which(networkMatrixNoIDs == 1, arr.ind = T)


  return(list(edgeListAfterRandom, cliqueCellSignificant, numberOfChances))

}
