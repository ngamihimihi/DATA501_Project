#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
double log_likelihood_poisson(const arma::mat& data, const arma::vec& lambda) {
  int n = data.n_rows;
  int d = data.n_cols;

  if ((int)lambda.n_elem != d) {
    stop("Length of lambda must equal number of columns in data");
  }

  double total_ll = 0.0;

  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < d; ++j) {
      double x = data(i, j);
      if (R_IsNA(x)) continue;

      double lam = lambda(j);
      if (lam <= 0.0 || !std::isfinite(lam)) return NA_REAL;
      if (x < 0.0 || !std::isfinite(x)) return NA_REAL;

      total_ll += x * std::log(lam) - lam - lgamma(x + 1.0);
    }
  }

  if (!std::isfinite(total_ll)) return NA_REAL;
  return total_ll;
}
