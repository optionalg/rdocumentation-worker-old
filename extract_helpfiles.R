# LEGACY CODE
# JUST COPY-PASTED
# NEEDS TO BE CLEANED UP

# CHANGE BELOW TO SET THE PATH OF FOLDER ON SERVER TO WHERE THE HELP FILES SHOULD BE SAVED:
dest_path = paste0(getwd(),"/helpfiles")
print(paste0("Saving helpfiles to: ", dest_path))

options(repos=structure(c(CRAN="http://cran.rstudio.com")))

# Install packages if needed
packages = c('testthat','tools')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
for (pkg in packages){
  library(pkg, character.only = TRUE);
}

# @bram packages are here because I'm too lazy to check whether they are still necessary
# library("tools");library("testthat");library("evaluate");library("whisker");
# library("highlight");library("highlight");library("devtools");
# library("RCurl");library("rjson");library("httr");library("RJSONIO")
# library("plyr");library("reshape2");library("lubridate");
# library("parallel")

log = function(x) {
	print(x)
}

all_help_functions = function(pkg){
	links = tools::findHTMLlinks()
	pkgRdDB = tools:::fetchRdDB(file.path(find.package(pkg), 'help', pkg))
	force(links); topics = names(pkgRdDB)
	spec_dest_path = paste(dest_path,"/",pkg,"/html/",sep="")
	dir.create( paste(dest_path,"/",pkg,sep=""), showWarnings = FALSE);
	dir.create( spec_dest_path, showWarnings = FALSE);
	log(spec_dest_path)
	setwd(spec_dest_path);
	for (p in topics){
		tools::Rd2HTML(pkgRdDB[[p]], paste(p, 'html', sep = '.'),
			package = pkg, Links = links, no_links = is.null(links))
	}
}

grab_description_file = function(pkg,dest_path){
	file.name = paste( find.package(pkg),"/DESCRIPTION",sep="")
	it.does.exist = file.exists( file.name )
	if(it.does.exist){
		file.copy(from=file.name,to=paste(dest_path,"/",pkg,"/DESCRIPTION",sep="") )
	} else { 
		warning(paste("No DESCRIPTION found for package",pkg))
	}
}

grab_vignettes = function(pkg,dest_path){
	dest.dir = paste( dest_path,"/",pkg,"/doc/",sep="")
	path = as.package(find.package(pkg))$path;
	src.dir  = paste( path,"/doc/",sep="" )
	dir.create(dest.dir)
	buildVignettes(dir = path, tangle = TRUE) #Build package vignettes to be sure they are there
	file.names = dir(src.dir)
	sapply( file.names, function(x) { 
		file.copy( from=paste(src.dir, x, sep=''), to=paste(dest.dir, x, sep=''), overwrite = FALSE)
	})
}

static_help = function(pkg,dest_path,lib_path){
	# 1. Generate help file for all functions in a package:
	all_help_functions(pkg);

	# 3. Generate help file for the description
	grab_description_file(pkg, dest_path);

	# 4. Generate and grab the vignettes & other extra info/...
	grab_vignettes(pkg=pkg, dest_path=dest_path);
}

# For multiple packages: (default uses all packages that are installed)
static_help_all = function(packages=.packages(TRUE),dest_path){
	force(packages);
	counter = 0;
	for(p in packages){
		message(counter,'* Making static html help pages for ', p)
		log(paste0(counter,'* Making static html help pages for ', p))
		try( static_help(p, dest_path ) );
		counter = counter + 1;
	}
}

dir.create(dest_path);
load("package_versions.RData")
log(paste0("Creating help files for ", length(cran_packages_to_update)," CRAN packages"))
static_help_all( packages = names(cran_packages_to_update), dest_path = dest_path );


