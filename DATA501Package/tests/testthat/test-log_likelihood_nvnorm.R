test_that("log_likelihood_nvnorm returns expected value for known input", {
  data <- matrix(c(
    1.0, 2.0,
    1.5, 2.5
  ), ncol = 2, byrow = TRUE)

  mu <- colMeans(data)
  Sigma <- cov(data)
  params<-list(mu=mu,sigma=Sigma)
  loglik <- log_likelihood_nvnorm(data, params)

  expect_type(loglik, "double")
  expect_length(loglik, 1)
  expect_true(is.finite(loglik))
})

test_that("No error thrown with correct input", {
  data <- matrix(c(
    1, 2,
    2, 4,
    3, 6
  ), ncol = 2, byrow = TRUE)

  mu <- colMeans(data)
  Sigma <- cov(data)
  params<-list(mu=mu,sigma=Sigma)
  expect_silent(log_likelihood_nvnorm(data, params)
               )
})

test_that("log_likelihood_nvnorm handles 1-row data", {
  data <- matrix(c(1.5, 2.5), ncol = 2)
  mu <- c(1.5, 2.5)
  Sigma <- diag(2)
  params<-list(mu=mu,sigma=Sigma)
  loglik <- log_likelihood_nvnorm(data, params)
  expect_type(loglik, "double")
})

