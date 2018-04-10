#' DIAMOnD module
#' 
#' A seed gene based algorithm to identify disease module from Differentially Expressed Genes
#' 
#' @param network path to the desired background network 
#' @param input_genes path to the tab delimited file consisting of seed genes 
#' @param n_output_genes maximum number of genes to be included in the final module 
#' @param seed_weight Numeric additional parameter to assign weight for the seed genes 
#' @param include_seed Logical TRUE/FALSE for inclusion of seed genes in the output module 
#' @return A disease module  
#' @export
diamond <- function(network, input_genes, n_output_genes = 200, seed_weight = 1,
                    include_seed = T){
  # Retrieve settings
  default_args <- formals()
  user_args <- as.list(match.call(expand.dots = T)[-1])
  settings <- c(user_args, default_args[!names(default_args) %in% names(user_args)])

  # Sets python path
  python_path <- paste(system.file(package="MODifieR"), "DIAMOnD_MODifieR.py", sep="/")
  # Concetenates python call with CL arguments
  python_call <- paste("python", python_path, network, input_genes,
                       n_output_genes, seed_weight, sep = " ")
  # Gets output from python script as character vector
  raw_module <- system(command = python_call, intern = T)
  # Python scripts returns concatented ouput delimited by ",", split it
  split_module <- sapply(X = raw_module, FUN = split_values)
  # Include seed genes used?
  if (include_seed == T){
    module_genes <- c(split_module[[2]], split_module[[3]])
  } else{
    module_genes <- split_module[[3]]
  }
  # Build new MODifieR object
  new_diamond_module <- list("module_genes" = module_genes,
                             "seed_genes" =  split_module[[2]],
                             "ignored_genes" = split_module[[1]],
                             "added_genes" = as.data.frame(x = (split_module[3:6]),
                                                           row.names = 1:length(split_module[[3]]),
                                                           col.names =      c("Gene",
                                                                              "Degree",
                                                                              "Connectivity",
                                                                              "p-value"),
                                                           stringsAsFactors = F),
                             "settings" = settings)

  class(new_diamond_module) <- c("MODifieR_module", "DIAMOnD")

  return(new_diamond_module)
}
# Splits character vector on ","
split_values <- function(values){
  values <- gsub(pattern = " ", replacement = "", x = values)
  strsplit(x = values, split = ",")
}
