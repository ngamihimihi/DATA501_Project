#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends( )]]

// [[Rcpp::export]]
arma::mat e_step_general_impute(const arma::mat& data,
                                const arma::vec& mu,
                                const arma::mat& Sigma) {
  int n = data.n_rows;
  int d = data.n_cols;
  arma::mat imputed = data;

  for (int i = 0; i < n; ++i) {
    // Identify missing and observed indices
    std::vector<int> obs_idx, miss_idx;
    for (int j = 0; j < d; ++j) {
      if (R_IsNA(data(i, j))) {
        miss_idx.push_back(j);
      } else {
        obs_idx.push_back(j);
      }
    }

    // Skip if no missing
    if (miss_idx.size() == 0) continue;

    // Partition means
    arma::vec mu_obs(obs_idx.size()), mu_miss(miss_idx.size());
    for (size_t k = 0; k < obs_idx.size(); ++k) mu_obs(k) = mu(obs_idx[k]);
    for (size_t k = 0; k < miss_idx.size(); ++k) mu_miss(k) = mu(miss_idx[k]);

    // Partition observed values
    arma::vec x_obs(obs_idx.size());
    for (size_t k = 0; k < obs_idx.size(); ++k) x_obs(k) = data(i, obs_idx[k]);

    // Partition covariance matrix
    arma::mat Sigma_oo(obs_idx.size(), obs_idx.size());
    arma::mat Sigma_mo(miss_idx.size(), obs_idx.size());
    for (size_t r = 0; r < miss_idx.size(); ++r) {
      for (size_t c = 0; c < obs_idx.size(); ++c) {
        Sigma_mo(r, c) = Sigma(miss_idx[r], obs_idx[c]);
      }
    }
    for (size_t r = 0; r < obs_idx.size(); ++r) {
      for (size_t c = 0; c < obs_idx.size(); ++c) {
        Sigma_oo(r, c) = Sigma(obs_idx[r], obs_idx[c]);
      }
    }

    // Compute conditional mean
    arma::vec cond_mean = mu_miss + Sigma_mo * inv(Sigma_oo) * (x_obs - mu_obs);

    // Fill missing values
    for (size_t k = 0; k < miss_idx.size(); ++k) {
      imputed(i, miss_idx[k]) = cond_mean(k);
    }
  }

  return imputed;
}
