options(repos=structure(c(CRAN="http://cran.rstudio.com")));

# Install packages if needed
packages = c('parallel','tools')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
for (pkg in packages){
  library(pkg, character.only = TRUE);
}

load("package_versions.RData")

install_cran_pkg = function(x) {
  install.packages(x, dependencies = TRUE)
  paste("Installed", x, "successfully from CRAN!")
  return("success!")
}

blacklisted_packages = c("AdapEnetClass", "rgdal","BrailleR")

counter = 0
for (pkg_name in names(cran_packages_to_install)) {
  if(pkg_name %in% blacklisted_packages) {
      next()
  }
  cat(paste0("Installing ", pkg_name, "... "))
  install_process = mcparallel(install_cran_pkg(pkg_name), silent =FALSE)
  result = mccollect(install_process, wait = FALSE, 120)
  if (is.null(result)) {
    cat("failed.\n")
    parallel:::mckill(install_process, signal = tools::SIGTSTP)
  } else {
    cat(paste0(result[[1]], "\n"))
    parallel:::mckill(install_process)
  }
  counter = counter + 1
  
  if (counter %% 15 == 0) { # every now and then, kill all child processes just to be sure
    cat("Cleanup: SIGKILL on all processes...")
    pskill(unname(unlist(parallel:::children())), signal=SIGKILL)
  }
}