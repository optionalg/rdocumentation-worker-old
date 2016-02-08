options(repos=structure(c(CRAN="http://cran.rstudio.com")));

packages = c('jsonlite','RCurl')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
for (pkg in packages){
  library(pkg, character.only = TRUE);
}
​
overlay <- function(list1, list2) {
  !( paste(names(list1), unlist(list1)) %in% paste(names(list2), unlist(list2)) )
}
​
# STEP 1: Get the list of packages w/ version from Rdocumentation as well as from CRAN
rdocs_versions = jsonlite::fromJSON(getURL(url="http://www.rdocumentation.org/packages/all_versions"))
r_versions = as.list(available.packages()[,2])
​
# STEP 2: Compare the lists to get the new packages and the ones that need to be updated
condition = overlay(r_versions, rdocs_versions)
cran_packages_to_update = r_versions[condition]
​
# STEP 3: Check which of the packages to update need to be installed
installed_packages = as.list(installed.packages()[,3]);
condition =  overlay(cran_packages_to_update, installed_packages)
cran_packages_to_install = cran_packages_to_update[condition]
​
# STEP 4: Install the necessary packages
paste("Installing", length(cran_packages_to_install), "packages from CRAN.")
​
# Convert to json file
json_update = jsonlite::toJSON(data.frame(name = names(cran_packages_to_update), version = unlist(cran_packages_to_update), row.names = NULL))
​
write(json_update, "package_versions.json")
