#!/usr/bin/env python

from datetime import datetime
from json import dumps
from re import findall
from sys import stdin
from xml.etree import ElementTree


class Period(object):
    def __init__(self, start, end):
        self.start = start
        self.end = end


class Rate(object):
    def __init__(self, currency, value):
        self.currency = currency
        self.value = value


class Response(object):
    def __init__(self, base, period):
        self.base = base
        self.period = period
        self.rates = {}

    def add_rate(self, rate):
        self.rates[rate.currency] = rate.value


tree = ElementTree.parse(stdin)
root = tree.getroot()

matches = findall(r'\d{2}/\w{3}/\d{4}', root.get('Period'))
response = Response(
    'GBP',
    Period(
        datetime.strptime(matches[0], '%d/%b/%Y').strftime('%Y-%m-%d'),
        datetime.strptime(matches[1], '%d/%b/%Y').strftime('%Y-%m-%d')
    )
)

for exchange_rate in root.iter('exchangeRate'):
    code = exchange_rate.find('currencyCode').text
    rate = exchange_rate.find('rateNew').text
    response.add_rate(Rate(code, rate))

print dumps(
    response,
    default=lambda o: o.__dict__,
    indent=2,
    sort_keys=True
)
