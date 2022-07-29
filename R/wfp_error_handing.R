wfp_error_body <- function(resp) {
  resp %>% resp_body_string() %>% fromJSON() %>% .$reason
}

wfp_is_error <- function(resp) {
  resp_stat <- resp %>% resp_body_string() %>% fromJSON() %>% names()
  "reasonCode" %in% resp_stat
}
