#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;
// [[Rcpp::export]]
Rcpp::List m_step_poisson(const arma::mat& imputed_data) {
  int n = imputed_data.n_rows;

  // Compute new mean
  arma::rowvec lambda_new = arma::mean(imputed_data, 0);  // mean across rows

  // Center the data
  arma::mat centered = imputed_data.each_row() - lambda_new;
  return Rcpp::List::create(
    Rcpp::Named("lambda") = lambda_new.t()  // column vector
  );
}
