#!/bin/bash
coffee -cw -o public/javascripts reader | jade -w -o public/templates reader
