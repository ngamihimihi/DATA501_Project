#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// log N(x; mu, Sigma) for a single vector x
static double log_mvn_row(const arma::vec& x,
                          const arma::vec& mu,
                          const arma::mat& Sigma) {
  const int d = x.n_elem;

  arma::mat Sigma_sym = 0.5 * (Sigma + Sigma.t());
  arma::mat Sigma_reg = Sigma_sym + 1e-6 * arma::eye(d, d);

  double sign = 0.0, logdet_val = 0.0;
  log_det(logdet_val, sign, Sigma_reg);
  if (sign <= 0.0 || !std::isfinite(logdet_val)) {
    return -std::numeric_limits<double>::infinity();
  }

  arma::vec diff = x - mu;
  double quad = as_scalar(diff.t() * inv_sympd(Sigma_reg) * diff);

  return -0.5 * (d * std::log(2.0 * M_PI) + logdet_val + quad);
}

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
Rcpp::List e_step_nvnorm_mcem(const arma::mat& data,
                            const arma::vec& mu,
                            const arma::mat& Sigma,
                            const int m,      // kept samples
                            const int burn,   // burn-in iters
                            const int thin,   // thinning
                            const double tau  // proposal scale
) {
  const int n = data.n_rows;
  const int d = data.n_cols;

  arma::mat imputed = data;
  arma::vec acc_rate(n, arma::fill::zeros);

  for (int i = 0; i < n; ++i) {

    // --- indices
    std::vector<uword> obs_idx, miss_idx;
    obs_idx.reserve(d); miss_idx.reserve(d);
    for (uword j = 0; j < (uword)d; ++j) {
      if (R_IsNA(data(i, j))) miss_idx.push_back(j);
      else                    obs_idx.push_back(j);
    }
    const int k = static_cast<int>(miss_idx.size());
    if (k == 0) { // no missing
      imputed.row(i) = data.row(i);
      acc_rate(i) = NA_REAL;
      continue;
    }

    // --- partition mu
    arma::vec mu_o(obs_idx.size()), mu_m(miss_idx.size());
    for (size_t t = 0; t < obs_idx.size(); ++t)  mu_o(t) = mu(obs_idx[t]);
    for (size_t t = 0; t < miss_idx.size(); ++t) mu_m(t) = mu(miss_idx[t]);

    // observed values
    arma::vec x_obs(obs_idx.size());
    for (size_t t = 0; t < obs_idx.size(); ++t)  x_obs(t) = data(i, obs_idx[t]);

    // --- partition Sigma
    arma::mat sigma_oo(obs_idx.size(),  obs_idx.size());
    arma::mat sigma_mo(miss_idx.size(), obs_idx.size());
    arma::mat sigma_mm(miss_idx.size(), miss_idx.size());

    for (size_t r = 0; r < obs_idx.size(); ++r)
      for (size_t c = 0; c < obs_idx.size(); ++c)
        sigma_oo(r, c) = Sigma(obs_idx[r], obs_idx[c]);

    for (size_t r = 0; r < miss_idx.size(); ++r)
      for (size_t c = 0; c < obs_idx.size(); ++c)
        sigma_mo(r, c) = Sigma(miss_idx[r], obs_idx[c]);

    for (size_t r = 0; r < miss_idx.size(); ++r)
      for (size_t c = 0; c < miss_idx.size(); ++c)
        sigma_mm(r, c) = Sigma(miss_idx[r], miss_idx[c]);

    // --- initial state u0 = mu_m + Sigma_mo * Sigma_oo^{-1} * (x_o - mu_o)
    arma::vec diff = x_obs - mu_o;
    arma::vec correction = solve(sigma_oo, diff);          // Sigma_oo^{-1} * (x_o - mu_o)
    arma::vec adjustment = sigma_mo * correction;          // map to missing space
    arma::vec u_curr = mu_m + adjustment;

    // build full current row
    arma::vec full_curr = arma::conv_to<arma::vec>::from(data.row(i).t());
    for (int t = 0; t < k; ++t) full_curr(miss_idx[t]) = u_curr(t);

    double ll_curr = log_mvn_row(full_curr, mu, Sigma);

    // --- MH loop
    const int n_draws = burn + m * thin;
    arma::vec mc_mean(k, arma::fill::zeros);
    int kept = 0, accepts = 0, total = 0;

    for (int it = 0; it < n_draws; ++it) {
      total++;

      // propose
      arma::vec u_prop = u_curr + tau * arma::randn<arma::vec>(k);
      arma::vec full_prop = full_curr;
      for (int t = 0; t < k; ++t) full_prop(miss_idx[t]) = u_prop(t);

      double ll_prop = log_mvn_row(full_prop, mu, Sigma);
      double log_alpha = std::min(0.0, ll_prop - ll_curr);

      if (std::log(unif_rand()) < log_alpha) {
        u_curr = u_prop;
        full_curr = full_prop;
        ll_curr = ll_prop;
        accepts++;
      }

      // keep sample (after burn-in + thinning)
      if (it >= burn && ((it - burn) % thin == 0)) {
        kept++;
        mc_mean += (u_curr - mc_mean) / static_cast<double>(kept);
      }
    }

    // impute with MC mean
    for (int t = 0; t < k; ++t) imputed(i, miss_idx[t]) = mc_mean(t);
    acc_rate(i) = (total > 0) ? static_cast<double>(accepts) / total : NA_REAL;
  }

  return Rcpp::List::create(_["imputed"]=imputed, _["accept_rate"]=acc_rate);

}

