#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::List e_step_mixture_em(
    const arma::mat& X,
    const arma::mat& mu,
    const Rcpp::List& Sigma_list,
    const arma::vec& pi
) {
  int N = X.n_rows;
  int K = mu.n_rows;
  int d = X.n_cols;

  arma::mat gamma(N, K, fill::zeros);
  arma::mat X_imputed = X;
  arma::vec denom(N, fill::zeros);

  // ---------- E-step ----------
  for (int k = 0; k < K; k++) {
    arma::mat Sigma = Sigma_list[k];
    arma::mat Sigma_inv = inv(Sigma);
    double detSigma = det(Sigma);
    double norm_const = 1.0 / std::pow(2.0 * M_PI, d / 2.0) / std::sqrt(detSigma);

    for (int n = 0; n < N; n++) {
      arma::rowvec x = X.row(n);
      arma::uvec obs_idx = find_finite(x); // observed indices
      arma::rowvec x_obs = x.elem(obs_idx);
      arma::rowvec mu_obs = arma::rowvec(mu.row(k)).elem(obs_idx);
      arma::mat Sigma_obs = Sigma.submat(obs_idx, obs_idx);

      // compute pdf on observed dimensions only
      arma::mat Sigma_obs_inv = inv(Sigma_obs);
      double detSigma_obs = det(Sigma_obs);
      double norm_obs = 1.0 / std::pow(2.0 * M_PI, obs_idx.n_elem / 2.0) / std::sqrt(detSigma_obs);

      arma::rowvec diff = x_obs - mu_obs;
      double exponent = -0.5 * as_scalar(diff * Sigma_obs_inv * diff.t());
      double pdf = norm_obs * std::exp(exponent);

      gamma(n, k) = pi(k) * pdf;
      denom(n) += gamma(n, k);
    }
  }

  // normalize responsibilities
  for (int n = 0; n < N; n++) {
    gamma.row(n) /= denom(n);
  }

  // ---------- Imputation ----------
  for (int n = 0; n < N; n++) {
    arma::rowvec x = X.row(n);
    arma::uvec miss_idx = find_nonfinite(x);
    if (!miss_idx.is_empty()) {
      arma::rowvec weighted_mu = arma::zeros<arma::rowvec>(d);
      for (int k = 0; k < K; k++) {
        weighted_mu += gamma(n, k) * mu.row(k);
      }
      arma::rowvec temp = X_imputed.row(n);
      temp.elem(miss_idx) = weighted_mu.elem(miss_idx);
      X_imputed.row(n) = temp;
    }
  }

  return Rcpp::List::create(
    Named("gamma") = gamma,
    Named("X_imputed") = X_imputed
  );
}
