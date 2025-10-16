#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
double log_likelihood_poisson(const arma::mat& data, const arma::vec& lambda) {
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
      total_ll += x * std::log(lam) - lam - lgamma(x + 1.0);
    }
  }

  return total_ll;
}
