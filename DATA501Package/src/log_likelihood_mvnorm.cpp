#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
double log_likelihood_nvnorm(const arma::mat& data,
                             const arma::vec& mu,
                             const arma::mat& Sigma) {
  int n = data.n_rows;
  int d = data.n_cols;

  // Regularize Sigma to improve PD properties
  arma::mat Sigma_reg = Sigma + 1e-4 * arma::eye(d, d);

  // Log-determinant
  double log2pi = std::log(2.0 * M_PI);
  double sign = 0.0;
  double logdet_val = 0.0;

  bool success = log_det(logdet_val, sign, Sigma_reg);

  if (!success || sign <= 0) {
    Rcpp::stop("Log-determinant failed: covariance matrix may not be PD");
  }

  // Inverse
  arma::mat inv_Sigma = inv_sympd(Sigma_reg);

  // Compute log-likelihood
  double total_ll = 0.0;

  for (int i = 0; i < n; ++i) {
    arma::rowvec x = data.row(i);
    arma::rowvec diff = x - mu.t();
    double quad_form = as_scalar(diff * inv_Sigma * diff.t());
    total_ll += -0.5 * (d * log2pi + logdet_val + quad_form);
  }

  return total_ll;
}
