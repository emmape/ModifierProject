dime <- function(exprs){

  nfeat <- dim(exprs)[1]
  nsamples <- dim(exprs)[2]
  exprs <- t(exprs)

  cor.data <- cor.jack(exprs)

  upper.r <- as.vector(cor.data[upper.tri(cor.data)])
  upper.ind <- which(upper.tri(cor.data))
  sorted.r <- sort((upper.r), index.return = TRUE)
  nedges <- floor(length(upper.r)*0.001)
  nedges.upper <- floor(0.5*nedges)
  nedges.lower <- nedges - nedges.upper
  selected.ind <- c(upper.ind[sorted.r$ix[1:nedges.lower]],
                    upper.ind[sorted.r$ix[(length(upper.r)-nedges.upper+1):length(upper.r)]])

  # Now connect these correlation pairs to form an adjacency matrix for the network,
  # and delete isolated nodes (genes with no selected coexpression partners)
  adj <- matrix(0, nfeat, nfeat)
  rownames(adj) <- as.character(rownames(cor.data))
  colnames(adj) <- as.character(colnames(cor.data))
  adj[selected.ind] <- 1
  ind <- lower.tri(adj)
  adj[ind] <- t(adj)[ind]
  toDel <- unname(which(rowSums(adj) == 0))
  adj <- adj[-toDel,-toDel]


  g <- igraph::graph.adjacency(adj,mode = "undirected")
  edges <- igraph::get.edgelist(g)

  edges <- cbind(as.character(edges[,1]), as.character(edges[,2]))
  g <- igraph::graph.edgelist(as.matrix(edges), directed = FALSE)
  IDs <- igraph::V(g)$name
  inds <- c(1:length(igraph::V(g)))
  igraph::V(g)$name <- as.character(c(1:length(igraph::V(g))))
  edgelist <- igraph::get.edgelist(g)
  edgelist <- data.frame(as.character(edgelist[,1]), as.character(edgelist[,2]))

  nRuns <- 50 # Number of extraction trials to be done for each community
  Bscores <- c()
  Wscores <- c()
  bestCommunities <- list()
  level <- 0


  while (level <= 1) {
    level <- level + 1
    currentBest <- rep(0,length(igraph::V(g)))
    # Running in verbose mode
    writeLines(paste("Now extracting community ",as.character(level),"...",sep=""))
    adj <- igraph::get.adjacency(g)
    dimVg = length(igraph::V(g))
    #resdata <- data.frame(res = currentBest)
    #scorelist <- data.frame(score= c(0))


    #registerDoSNOW(cluster)

    currentBest <- GoParallel(nRuns, dimVg, adj, currentBest)
    #currentBest <- NotParallel(nRuns, dimVg, adj, currentBest)



    wbest <- W.score(adj, currentBest)

    cat("\n")
    if(sum(currentBest) > 2) {
      bestCommunities[[level]] <- as.numeric(V(g)$name[currentBest!=0])
      Wscores[level] <- wbest
    } else {
      cat("\n...No feasible community can be extracted any more. Extraction done.\n")
      break
    }
    g <- delete.vertices(g,igraph::V(g)[currentBest!=0])
  }

}


GoParallel <- function(nRuns, dimVg, adj, currentBest) {

  cluster = makeCluster(1)
  doParallel::registerDoParallel(cluster)


  communityExtraction <- function(dimVg, popsize, adj, verbose){
   res <- commextr(d = as.integer(50),
                      ps = as.integer(50), x = as.matrix(adj),
                      rest = as.integer(0),
                      vb = as.integer(1))
    return(res)
  }



  oper <- foreach(i=1:nRuns) %dopar% {
    communityExtraction(dimVg = 50,
                        popsize = 50,
                        adj = adj,
                        verbose=0)

  }

  stopCluster(cluster)

  for (i in 1:nRuns) {
    res <- oper[[i]]
    if (W.score(adj,res) > W.score(adj,currentBest)) {
      currentBest <- res
    }

  }

  return(currentBest)

}


NotParallel <- function(nRuns, dimVg, adj, currentBest) {
  for (i in 1:nRuns) {
    res <- communityExtraction(dimVg = dimVg,
                               popsize = 50,
                               adj = adj,
                               verbose=0)
    if (W.score(adj,res) > W.score(adj,currentBest)) {
      currentBest <- res
    }
    cat(".")
  }
  return(currentBest)
}


