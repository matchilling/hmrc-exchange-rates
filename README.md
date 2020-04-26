<!--
*** ----------------------------------------------------------------
*** NOTE: THIS IS AN AUTO-GENERATED FILE. DO NOT MODIFY IT DIRECTLY.
*** ----------------------------------------------------------------
-->

# 🇬🇧 HMRC Exchange Rates API for Customs & VAT [![CircleCI](https://circleci.com/gh/matchilling/hmrc-exchange-rates.svg?style=svg)](https://circleci.com/gh/matchilling/hmrc-exchange-rates)

Find foreign exchange rates issued by [Her Majesty's Revenue and Customs][hmrc-url]
in JSON format from __Jan 2015__ till __Apr 2020__.

__Last update: Sun Apr 26 00:08:06 UTC 2020__

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

HMRC publishes new monthly exchange rates in [CSV][hmrc-csv-rates] and [XML][hmrc-xml-rates] format on its website during
the last week of the month. The CSV version is usually a few days before the XML one available.

Unfortunately only the XML version can be retrieved programmatically as the URI to CSV contains a unique file descriptor
which obviously can not be predicted. Therefore the XML converter is being used by default.

However, you can always manually add new rates to this repository using [this CSV converter](./script/converter/from_csv.sh).

```sh
$ curl --silent https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/874383/exrates-monthly-0420.csv | \
    ./script/converter/from_csv.sh \
    > rate/2020/04.json
```

<!-- MARKDOWN LINKS -->
[hmrc-url]: https://www.gov.uk/government/organisations/hm-revenue-customs
[hmrc-csv-rates]: https://www.gov.uk/government/publications/hmrc-exchange-rates-for-2020-monthly
[hmrc-xml-rates]: http://www.hmrc.gov.uk/softwaredevelopers/2020-exrates.html
