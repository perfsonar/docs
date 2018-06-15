#!/bin/bash
#pwd
#while inotifywait -e close_write *.rst; do make html ; done
make html
while inotifywait -e close_write *; do make html ; done
