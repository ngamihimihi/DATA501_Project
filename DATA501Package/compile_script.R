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
data <-matrix(c(
  1.0, 0.5, 0.3, 0.2,
  0.5, NA, 0.4, 0.3,
  0.3, 0.4, 1.0, NA,
  0.2, NA, 0.2, 1.0
), nrow = 4)
params<-list(mu=mu,sigma=sigma)

# Test intput
mat_na <- matrix(NA, nrow = 3, ncol = 2)
em_model(mat_na, "EM", "nvnorm")


# Test EM model
model <- em_model(data,distribution = "poisson",method = "EM")
result <- run_em_algorithm(model, tolerance = 1e-3, m = 100)
params <- initialize_parameters_poisson(model$data)
params$lambda

model <- em_model(data,distribution = "nvnorm",method = "EM")
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
result <- run_em_algorithm(model, tolerance = 1e-3, m = 100)

#---Assess result
result$data
result$method
result$early_stop
result$loglik_history
result$distribution
result$parameters
  result$parameter_history
  result$imputed
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

data<-data[,-c(1,2)]
data <- as.matrix(data)
model <- em_model(data,distribution = "nvnorm",method = "EM")
model_em <- em_model(data,distribution = "nvnorm",method = "EM")
model_mcem<- em_model(data,distribution = "nvnorm",method = "EM")
#View result
#Standard EM
model_em$data
model_em$method
model_em$early_stop
model_em$loglik_history
model_em$distribution
model_em$parameters
model_em$parameter_history
head(model_em$imputed,5)
#Monte Carlo EM
model_mcem$data
model_mcem$method
model_mcem$early_stop
model_mcem$loglik_history
model_mcem$distribution
model_mcem$parameters
model_mcem$parameter_history
head(model_mcem$imputed,5)

#
head(model_mcem$data,5)
result_em <- run_em_algorithm(model_em, tolerance = 1e-3, m = 100)
result_mcem <- run_em_algorithm(model_mcem, tolerance = 1e-3, m = 100)
head(model_mcem$data,5)
head(result_em$imputed,5)
head(result_mcem$imputed,5)


