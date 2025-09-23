#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;
// [[Rcpp::export]]
Rcpp::List m_step_nvnorm(const arma::mat& imputed_data) {
  int n = imputed_data.n_rows;

  // Compute new mean
  arma::rowvec mu_new = arma::mean(imputed_data, 0);  // mean across rows

  // Center the data
  arma::mat centered = imputed_data.each_row() - mu_new;

  // Compute sample covariance
  arma::mat Sigma_new = (centered.t() * centered) / n;

  // Force symmetry: numerical safety
  Sigma_new = 0.5 * (Sigma_new + Sigma_new.t());

  // Add small ridge (regularization) to make Sigma PD
  double lambda = 1e-6;
  Sigma_new += lambda * arma::eye(Sigma_new.n_rows, Sigma_new.n_cols);

  return Rcpp::List::create(
    Rcpp::Named("mu") = mu_new.t(),  // column vector
    Rcpp::Named("sigma") = Sigma_new
  );
}
