### Module 1
### Packages

### RevolutionH-tl Final Plot

## Step 0: Load and install required packages.

# Set the CRAN repository at the beginning
options(repos = c(CRAN = "https://cran.r-project.org"))

# Install BiocManager if it is not already available
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# Set Bioconductor to the desired version
BiocManager::install(version = "3.20", ask = FALSE)

# Function to check and install packages from CRAN and Bioconductor
check_and_install_packages <- function(packages) {
  # Initialize lists to store installation and loading results
  installed_successfully <- c()
  loaded_successfully <- c()
  failed_to_install <- c()
  failed_to_load <- c()

  # Identify packages that are not installed
  packages_to_install <- packages[!(packages %in% installed.packages()[, "Package"])]

  # Specific Bioconductor packages
  bioc_packages <- c("ggtree", "treeio", "ggtreeExtra", "phangorn")

  # Separate packages by source: CRAN or Bioconductor
  cran_packages <- setdiff(packages_to_install, bioc_packages)
  bioc_packages_to_install <- intersect(packages_to_install, bioc_packages)

  # Install packages from CRAN
  if (length(cran_packages) > 0) {
    tryCatch({
      install.packages(cran_packages, dependencies = TRUE)
      installed_successfully <- c(installed_successfully, cran_packages)
    }, error = function(e) {
      message("Error installing packages from CRAN: ", conditionMessage(e))
      failed_to_install <- c(failed_to_install, cran_packages)
    })
  }

  # Install packages from Bioconductor
  if (length(bioc_packages_to_install) > 0) {
    tryCatch({
      BiocManager::install(bioc_packages_to_install, ask = FALSE, update = FALSE)
      installed_successfully <- c(installed_successfully, bioc_packages_to_install)
    }, error = function(e) {
      message("Error installing packages from Bioconductor: ", conditionMessage(e))
      failed_to_install <- c(failed_to_install, bioc_packages_to_install)
    })
  }

  # Load the installed packages
  lapply(packages, function(pkg) {
    if (require(pkg, character.only = TRUE)) {
      loaded_successfully <<- c(loaded_successfully, pkg)
    } else {
      failed_to_load <<- c(failed_to_load, pkg)
    }
  })

  # Display a summary of installation and loading results
  message("\n--- Package Installation and Loading Summary ---")
  if (length(installed_successfully) > 0) {
    message("Successfully installed packages: ", paste(installed_successfully, collapse = ", "))
  }
  if (length(failed_to_install) > 0) {
    message("Packages that failed to install: ", paste(failed_to_install, collapse = ", "))
  }
  if (length(loaded_successfully) > 0) {
    message("Successfully loaded packages: ", paste(loaded_successfully, collapse = ", "))
  }
  if (length(failed_to_load) > 0) {
    stop("Packages that failed to load: ", paste(failed_to_load, collapse = ", "))
  }
}

# List of required packages
required_packages <- c("ggtree", "tidytree", "ggplot2", "dplyr", "tidyr",
                       "RColorBrewer", "gridExtra", "cowplot", "treeio",
                       "ggtreeExtra", "phangorn", "grid", "magick", "here",
                       "ggimage", "svglite")

# Check and install the required packages
check_and_install_packages(required_packages)

# Determine the base directory
base_directory <- tryCatch({
  library(here)
  here()
}, error = function(e) {
  message("Error determining the base directory with here(): ", conditionMessage(e))
  getwd()  # Use the current working directory as a fallback
})

# Change to the base directory if it is valid
if (dir.exists(base_directory)) {
  setwd(base_directory)
  message("Working directory set to: ", base_directory)
} else {
  stop("Failed to set the working directory.")
}

#################################################################################
