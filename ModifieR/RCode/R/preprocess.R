read_rma_matrix <- function(group1, group2, dataDir){
  #invisible(sapply(X = c(group1,group2),FUN = get_geo_files, dataDir=dataDir))
  #sapply(X = list.files(dataDir, full.names = T), FUN = GEOquery::gunzip)
  cel_batch <- oligo::read.celfiles(filenames = list.files(dataDir, full.names = T, pattern = ".CEL"))
  raw_eset <- rma(cel_batch)
  exprs_mat <- exprs(raw_eset)
  return (exprs_mat)
}

get_geo_files <- function(geo_accession, dataDir){
  result <- NULL
  attempt <- 1
  while(is.null(result) && attempt <= 10){
    attempt <- attempt +1
    result <- try(GEOquery::getGEOSuppFiles(GEO = geo_accession,
                                            baseDir = dataDir,
                                            makeDirectory =  F))
    if (class(result) == "try-error"){
      Sys.sleep(30)
      result <- NULL
    }
  }
}
get_processed_geo <- function(geo_accession, dataDir){

  geo_file <- GEOquery::getGEO(GEO = geo_accession, destdir = dataDir, getGPL = F)
  return(geo_file@dataTable@table)
}
group_and_subset <- function(group1, group2, exprs_mat, groupnames){
  group1_indici <- get_exprs_group_indici(group = group1, exprs = exprs_mat, groupname = groupnames[1])
  group2_indici <- get_exprs_group_indici(group = group2, exprs = exprs_mat, groupname = groupnames[2])
  exprs_mat <- subset_exprs(exprs = exprs_mat, group1 = group1_indici, group2 = group2_indici)
}

get_exprs_group_indici <- function(group, exprs, groupname){
  indici <- sapply(X = group, FUN = function(x){grep(pattern = x, x = colnames(exprs))})
  names(indici) <- paste0(groupname, "_" , 1:length(group))
  return(indici)
}

subset_exprs <- function(exprs, group1, group2){
  for(i in 1:length(group1)){
    colnames(exprs)[group1[i]] <- names(group1)[i]
  }
  for(i in 1:length(group2)){
    colnames(exprs)[group2[i]] <- names(group2)[i]
  }
  exprs <- exprs[ ,c(group1, group2)]
  return (exprs)
}

get_gpl <- function(geo_accession, baseDir){

  gpl_accession <- retrieve_geo_gpl(geo_accession = geo_accession)
  gpl <- getGEO(gpl_accession, destdir = baseDir)

  return(gpl)
}

collapse_probes <- function(entrez, exprs_mat, probe_entrez_mat){
  sapply(X = 1:ncol(exprs_mat),
         FUN = function(x){mean(exprs_mat[probe_entrez_mat[which(probe_entrez_mat$ENTREZID == entrez),1], x])})
}

probe_entrez_mapping <- function(gpl, probes){

  annotation_file <-(as.character(as.vector(Table(gpl)[,"ENTREZ_GENE_ID"])))
  names(annotation_file) <- Table(gpl)[,"ID"]

  annotation_file <- annotation_file[probes]

  all_entrez <- strsplit(annotation_file, split = " /// ")

  probe_entrez_mat <- as.matrix(plyr::ldply (all_entrez, matrix))

  return (probe_entrez_mat)

}
#
geo_rawdata_matrix <- function(baseDir, group1, group2){
  complete_matrix <- read_rma_matrix(group1 = group1, group2 = group2, dataDir = baseDir)
  exprs_mat <- group_and_subset(group1 = group1, group2 = group2, exprs_mat = complete_matrix,
                                groupnames = c(deparse(substitute(group1)), deparse(substitute(group2))))
  return(exprs_mat)
}
#Main function. Arguments:
#Expression matrix: Normalized expression matrix
#probe map: dataframe, 3 columns. 1.probe id, 2. gene symbol, 3. entrez id
#group_indici: indici for different groups
#expression: boolean, calculate expression values
#diff_data: boolean, calculate differentially expressed data
#data_dir, folder where diamond_genes text files will be stored
probe_to_entrez <- function (expression_matrix, probe_map, group1_indici, group2_indici,
                             expression = F, diff_data = F, correlation_clique = F, data_dir = getwd()){
  diff_genes <- NULL
  collapsed_exprs_mat <- NULL
  diamond_genes_file <- NULL
  correlation_p_values <- NULL
  correlation_matrix <- NULL

  colnames(probe_map) <- c("PROBEID", "SYMBOL", "ENTREZID")
  print(colnames(probe_map))
  #group1_name <- deparse(substitute(group1))
  #group2_name <- deparse(substitute(group2))
  group_indici <- list("group_1_indici" = group1_indici,
                       "group_2_indici" = group2_indici)
  if (expression == T || correlation_clique == T){
    collapsed_exprs_mat <- sapply(X = unique(probe_map$ENTREZID), FUN = collapse_probes,
                                  exprs_mat = expression_matrix, probe_entrez_mat = probe_map)

    collapsed_exprs_mat <- t(collapsed_exprs_mat)
    colnames(collapsed_exprs_mat) <- colnames(expression_matrix)

  }
  if (diff_data == T || correlation_clique == T){
    group_factor <<- create_group_factor(samples = colnames(expression_matrix),
                                        group1_indici = group1_indici,
                                        group2_indici = group2_indici)

    diff_genes_data <<- differential_expression(group_factor = group_factor,
                                               expression_matrix = expression_matrix,
                                               probe_table = probe_map)
    if (diff_data == T){
    diff_genes <- data.frame(gene = diff_genes_data$SYMBOL ,
                             LogP = -log10(diff_genes_data$P.Value),
                             stringsAsFactors = FALSE)
    diff_genes <- na.omit(diff_genes)
    diamond_genes <- diff_genes_data[diff_genes_data$P.Value < 0.05, ]
    diamond_genes <- na.omit(diamond_genes)
    diamond_genes_file <- paste(data_dir, "Diamondgenes.txt", sep = "/")
    write.table(diamond_genes$ENTREZID , diamond_genes_file, sep = "\t" ,
                row.names = FALSE , quote = FALSE, col.names = F)
    }

  if (correlation_clique == T){
    p_values <- correlation_pval(pvalues = diff_genes_data[c(9,4)])
    correlation_matrix <- lapply(qpgraph::qpPCC(t(collapsed_exprs_mat)), round, digits=3)$P
  }
}
modifier_input <- list("diff_genes" = diff_genes,
                       "annotated_exprs_matrix" = collapsed_exprs_mat,
                       "diamond_genes_file" = diamond_genes_file,
                       "correlation_p_values" = correlation_p_values,
                       "correlation_matrix" = correlation_matrix,
                       "annotation_table" = probe_map,
                       "group_indici" = group_indici)
class(modifier_input) <- c("MODifieR_input", "Expression")
return (modifier_input)
}
#Calculate differentially expressed genes
differential_expression <- function(group_factor, expression_matrix, probe_table){
  design <- model.matrix(~group_factor)
  fit <- limma::lmFit(expression_matrix, design)
  fit2 <- limma::eBayes(fit)
  diff_genes <<- limma::topTable(fit = fit2,  number = Inf, adjust.method = "BH")
  annotated_probes <<- lapply(X = rownames(diff_genes), FUN = annotate_probe,
                             diff_genes = diff_genes, probe_table = probe_table)
  annotated_probes <<- do.call("rbind", annotated_probes)
  rownames(annotated_probes) <- NULL
  return (annotated_probes)
}
#Helper function for differential expression, adds annotation to probes
annotate_probe <- function(probe_id, diff_genes, probe_table){
  cbind(diff_genes[probe_id, ], probe_table[probe_table$PROBEID == probe_id, ])
}
#Helper function for differential expression, creates group factor
create_group_factor <- function(samples, group1_indici, group2_indici){
  pre_factor <- samples
  pre_factor <- replace(x = pre_factor, list = group1_indici, values = "group1")
  pre_factor <- replace(x = pre_factor, list = group2_indici, values = "group2")
  group_factor<- as.factor(pre_factor)
  return(group_factor)
}
#Helper function for correlation clique
correlation_pval <- function(pvalues){
  test <<- pvalues
  plyr::ddply(.data = pvalues, .variables = colnames(pvalues)[1], .fun = plyr::summarise, P.Value = min(P.Value))
}
#Deprecated
preprocess <- function(geo_accession, baseDir, group1, group2){
  gpl_file <- get_gpl(geo_accession = geo_accession, baseDir = baseDir)
  probe_entrez_map <- probe_entrez_mapping(gpl = gpl_file, probes = rownames(exprs_mat))




  return(collapsed_exprs_mat)
}
#
#select(hgu133a2.db, rownames(expression_matrix), c("SYMBOL","ENTREZID"))
#

