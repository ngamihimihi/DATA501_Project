test_that("m_step_nvnorm returns mu and sigma with correct shapes", {
  imputed <- matrix(c(
    5.1, 1.0, 2.0, 3.3,
    4.9, 1.2, 2.1, 3.0,
    5.0, 1.4, 2.2, 1.1,
    6.1, 4.3, 2.5, 1.0
  ), byrow = TRUE, ncol = 4)

  result <- m_step_nvnorm(imputed)

  # Check result structure
  expect_type(result, "list")
  expect_true(all(c("mu", "sigma") %in% names(result)))

  # Check mu
  expect_type(result$mu, "double")
  expect_length(result$mu, ncol(imputed))

  # Check sigma
  expect_type(result$sigma, "double")
  expect_equal(dim(result$sigma), c(ncol(imputed), ncol(imputed)))

  # Check sigma is symmetric
  expect_equal(result$sigma, t(result$sigma), tolerance = 1e-8)

  # Check sigma is PD (all eigenvalues > 0)
  eig_vals <- eigen(result$sigma, symmetric = TRUE)$values
  expect_true(all(eig_vals > 0))
})
