# test_log_likelihood_poisson.R
test_that("log_likelihood_poisson computes correct log-likelihood for valid data", {
  # simple matrix
  data <- matrix(c(2, 1, 0,
                   3, 4, 2), nrow = 2, byrow = TRUE)
  lambda <- c(2, 3, 1)

  # run the function
  result <- log_likelihood_poisson(data, list(lambda = lambda))

  # manual computation for check:
  # sum_{ij} [ x_ij * log(lambda_j) - lambda_j - log(x_ij!) ]
  manual_ll <- sum(
    data * log(rep(lambda, each = nrow(data))) -
      rep(lambda, each = nrow(data)) -
      lgamma(data + 1)
  )

  expect_true(is.finite(result))
  expect_equal(result, manual_ll, tolerance = 1e-8)
})

test_that("log_likelihood_poisson is able to handles NA values", {
  data <- matrix(c(2, NA, 1,
                   1, 2, 3), nrow = 2, byrow = TRUE)
  lambda <- c(2, 3, 1)

  result <- log_likelihood_poisson(data, list(lambda = lambda))
  expect_true(is.finite(result))
})

test_that("log_likelihood_poisson throws error for mismatched lambda length", {
  data <- matrix(c(1, 2, 3, 4), nrow = 2)
  lambda <- c(1, 2,5)
  expect_error(log_likelihood_poisson(data, list(lambda = lambda)))
})

test_that("log_likelihood_poisson returns NA for invalid lambda", {
  data <- matrix(c(1, 2, 3), nrow = 1)
  lambda <- c(-1, 2, 3)
  result <- log_likelihood_poisson(data, list(lambda = lambda))
  expect_true(is.na(result))
})

test_that("log_likelihood_poisson returns NA for invalid data values", {
  data <- matrix(c(-1, 2, 3), nrow = 1)
  lambda <- c(1, 2, 3)
  result <- log_likelihood_poisson(data, list(lambda = lambda))
  expect_true(is.na(result))
})

test_that("log_likelihood_poisson works for edge case zeros", {
  data <- matrix(c(0, 0, 0, 0), nrow = 2)
  lambda <- c(1, 1)
  result <- log_likelihood_poisson(data, list(lambda = lambda))
  expect_true(is.finite(result))
})
