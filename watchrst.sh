#!/bin/bash
#pwd
#watch `cat ui/css/style.less` --exec 'lessc ui/css/style.less ui/css/style.css'
while inotifywait -e close_write *.rst; do make html ; done
