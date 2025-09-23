# DATA501AGM2

This package implements EM-based imputation for multivariate normal data.

## Installation


### Install from GitHub
devtools::install_github("ngamihimihi/")

### Instruction to test submission
1. Install dependencies
Make sure all the following packages are installed: 

install.packages(c("devtools", "testthat", "rmarkdown", "knitr"))

2.Install the package
To install from Github

3.Run all unit tests:
Current unit tests are prepared for the 2 main object and function 
- S3 Object : EM_model
- main function: run_em_algorithm

To run the unit test: 
devtools::test()

4.Try the following workflow

library(DATA501AGM2)


data <- matrix(c(
  5.1, NA, 2.0, 3.3,
  NA, 4.4, NA, 1.1,
  6.1, 4.3, 2.5, NA,
  5.0, 4.1, 2.0, 3.0
), byrow = TRUE, ncol = 4)
model <- em_model(data)
result <- run_em_algorithm(model)

result$imputed
plot(result$loglik_history, type = "l")
