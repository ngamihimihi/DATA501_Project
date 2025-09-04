#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
Rcpp::List m_step_estimate(const arma::mat& imputed_data) {
  int n = imputed_data.n_rows;

  // Compute new mean
  arma::rowvec mu_new = arma::mean(imputed_data, 0);  // mean across rows

  // Center the data
  arma::mat centered = imputed_data.each_row() - mu_new;

  // Compute covariance
  arma::mat Sigma_new = (centered.t() * centered) / n;

  return Rcpp::List::create(
    Rcpp::Named("mu") = mu_new.t(),  // return as column vector
    Rcpp::Named("Sigma") = Sigma_new
  );
}

