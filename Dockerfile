FROM circleci/python:latest

MAINTAINER Mathias Schilling <m@matchilling.com>

ENV APP_PATH /home/circleci/project

WORKDIR $APP_PATH