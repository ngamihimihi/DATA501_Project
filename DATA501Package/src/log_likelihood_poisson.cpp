#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
double log_likelihood_poisson(const arma::mat& data, const arma::vec& lambda) {
  const int n = data.n_rows;
  const int d = data.n_cols;

  if ((int)lambda.n_elem != d) {
    stop("Length of lambda must equal number of columns in data");
  }

  // guard lambda
  for (int j = 0; j < d; ++j) {
    double lam = lambda(j);
    if (!std::isfinite(lam) || lam <= 0.0) {
      return NA_REAL;  // signal invalid params
    }
  }

  double total_ll = 0.0;

  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < d; ++j) {
      double x = data(i, j);
      if (R_IsNA(x)) continue;
      if (!std::isfinite(x) || x < 0.0) {
        return NA_REAL;
      }
      double lam = lambda(j);

      // x*log(lam) - lam - log(x!)
      total_ll += x * std::log(lam) - lam - lgamma(x + 1.0);
    }
  }

  // If total_ll got poisoned
  if (!std::isfinite(total_ll)) return NA_REAL;
  return total_ll;
}
