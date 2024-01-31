# -*- encoding: utf-8 -*-
# pylint: disable=invalid-name
"""Gunicorn configuration file."""

bind = "0.0.0.0:5005"
workers = 1
accesslog = "-"
loglevel = "debug"
capture_output = True
enable_stdio_inheritance = True
