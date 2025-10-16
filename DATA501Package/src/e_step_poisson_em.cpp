#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat e_step_poisson_em(const arma::mat& data,
                            const arma::vec& lambda) {
  int n = data.n_rows;
  int d = data.n_cols;
  arma::mat imputed = data;

  for (int i = 0; i < n; ++i) {
    std::vector<int> miss_idx;

    // Identify missing indices
    for (int j = 0; j < d; ++j) {
      if (R_IsNA(data(i, j))) {
        miss_idx.push_back(j);
      }
    }

    // Skip if no missing values in this row
    if (miss_idx.empty()) continue;

    // Fill missing values with corresponding λ
    for (size_t k = 0; k < miss_idx.size(); ++k) {
      imputed(i, miss_idx[k]) = lambda(miss_idx[k]);
    }
  }

  return imputed;
}
