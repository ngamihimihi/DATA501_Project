#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
Rcpp::List m_step_poisson(const arma::mat& imputed_data) {
  int n = imputed_data.n_rows;
  int d = imputed_data.n_cols;

  arma::mat data_clean = imputed_data;
  data_clean.elem(find_nonfinite(data_clean)).zeros();

  arma::rowvec lambda_new = arma::mean(data_clean, 0);
  lambda_new = arma::clamp(lambda_new, 1e-6, arma::datum::inf);

  return Rcpp::List::create(
    Rcpp::Named("lambda") = lambda_new.t()
  );
}
