test_that("e_step_nvnorm_mc returns matrix of same shape", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "MCEM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_mcem(data, params, m = 10, burn = 5, thin = 1, tau = 0.1)
  expect_equal(dim(result$imputed), dim(data))
})
test_that("e_step_nvnorm_mc preserves observed values", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "MCEM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_mcem(data, params, m = 10, burn = 5, thin = 1, tau = 0.1)
  expect_equal(result$imputed[!is.na(data)], data[!is.na(data)])
})
test_that("e_step_nvnorm_mc fills missing values", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "MCEM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_mcem(data, params, m = 10, burn = 5, thin = 1, tau = 0.1)
  expect_false(anyNA(result$imputed))
})
test_that("e_step_nvnorm_mc returns accept_rate", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "MCEM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_mcem(data, params, m = 10, burn = 5, thin = 1, tau = 0.1)
  expect_true("accept_rate" %in% names(result))
  expect_true("imputed" %in% names(result))
  expect_false(anyNA(result$imputed))
})
