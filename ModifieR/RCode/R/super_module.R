#' Robust module concensus
#'
#'A final conglomeration of all modules identified by different module methods to produce all kinds of intersect modules
#'
#' @param module_list A list object with f´genes of each module
#' @param include_single_methods A boolean value , whether to include the original modules in the final result  
#' @export
super_module <- function(module_list, include_single_methods = T){
  all_modules <-  sapply(X = module_list, FUN = extract_module_data,
                        data_field = "module_genes" )

  names(all_modules) <- sapply(X = module_list, FUN = extract_module_class)

  n_modules <- length(all_modules)

  module_combinations <- sapply(X = 2:n_modules,
                                FUN =  get_combos, modules = names(all_modules))

  modulos <- invisible(sapply(X = module_combinations, FUN = helper))

  super_module <- unlist(modulos, recursive = F)
  super_module <- unlist(super_module, recursive = F)

  if (include_single_methods == T){
    super_module <- c(all_modules, super_module)
  }
  class(super_module) <- c("MODifieR_super_module", "intersection")

  return(super_module)
}

get_combos <- function(n, modules){
  combn(x = modules, m = n)
}

get_intersect <- function(modules){
  mods <- all_modules[modules]
  tabled_frequencies <- table(unlist(mods)) / length(mods)
  n_modules <- length(mods)
  basic_name <- paste(modules, collapse = "+")

  #Set iterations for intersections
  iterations <- seq(from=(1/n_modules), to = 1, by = (1/n_modules))

  result <- list()

  for (i in iterations){
    current_rowname <- paste(basic_name, round(i,2), sep = "-")
    if (i == min(iterations)){
       current_rowname <- paste(basic_name, "union", sep = "-")
    }
    if (i == max(iterations)){

      current_rowname <- paste(basic_name, "intersection", sep = "-")
    }
    result[[current_rowname]] <- names(tabled_frequencies[tabled_frequencies >= i])
  }
  return(result)
}

helper <- function(x){
  freq_module <- invisible(apply(X = x, MARGIN = 2, FUN = get_intersect))
  return(freq_module)
}
