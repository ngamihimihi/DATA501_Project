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
# read data
library(dplyr)
data<-read.csv("kc_house_data.csv",skip=1,header = FALSE)
head(data,5)
data<-data[,-c(1,2)]
data <- as.matrix(data)
mu <- c(5.5, 4.2, 2.2, 3.0)
data.poisson <-matrix(c(
  1.0, 0.5, 0.3, NA,
  0.5, NA, 0.4, 0.3,
  0.3, 0.4, NA, 0.2,
  NA, NA, 0.2, 1.0
), nrow = 4)
params<-list(mu=mu,sigma=sigma)


## Test monte carlo
model <- em_model(data.poisson,distribution = "poisson",method = "EM")
params <- initialize_parameters_nvnorm(model$data)
result <- run_em_algorithm(model, tolerance = 1e-3, m = 100)
plot(result, what = "loglik")       # log-likelihood progression
summary(result)
result$imputed
htg6
unlist(result$parameters_history)

head(result$parameters_history,5)
#---Assess result

result$data
result$method
result$early_stop
result$loglik_history
result$distribution
result$parameters
  head(result$parameter_history[[4]]$mu,5)
  head(result$parameter_history[[5]]$mu,5)
  head(result$parameter_history[[6]]$mu,5)
  head(result$parameter_history[[7]]$mu,5)
  class(result$parameter_history)
  (result$mc_diagnostics[[0]])
head(result$imputed,5)

# --- Create test file
library(testthat)
usethis::use_testthat()
usethis::use_test("em_model")
usethis::use_test("initialize_parameters")
usethis::use_test("e_step_nvnorm_em")
usethis::use_test("e_step_nvnorm_mcem")
usethis::use_test("m_step_nvnorm")
usethis::use_test("log_likelihood_nvnorm")
usethis::use_test("run_em_algorithm")
devtools::test()
# --- generate vignette
usethis::use_vignette("Introduction to the EM Algorithm")
devtools::build_vignettes()
browseVignettes("Introduction to the EM Algorithm")

vignette("em-algorithm-intro", package = "DATA501AGM2")

# read data
library(dplyr)
data<-read.csv("kc_house_data.csv",skip=1,header = FALSE)

head(data,5)

