#' Set Merchant Secret Key
#'
#' @param secret_key merchant secret key
#'
#' @return not return value, use for set environment variable WFP_SECRET_KEY
#' @export
#'
wfp_set_secret_key <- function(
    secret_key
) {
  Sys.setenv('WFP_SECRET_KEY'= secret_key)
}

#' Get Merchant Secret Key
#'
#' @return character, merchant secret key
#' @export
#'
wfp_get_secret_key <- function() {
  Sys.getenv('WFP_SECRET_KEY')
}

#' Set Merchant Login
#'
#' @param merchant_login merchant login
#'
#' @return not return value, use for set environment variable WFP_MERCHANT_LOGIN
#' @export
#'
wfp_set_merchant_login <- function(
    merchant_login
) {
  Sys.setenv('WFP_MERCHANT_LOGIN'= merchant_login)
}

#' Set Merchant Login
#'
#' @return character, merchant login
#' @export
#'
wfp_get_merchant_login <- function() {
  Sys.getenv('WFP_MERCHANT_LOGIN')
}
