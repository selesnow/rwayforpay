
# rwayforpay

<!-- badges: start -->
<!-- badges: end -->

R пакет для запроса списка транзакций из [API Получения Списка транзакций](https://wiki.wayforpay.com/ru/view/1736786) WayForPay.

## Установка

You can install the development version of rwayforpay from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("selesnow/rwayforpay")
```

## Пример

``` r
library(rwayforpay)
wfp_set_merchant_login("MERCHANT LOGIN")
wfp_set_secret_key("MERCHANT SECRET KEY")

# запрос списка транзакций
transactions <- wfp_get_transactions_list(date_begin = "2022-01-01", date_end = "2022-01-31")
```

