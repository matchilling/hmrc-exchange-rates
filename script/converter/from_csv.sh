#!/usr/bin/env python

from datetime import datetime
from entity import Period, Rate, Response
from json import dumps
from sys import stdin, stdout
from csv import reader

csv_reader = reader(iter(stdin.readline, ''))
response = Response('GBP')

# Skip 1st row (csv header)
next(csv_reader)

for row in csv_reader:
    if response.period is None:
        period = Period(
            datetime.strptime(row[4], '%d/%m/%Y').strftime('%Y-%m-%d'),
            datetime.strptime(row[5], '%d/%m/%Y').strftime('%Y-%m-%d')
        )
        response.set_period(period)
    else:
        code = row[2]
        rate = row[3]
        response.add_rate(Rate(code, rate))

stdout.write(
    dumps(response, default=lambda o: o.__dict__, indent=2, sort_keys=True)
)
