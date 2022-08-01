#' Get currency rates
#'
#' @param date_begin start date
#' @param date_end end date
#' @param currency currency name
#' @param merchant_login Merchant's unique identifier.
#' @param merchant_secret_key Merchant's secret key
#' @param api_version protocol version. Default value: 1
#'
#' @return tibble with currency rates
#' @export
#'
wfp_get_currency_rates <- function(
  date_begin = Sys.Date() - 10,
  date_end   = Sys.Date() - 1,
  currency   = NULL,
  merchant_login = wfp_get_merchant_login(),
  merchant_secret_key = wfp_get_secret_key(),
  api_version = 1
) {

  period <- seq.Date(date_begin, date_end, by = 'day')

  rates <- purrr::map_dfr(
    period,
    wfp_get_currency_rates_to_date,
    currency = currency,
    merchant_login = merchant_login,
    merchant_secret_key = merchant_secret_key,
    api_version = api_version)

  return(rates)

}


# helper function ---------------------------------------------------------
wfp_get_currency_rates_to_date <- function(
  date,
  currency = NULL,
  merchant_login = wfp_get_merchant_login(),
  merchant_secret_key = wfp_get_secret_key(),
  api_version = 1
) {

  date <- date %>%
          as.POSIXct() %>%
          as.numeric() %>%
          round(0)

  merchant_signature <- paste(merchant_login, date, sep = ';') %>%
                        md5(merchant_secret_key) %>%
                        iconv(from = '1251', to = 'UTF-8') %>%
                        as.character()

  resp <- request("https://api.wayforpay.com/api") %>%
    req_body_json(list(
      transactionType = 'CURRENCY_RATES',
      merchantAccount = merchant_login,
      merchantSignature = merchant_signature,
      apiVersion = api_version,
      orderDate = date,
      currency = currency
    )
    ) %>%
    req_error(is_error = wfp_is_error, body = wfp_error_body) %>%
    req_perform()

  currency_rates <- resp %>%
    resp_body_string() %>%
    fromJSON()

  tibble(rates = list(currency_rates)) %>%
    unnest_wider(rates) %>%
    unnest_wider(rates) %>%
    select(-reasonCode, -reason) %>%
    mutate(ratesDate = as.POSIXct(ratesDate, origin = '1970-01-01', tz = 'Europe/Kiev'))

}
