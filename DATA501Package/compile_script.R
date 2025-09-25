installed.packages("usethis")
installed.packages("devtools")
installed.packages("roxygen2")
installed.packages("testthat")
library(usethis)
library(devtools)
library(roxygen2)
library(testthat)
library(RcppArmadillo)

use_r("zzz.R")
use_package("Rcpp",type="LinkingTo")
use_package("RcppArmadillo",type="LinkingTo")
usethis::use_package("Rcpp", type = "Imports")
usethis::use_package("RcppArmadillo", type = "Imports")

Rcpp::compileAttributes()
devtools::document()
devtools::load_all()


#
devtools::clean_dll()
devtools::document()
devtools::install()
.rs.restartR()
library(DATA501Package)
# Create 4x4 dataset with missing values
data <- matrix(c(
  5.1, 1, 2.0, 3.3,
  1, NA, 2.2, 1.1,
  6.1, NA, 2.5, 1,
  5.0, 6.5, 2.0, 3.0
), byrow = TRUE, ncol = 4)

mu <- c(5.5, 4.2, 2.2, 3.0)
sigma <-matrix(c(
  1.0, 0.5, 0.3, 0.2,
  0.5, 1.0, 0.4, 0.3,
  0.3, 0.4, 1.0, 0.2,
  0.2, 0.3, 0.2, 1.0
), nrow = 4)
params<-list(mu=mu,sigma=sigma)
# Test EM model
model <- em_model(data,distribution = "nvnorm",method = "EM")
params <- initialize_parameters_nvnorm(model$data)
params$mu
params$sigma
model_em<-run_em_algorithm(model, tolerance = 1e-4)
#---Assess result
model_em$data
model_em$method
model_em$early_stop
model_em$loglik_history
model_em$distribution
model_em$parameters$
model_em$parameter_history
model_em$imputed
## Tets monte carlo
model <- em_model(data,distribution = "nvnorm",method = "MCEM")
params <- initialize_parameters_nvnorm(model$data)
result <- run_em_algorithm(model, tolerance = 1e-4, m = 100)

#---Assess result
result$data
result$method
result$early_stop
result$loglik_history
result$distribution
result$parameters
  result$parameter_history
result$imputed


# --- generate vignette
usethis::use_vignette("Introduction to the EM Algorithm")
devtools::build_vignettes()
browseVignettes("Introduction to the EM Algorithm")

vignette("em-algorithm-intro", package = "DATA501AGM2")
