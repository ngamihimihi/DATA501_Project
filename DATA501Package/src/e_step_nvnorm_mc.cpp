#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::export]]
List e_step_nvnorm_mc(const arma::mat& data,
                      const arma::vec& mu ,
                      const arma::mat& Sigma,
                      const int m
                      ) {

  arma::mat imputed = data;
 return List::create(_["imputed"]=imputed);
}


