#####################
# --- Valid input---#
#####################
test_that("em_model expected minimum 3 inputs: Data, distribution, method", {
  data <- matrix(c(1, NA, 2, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,dist)
  expect_s3_class(model, "em_model")
})

test_that("em_model contains required fields", {
  data <- matrix(c(1, NA, 2, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,dist)
  expect_named(model, c(
    "data", "method", "early_stop", "loglik_history", "distribution",
    "parameters", "parameter_history", "imputed"
  ), ignore.order = TRUE)
})

test_that("Input data must be a numeric matrix.", {
  data <- matrix(c(1, NA, "a", 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
 expect_error(em_model(data,method,dist), "Input data must be a numeric matrix.")
})
test_that("Input data must be a numeric matrix.", {
  data <- matrix(c("!", "$"), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  expect_error(em_model(data,method,dist), "Input data must be a numeric matrix.")
})
test_that("error if data is not a numeric matrix", {
  expect_error(em_model(data.frame(x = c(1, NA), y = c(3, 4)),method,dist),
               "Input data must be a numeric matrix")
})
test_that("Input data matrix cannot contain only missing values.", {
  mat_na <- matrix(NA_real_, nrow = 3, ncol = 2) #Use NA_real_ make sure the NA is of numeric type.
  method<-"EM"
  dist<-"nvnorm"
  expect_error(em_model(mat_na,method,dist),
               "Input data matrix cannot contain only missing values.")
})
test_that("Valid numeric matrix with NA is accepted.", {
  a<-1
  b<-3
  c<-NA
  data <- matrix(c(a, b,c), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  expect_silent(em_model(data,method,dist))
})

test_that("Method must be one of: EM, MCEM", {
  data <- matrix(c(1, NA, 2, 4), ncol = 2)
  dist<-"nvnorm"
  expect_error(em_model(data,method="MOO",dist),"Method must be one of: EM, MCEM")
})

test_that("Distribution must be one of: nvnorm, poisson, mixture", {
  data <- matrix(c(1, NA, 2, 4), ncol = 2)
  method<-"EM"
  expect_error(em_model(data,method,distribution="MOO"),"Only the following distributions are supported currently: nvnorm, poisson, mixture")
})
######################
# --- Valid output---#
######################
test_that("early_stop defaults to empty list", {
  data <- matrix(c(1, 2, NA, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,distribution = dist)
  expect_type(model$early_stop, "list")
  expect_length(model$early_stop, 0)
})
test_that("loglik_history is initialized empty", {
  data <- matrix(c(1, 2, NA, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,distribution = dist)
  expect_length(model$loglik_history, 0)
})
test_that("parameter history is initialized empty", {
  data <- matrix(c(1, NA, 3, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,distribution = dist)
  expect_type(model$parameter_history, "list")
  expect_length(model$parameter_history, 0)
})
test_that("imputed is initially NULL", {
  data <- matrix(c(1, NA, 3, 4), ncol = 2)
  method<-"EM"
  dist<-"nvnorm"
  model <- em_model(data,method,distribution = dist)
  expect_null(model$imputed)
})

