test_that("e_step_nvnorm_em returns matrix of same shape", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "EM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_em(data, params)
  expect_equal(dim(result), dim(data))
})

test_that("e_step_nvnorm_em preserves observed values", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "EM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_em(data, params)
  expect_equal(result[!is.na(data)], data[!is.na(data)])
})

test_that("e_step_nvnorm_em fills missing values", {
  data <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    NA, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, NA
  ), byrow = TRUE, ncol = 4)
  model <- em_model(data,distribution = "nvnorm",method = "EM")
  params <- initialize_parameters_nvnorm(model$data)
  result <- e_step_nvnorm_em(data, params)
  expect_false(anyNA(result))
})
