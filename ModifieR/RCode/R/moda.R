#' MODA
#'
#'A Coexpression based algorithm to identify disease module
#' 
#' @param datExpr1 A dataframe of the microarray matrix of the Control samples
#' @param datExpr2 A dataframe of the microarray matrix of the Control samples
#' @export
moda <- function(datExpr1, datExpr2,
                 CuttingCriterion = "Density",
                 indicator_datExpr1 = "control",
                 indicator_datExpr2 = "patient",
                 specificTheta = 0.1, conservedTheta = 0.1,
                 result_folder){
  # Retrieve settings
  default_args <- formals()
  user_args <- as.list(match.call(expand.dots = T)[-1])
  settings <- c(user_args, default_args[!names(default_args) %in% names(user_args)])

  CuttingCriterion = CuttingCriterion # could be Density or Modularity
  indicator1 = indicator_datExpr1     # indicator for data profile 1
  indicator2 = indicator_datExpr2   # indicator for data profile 2
  specificTheta = specificTheta #threshold to define condition specific modules
  conservedTheta = conservedTheta #threshold to define conserved modules

  ResultFolder = result_folder

  intModules1 <- MODA::WeightedModulePartitionDensity(datExpr1,ResultFolder,
                                                      indicator1,CuttingCriterion)

  intModules2 <- MODA::WeightedModulePartitionDensity(datExpr2,ResultFolder,
                                                      indicator2,CuttingCriterion)
  print("WMPD Indicators 1 done")

  MODA::CompareAllNets(ResultFolder,intModules1,indicator1,intModules2,
                       indicator2,specificTheta,conservedTheta)
  setwd(paste0(ResultFolder, indicator2))
  sep_moduleIDs = read.table("sepcificModuleid.txt", sep = "\n");
  cons_moduleIDs = read.table("conservedModuleid.txt", sep = "\n");

  setwd(ResultFolder)
  modules_control_sep = list()
  modules_patient_sep = list()
  for (i in 1: length(t(sep_moduleIDs))){
    if(file.exists(paste("DenseModuleGene_control_",sep_moduleIDs[i,],".txt",  sep =""))){
      if (file.info(paste("DenseModuleGene_control_",sep_moduleIDs[i,],".txt",  sep =""))$size != 0){
        modules_control_sep[i] = read.table(paste("DenseModuleGene_control_",sep_moduleIDs[i,],".txt",  sep =""), sep = "\n" , );
      }}
    if(file.exists(paste("DenseModuleGene_patient_",sep_moduleIDs[i,],".txt",  sep =""))){
      if (file.info(paste("DenseModuleGene_patient_",sep_moduleIDs[i,],".txt",  sep =""))$size != 0){
        modules_patient_sep[i] = read.table(paste("DenseModuleGene_patient_",sep_moduleIDs[i,],".txt",  sep =""), sep = "\n");
      }}
  }
  print("Modules patients and controls set")
  modules_control_cons = list()
  modules_patient_cons = list()
  for (i in 1: length(t(cons_moduleIDs))){
    if(file.exists(paste("DenseModuleGene_control_",cons_moduleIDs[i,],".txt",  sep =""))){
      if (file.info(paste("DenseModuleGene_control_",cons_moduleIDs[i,],".txt",  sep =""))$size != 0){
        modules_control_cons[i] = read.table(paste("DenseModuleGene_control_",cons_moduleIDs[i,],".txt",  sep =""), sep = "\n" , );
      }}
    if(file.exists(paste("DenseModuleGene_patient_",cons_moduleIDs[i,],".txt",  sep =""))){
      if (file.info(paste("DenseModuleGene_patient_",cons_moduleIDs[i,],".txt",  sep =""))$size != 0){
        modules_patient_cons[i] = read.table(paste("DenseModuleGene_patient_",cons_moduleIDs[i,],".txt",  sep =""), sep = "\n");
      }}
  }

  ## Union of submodules
  sep_module_control = unique(as.character(unlist(modules_control_sep)))
  sep_module_patient = unique(as.character(unlist(modules_patient_sep)))


  overlap_sep = VennDiagram::calculate.overlap(list(sep_module_control, sep_module_patient)) # check overlap
  overlap_sep2 = (t(overlap_sep$a3))

  cons_module_control = unique(as.character(unlist(modules_control_cons)))
  cons_module_patient = unique(as.character(unlist(modules_patient_cons)))
  print("Union of submodules 1")

  overlap_cons = VennDiagram::calculate.overlap(list(cons_module_control, cons_module_patient)) # check overlap
  overlap_cons2 = (t(overlap_cons$a3))
  print("Union of submodules 2")
  total_overlap = unique(c(overlap_cons2, overlap_sep2))

  new_moda_module <- list("module_genes" =  total_overlap,
                                "settings" = settings)

  class(new_moda_module) <- c("MODifieR_module", "MODA")

  return (new_moda_module)


}
