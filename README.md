<!--
*** ----------------------------------------------------------------
*** NOTE: THIS IS AN AUTO-GENERATED FILE. DO NOT MODIFY IT DIRECTLY.
*** ----------------------------------------------------------------
-->

# 🇬🇧 HMRC Exchange Rates API for Customs & VAT [![Update Rates Cron Job](https://github.com/matchilling/hmrc-exchange-rates/actions/workflows/update_rates_cron_job.yml/badge.svg)](https://github.com/matchilling/hmrc-exchange-rates/actions/workflows/update_rates_cron_job.yml)
Find foreign exchange rates issued by [His Majesty's Revenue and Customs][hmrc-url]
in JSON format from __Jan 2015__ till __Mar 2024__.

__Last update: Mon Mar 18 03:06:18 UTC 2024__

## Usage

```sh
# Get the latest rates
$ curl -X GET https://hmrc.matchilling.com/rate/latest.json
{
  "base": "GBP",
  "period": {
    "start": "2020-01-01",
    "end": "2020-01-31"
  },
  "rates": {
    "AED": "4.8012",
    "ALL": "143.53",
    "AMD": "624.19",
    "AOA": "598.72",
    "ARS": "78.18",
    "AUD": "1.905",
    ...
  }
}

# Get rates by month (e.g. March 2020)
$ curl -X GET https://hmrc.matchilling.com/rate/2020/03.json
```

## 💷 Details

You should use these exchanges rates if you have to convert any foreign currency to sterling for customs and VAT purposes.

The EU rate includes the following countries:

- Austria
- Belgium
- Cyprus
- Estonia
- Finland
- France
- Germany
- Greece
- Ireland
- Italy
- Latvia
- Lithuania
- Luxembourg
- Malta
- Netherlands
- Portugal
- Slovakia
- Slovenia
- Spain

You should only use the EU rate for conversion of invoices drawn in the euro. Do not confuse it with the euro rate
published for agricultural levy purposes or the bit error rate (BER) daily rate set to help payment of taxes in the euro.

## 🛠 CSV and XML converter

HMRC publishes new monthly exchange rates in [CSV][hmrc-url] and [XML][hmrc-url] format on its website during
the last week of the month. The CSV version is usually a few days before the XML one available.

Unfortunately only the XML version can be retrieved programmatically as the URI to CSV contains a unique file descriptor
which obviously can not be predicted. Therefore the XML converter is being used by default.

However, you can always manually add new rates to this repository using [this CSV converter](./script/converter/from_csv.sh).

```sh
$ curl --silent https://www.trade-tariff.service.gov.uk/api/v2/exchange_rates/files/monthly_csv_2023-11.csv | \
    ./script/converter/from_csv.sh \
    > rate/2023/11.json
```

<!-- MARKDOWN LINKS -->
[hmrc-url]: https://www.trade-tariff.service.gov.uk/exchange_rates
