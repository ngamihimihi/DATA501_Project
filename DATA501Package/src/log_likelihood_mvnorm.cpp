#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
double log_likelihood_mvnorm(const arma::mat& data,
                             const arma::vec& mu,
                             const arma::mat& Sigma) {
  int n = data.n_rows;
  int d = data.n_cols;

  // Precompute constants
  double log2pi = std::log(2.0 * M_PI);
  double sign;
  double logdet_val;
  log_det(logdet_val, sign, Sigma);  // log|Sigma|
  arma::mat inv_Sigma = inv(Sigma);

  double total_ll = 0.0;

  for (int i = 0; i < n; ++i) {
    arma::rowvec x = data.row(i);
    arma::rowvec diff = x - mu.t();
    double quad_form = as_scalar(diff * inv_Sigma * diff.t());

    total_ll += -0.5 * (d * log2pi + logdet_val + quad_form);
  }

  return total_ll;
}
