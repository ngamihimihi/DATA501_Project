# Draft Package and Testing Plan

This package implements EM-based imputation for with the option to switch to Monte Carlo EM if needed. 

### Install from GitHub
devtools::install_github("ngamihimihi/DATA501_Project/DATA501Package",INSTALL_opts = "--install-tests")

###Test Plan
1, Objective.
To test and validate the functionality of an R package that implements the Expectation-Maximization (EM) and Monte Carlo EM (MCEM) algorithms for missing data imputation under the multivariate normal assumption.
2. Test scope.
Function ready to test: 
- e_step_nvnorm_em
- e_step_nvnorm_mcem
- em_engine : only input method = 'nvnorm' is ready to test
- initialize_parameters
- initialize_parameters_nvnorm
- log_likelihood_nvnorm
- m_step_nvnorm
- run_em_algorithm: method = 'nvnorm' is ready to test

For em_engine and run_em_algorithm functions, only method = 'nvnorm' is ready to test. This mean the model set for em_model is also required to be set to 'nvnorm'.

2. Test category:: 
a. Initialisation function
- Functions: initialize_parameters_nvnorm()
	Test		Description								Expected outcome
	1,1		Input valid numeric matrix with some NAs			Returns valid mu and sigma, no error
	1.2		Input with a column entirely NA					Throws error
	1.3		Input with a row entirely NA					Issues warning, continues
	1.4		Covariance matrix not PD						Issues massage, applies jitter
	1.5		Invalid input (e,g.: dataframe or character matrix)	Throws error
b. E-step functions
- Function: e_step_nvnorm_em(), e_step_nvnorm_mc()
	Test		Description								Expectation outcome
	2.1		Inputed matrix matches the shape of input			Dimension equal
	2.2		Observed values remain unchanged				Same as input
	2.3		Missing values are imputed					NA replaced
	2.4		For MC version,accept_rate attribute exists		Attribute exists and is numeric
c. Log-Likelihood Function
- Function: log_likelihood_nvnorm()
	Test		Description								Expectation outcome
	3.1		Expected output data type 					Output is of double type and is a finite value
	3.2		No error thrown with correct intput				No error
	3.3		Function is able to handle single row data			Correct data type output and no error thrown
d.	Main Engine and EM Algorithm
- Function: em_engine(), run_em_algorithm()
	Test 		Description								Expected outcome
	4.1		Run without error for valid data					Return updated em_model
	4.2		parameter_history length == number of iterations	Confirmed
	4.3		Early stopping triggers						Stop before max_iter if tolerance met
	4.4		MCEM accept Monte Carlo parameters			Return updated em_model;

### Instruction to test submission
1. Install dependencies
Make sure all the following packages are installed: 

install.packages(c("devtools", "testthat", "rmarkdown", "knitr"))

2.Install the package
To install from Github

3.Run all unit tests:
Current unit tests are prepared for the 2 main object and function.
To run the unit test:
devtools::test()

4. Use test data
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
head(model _mcem$imputed,5)


