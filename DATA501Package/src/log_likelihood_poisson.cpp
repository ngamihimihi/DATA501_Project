#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
double log_likelihood_poisson(Rcpp::NumericMatrix data, Rcpp::NumericVector lambda) {
  int n = data.nrow();
  int d = data.ncol();

  if (lambda.size() != d) {
    Rcpp::stop("Length of lambda must equal number of columns in data");
  }

  double total_ll = 0.0;

  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < d; ++j) {
      double x = data(i, j);
      if (Rcpp::NumericMatrix::is_na(x)) continue;

      double lam = lambda[j];
      if (lam <= 0.0 || !R_finite(lam)) return NA_REAL;
      if (x < 0.0 || !R_finite(x)) return NA_REAL;

      total_ll += x * std::log(lam) - lam - lgamma(x + 1.0);
    }
  }

  if (!R_finite(total_ll)) return NA_REAL;
  return total_ll;
}
