#!/usr/bin/env python

from datetime import datetime
from entity import Period, Rate, Response
from json import dumps
from re import findall
from sys import stdin, stdout
from xml.etree import ElementTree

tree = ElementTree.parse(stdin)
root = tree.getroot()

matches = findall(r'\d{2}/\w{3}/\d{4}', root.get('Period'))
response = Response('GBP')
response.set_period(Period(
  datetime.strptime(matches[0], '%d/%b/%Y').strftime('%Y-%m-%d'),
  datetime.strptime(matches[1], '%d/%b/%Y').strftime('%Y-%m-%d')
))

for exchange_rate in root.iter('exchangeRate'):
    code = exchange_rate.find('currencyCode').text
    rate = exchange_rate.find('rateNew').text
    response.add_rate(Rate(code, rate))

stdout.write(
    dumps(response, default=lambda o: o.__dict__, indent=2, sort_keys=True)
)
