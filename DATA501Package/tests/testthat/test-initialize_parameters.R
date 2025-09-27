test_that("nvnorm: returns valid mu and sigma", {
  data <- matrix(rnorm(50), ncol = 5)
  params <- initialize_parameters_nvnorm(data)
  expect_type(params$mu, "double")
  expect_type(params$sigma, "double")
  expect_true(is.matrix(params$sigma))
  expect_equal(length(params$mu), ncol(data))
  expect_equal(dim(params$sigma), c(ncol(data), ncol(data)))
})

test_that("nvnorm: sigma is symmetric and PD (or corrected with jitter)", {
  data <- matrix(c(1, 2, 3, NA, 5, 6, 7, 8, 9), ncol = 3)
  expect_message({
    params <- initialize_parameters_nvnorm(data)
  }, regexp = "Warning: sigma not PD")
  eig <- eigen(params$sigma, symmetric = TRUE)$values
  expect_true(all(eig > 0))
})

test_that("One or more columns are entirely NA — cannot initialize.", {
  data <- matrix(c(1, NA, NA, 4, NA, NA), ncol = 3)
  expect_error(initialize_parameters_nvnorm(data), "One or more columns are entirely NA — cannot initialize.")
})
test_that("Some rows are completely NA — they will be ignored.", {
  data <- matrix(c(1, 2, 3, 4, 5, 6, NA, NA, NA), ncol = 3, byrow = TRUE)
  expect_warning(initialize_parameters_nvnorm(data), "Some rows are completely NA — they will be ignored.")
})

test_that("Covariance matrix has NA, Inf, or NaN values — likely due to too few complete observations.", {
  data <- matrix(c(1, 2, 3, NA, NA, NA), ncol = 3, byrow = TRUE)
  expect_error(initialize_parameters_nvnorm(data), "Covariance matrix has NA, Inf, or NaN values — likely due to too few complete observations.")
})
