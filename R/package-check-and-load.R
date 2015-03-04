# Small script to check for potentially required packages.
# Installs them if necessary and loads them via library()
# Author: lukas@quantenbrot.de

# Define a list of required/suggested packages
suggested_packages <- read.table(sep = ",", strip.white = T, header = T, stringsAsFactors = F, text =
                                   "name, src, github
                                    plyr, CRAN, NA
                                    dplyr, CRAN, NA
                                    ryouready, CRAN, NA
                                    car, CRAN, NA
                                    foreign, CRAN, NA
                                    gmodels, CRAN, NA
                                    ndl, CRAN, NA
                                    vcd, CRAN, NA
                                    ggplot2, CRAN, NA
                                    sjPlot, CRAN, NA
                                    reshape2, CRAN, NA,
                                    ppcor, CRAN, NA,
                                    QuantPsyc, CRAN, NA,
                                    lsr, CRAN, NA,
                                    nortest, CRAN, NA,
                                    broom, CRAN, NA,
                                    tidyr, CRAN, NA,
                                    haven, CRAN, NA")

# Define a function to check for packages, install if necessary and load afterwards
check_and_load <- function(pkg = NULL){
  if (is.null(pkg$name) || !is.character(pkg$name) || length(pkg$name) != 1){
    stop("No package defined ¯\\_(ツ)_/¯ Doing nothing.")
  }
  message("Checking if ", pkg$name, " is installed…")
  installed <- (pkg$name %in% installed.packages())
  if (!installed){
    message(pkg$name, " not found, trying to install from ", pkg$src, "…")
    if (pkg$src == "CRAN"){
      install.packages(pkg$name)
    } else if (pkg$src == "github"){
      if (!("devtools" %in% installed.packages())){install.packages("devtools")}
      require(devtools)
      install_github(pkg$github)
    }
  } else {
    message(pkg$name, " is installed, skipping installation…")
  }
  message("Loading ", pkg$name)
  suppressPackageStartupMessages(library(pkg$name, character.only = T))
}

# Execute previous function on defined packages
for (pkg in seq_len(nrow(suggested_packages))){
  check_and_load(suggested_packages[pkg, ])
}

# Cleanup
rm(pkg, suggested_packages, check_and_load)
