class Period(object):
    def __init__(self, start, end):
        self.start = start
        self.end = end


class Rate(object):
    def __init__(self, currency, value):
        self.currency = currency
        self.value = value


class Response(object):
    def __init__(self, base):
        self.base = base
        self.period = None
        self.rates = {}

    def add_rate(self, rate):
        self.rates[rate.currency] = rate.value

    def set_period(self, period):
        self.period = period