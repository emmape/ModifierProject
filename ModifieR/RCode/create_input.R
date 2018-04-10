#Main function. Creates an object of class "MODifieR input" that can be used
#in downstream analysis using the disease module inference methods included
#in the MODifieR package.
#
#Input arguments:
#expression_matrix: Normalized expression matrix. samples as columns and probes as rows
#probe map: A dataframe providing annotation for the probes.
  #The dataframe should have 3 columns:
    #Column 1. probe id as it is in the expression matrix
    #Column 2. gene symbol (if available) associated with the probe
    #Column 3. entrez id (if available associated with the probe)
#group_indici: indici for different groups
#expression: boolean, calculate expression values
#diff_data: boolean, calculate differentially expressed data
#data_dir, folder where diamond_genes files will be stored
create_input <- function (expression_matrix, probe_map, group1_indici, group2_indici,
                             expression = T, diff_data = T, correlation_clique = F, data_dir = getwd()){
  #Initialize outputs
  diff_genes <- NULL
  collapsed_exprs_mat <- NULL
  diamond_genes_file <- NULL
  correlation_p_values <- NULL
  correlation_matrix <- NULL
  group_indici <- list("group_1_indici" = group1_indici,
                       "group_2_indici" = group2_indici)

  #Making sure column names for the annotation dataframe are right...
  colnames(probe_map) <- c("PROBEID", "SYMBOL", "ENTREZID")

  #Should expression data be generated? Note that expression data is precursor
  #for correlation method data
  if (expression == T || correlation_clique == T){
    collapsed_exprs_mat <- sapply(X = unique(probe_map$ENTREZID), FUN = collapse_probes,
                                  exprs_mat = expression_matrix, probe_entrez_mat = probe_map)

    collapsed_exprs_mat <- t(collapsed_exprs_mat)
    colnames(collapsed_exprs_mat) <- colnames(expression_matrix)

  }
  #Same for expression data, which is also a precursor to correlation data.
  if (diff_data == T || correlation_clique == T){
    group_factor <- create_group_factor(samples = colnames(expression_matrix),
                                         group1_indici = group1_indici,
                                         group2_indici = group2_indici)

    diff_genes_data <- differential_expression(group_factor = group_factor,
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
  diff_genes <- limma::topTable(fit = fit2,  number = Inf, adjust.method = "BH")
  annotated_probes <- lapply(X = rownames(diff_genes), FUN = annotate_probe,
                              diff_genes = diff_genes, probe_table = probe_table)
  annotated_probes <- do.call("rbind", annotated_probes)
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
  test <- pvalues
  plyr::ddply(.data = pvalues, .variables = colnames(pvalues)[1], .fun = plyr::summarise, P.Value = min(P.Value))
}
#Collapse probes that target same gene and get mean expression value.
collapse_probes <- function(entrez, exprs_mat, probe_entrez_mat){
  sapply(X = 1:ncol(exprs_mat),
         FUN = function(x){mean(exprs_mat[probe_entrez_mat[which(probe_entrez_mat$ENTREZID == entrez),1], x])})
}
