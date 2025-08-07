#!/bin/bash
set -e

export CFG_FILE=$PUT/coverage/coverage.json

$OUT/dummy-fuzzer -i $CORPUS -o $OUT/findings\
 -j 0 -c edge,pfp -u edge,pfp -- $OUT/pdftotext @@ $OUT/output