# Package: DATA501Package : Expectation-Maximization (EM) 
DATA501Package implements a family of Expectation-Maximization (EM) algorithms for missing data imputation under common statistical distributions.
It provides both standard EM and Monte Carlo EM (MCEM) variants for flexible modeling when the analytical expectation is not tractable.  
The package is designed for data scientists, statisticians, and researchers working with incomplete numerical datasets and requiring probabilistic imputation while maintaining interpretability and convergence diagnostics.  


### Install from GitHub
#install.packages("remotes")
#if not already installed
remotes::install_github("ngamihimihi/DATA501_Project", 
                        subdir = "DATA501Package",
                        build_vignettes = TRUE, 
                        INSTALL_opts = c("--install-tests"))

### Instruction for testing
Detail of the test plan can be found: [here](https://github.com/ngamihimihi/DATA501_Project/blob/main/DATA501Package/doc/Test_plan.pdf)

### Use test data
Test data: kc_house_data.csv
Dependency: dplyr, data needs to be converted to matrix before passing on to run_em_algorithm
Code to import and test:
data<-read.csv("kc_house_data.csv",skip=1,header = FALSE)
head(data,5)
data<-data[,-c(1,2)]
data <- as.matrix(data)
model <- em_model(data,distribution = "nvnorm",method = "EM")
model_em <- em_model(data,distribution = "nvnorm",method = "EM")
model_mcem<- em_model(data,distribution = "nvnorm",method = "EM")

#### View result

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
head(model _mcem$imputed,5)
