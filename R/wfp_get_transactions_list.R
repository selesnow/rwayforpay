#' Get transactions list
#'
#' @param date_begin Period start date
#' @param date_end Period end date
#' @param merchant_login Merchant's unique identifier.
#' @param merchant_secret_key Merchant's secret key
#' @param api_version Protocol version. 2 - enable the transmission of extended data in the response - additional fields, delivery, comments.
#'
#' @return data.frame with transactions
#' @seealso See [documentation](https://wiki.wayforpay.com/en/view/1736786)
#' @export
#'
wfp_get_transactions_list <- function(
  date_begin = Sys.Date() - 30,
  date_end = Sys.Date() - 1,
  merchant_login = wfp_get_merchant_login(),
  merchant_secret_key = wfp_get_secret_key(),
  api_version = 2
) {

  start <- as.POSIXct(date_begin) %>% as.numeric() %>% round(0)
  end   <- as.POSIXct(date_end) %>% as.numeric() %>% round(0)
  merchant_signature <- paste(merchant_login, start, end, sep = ';') %>%
                        md5(merchant_secret_key) %>%
                        iconv(from = '1251', to = 'UTF-8') %>%
                        as.character()

  resp <- request("https://api.wayforpay.com/api") %>%
    req_body_json(list(
      transactionType = 'TRANSACTION_LIST',
      merchantAccount = merchant_login,
      merchantSignature = merchant_signature,
      apiVersion = api_version,
      dateBegin = start,
      dateEnd = end
      )
    ) %>%
    req_error(is_error = wfp_is_error, body = wfp_error_body) %>%
    req_perform()

  transactions <- resp %>%
    resp_body_string() %>%
    fromJSON() %>%
    .[['transactionList']] %>%
    unnest_wider(products)

  return(transactions)

}
