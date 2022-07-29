wfp_error_body <- function(resp) {
  reason <- resp %>% resp_body_string() %>% fromJSON() %>% .$reason
  paste0(reason, ', for more details see https://wiki.wayforpay.com/ru/view/852131')
}

wfp_is_error <- function(resp) {
  resp_code <- resp %>% resp_body_string() %>% fromJSON() %>% .$reasonCode
  resp_code != 1100
}
