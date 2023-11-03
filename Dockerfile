FROM ubuntu:20.04

MAINTAINER Mathias Schilling <m@matchilling.com>

RUN apt update
RUN apt --assume-yes install curl
RUN apt --assume-yes install python3

ENV APP_PATH /app

WORKDIR $APP_PATH