#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
double log_likelihood_poisson(const arma::mat& data, const arma::vec& lambda) {
<<<<<<< HEAD
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
=======
  int n = data.n_rows;
  int d = data.n_cols;

  if (lambda.n_elem != d) {
    stop("Length of lambda must equal number of columns in data");
  }

  double total_ll = 0.0;

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < d; j++) {
      if (R_IsNA(data(i, j))) continue;
      double x = data(i, j);
      double lam = lambda(j);
>>>>>>> f1bc9dbc6ff6d4895791766c65ddbe29c6d8a016
      total_ll += x * std::log(lam) - lam - lgamma(x + 1.0);
    }
  }

<<<<<<< HEAD
  // If total_ll got poisoned
  if (!std::isfinite(total_ll)) return NA_REAL;
=======
>>>>>>> f1bc9dbc6ff6d4895791766c65ddbe29c6d8a016
  return total_ll;
}
