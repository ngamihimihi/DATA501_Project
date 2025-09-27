test_that("run_em_algorithm completes without error", {
  data <- matrix(c(1, NA, 3, 4, 5, 6), ncol = 2)
  model <- em_model(data, method = "EM", distribution = "nvnorm")

  result <- run_em_algorithm(model, max_iter = 50, tolerance = 1e-4)

  expect_s3_class(result, "em_model")
})
test_that("run_em_algorithm populates model fields", {
  data <- matrix(c(1, NA, 3, 4, 5, 6), ncol = 2)
  model <- em_model(data, method = "EM", distribution = "nvnorm")

  result <- run_em_algorithm(model, max_iter = 50, tolerance = 1e-4)

  expect_false(is.null(result$imputed))
  expect_type(result$parameters$mu, "double")
  expect_true(length(result$loglik_history) > 1)
})
test_that("early stopping triggers when loglikelihood stabilizes", {
  data <- matrix(c(1, NA, 3, 4, 5, 6), ncol = 2)
  model <- em_model(data, method = "EM", distribution = "nvnorm")

  result <- run_em_algorithm(model, max_iter = 100, tolerance = 1)

  expect_true(result$early_stop$converged)
  expect_true(result$early_stop$iterations < 100)
})
test_that("parameter history is recorded over iterations", {
  data <- matrix(c(1, NA, 3, 4, 5, 6), ncol = 2)
  model <- em_model(data, method = "EM", distribution = "nvnorm")

  result <- run_em_algorithm(model, max_iter = 10, tolerance = 1e-10)

  expect_equal(length(result$parameter_history), result$early_stop$iterations)
})
test_that("MCEM accepts Monte Carlo parameters", {
  data <- matrix(c(1, NA, 3, 4, 5, 6), ncol = 2)
  model <- em_model(data, method = "MCEM", distribution = "nvnorm")

  result <- run_em_algorithm(model, max_iter = 10, m = 5, burn = 2, thin = 1, tau = 0.2)

  expect_false(is.null(result$imputed))
  expect_type(attr(result$imputed, "mc_accept_rate"), "double")
})
