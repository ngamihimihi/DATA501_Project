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
  5.1, NA, 2.0, 3.3,
  NA, 4.4, 2.2, 1.1,
  6.1, 4.3, 2.5, NA,
  5.0, 4.1, 2.0, 3.0
), byrow = TRUE, ncol = 4)

mu <- c(5.5, 4.2, 2.2, 3.0)
Sigma <- matrix(c(
  1.0, 0.5, 0.3, 0.2,
  0.5, 1.0, 0.4, 0.3,
  0.3, 0.4, 1.0, 0.2,
  0.2, 0.3, 0.2, 1.0
), nrow = 4)
#test model
model <- em_model(data,distribution = "nvnorm")
model_em<-run_em_algorithm(model)
model_em$loglik_history
model_em$parameter_history
plot(model_em$loglik_history)
model_em$method



##debug
params <- list(
  mu = c(5.4, 4.27, 2.17, 2.47),
  Sigma = matrix(1, 4, 4)  # Just for testing – use a real covariance matrix if available
)

data <- matrix(rnorm(40), ncol = 4)

log_likelihood_nvnorm(data, params)
#generate vignette
usethis::use_vignette("Introduction to the EM Algorithm")
devtools::build_vignettes()
browseVignettes("Introduction to the EM Algorithm")

vignette("em-algorithm-intro", package = "DATA501AGM2")
