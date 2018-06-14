#!/bin/bash
#pwd
#while inotifywait -e close_write *.rst; do make html ; done
while inotifywait -e close_write *; do make html ; done
