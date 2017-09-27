#!/bin/bash

data=data/peach_sales-2017-09-12_21-03.csv.orig
payments=data/peach_sales-payments-2017-09-12_21-03.csv.orig
export DELIMITER=$(tochar 0xfe)

keys=(student_name timestamp customer_name email payment_status)
vals=(quantity)

keys_s="$(echo ${keys[@]} | tr ' ' ,)"
vals_s="$(echo ${vals[@]} | tr ' ' ,)"

set -e
grepfield -F student_name -v '^$' $data |
  grepfield -F product_name -v 'Conventional Palisade Peaches' |
  grepfield -F product_name -v 'Conventional Pears' |
  grepfield -F product_name -v 'Donation Only' |
  grepfield -F product_name -v 'Organic Peaches' |
  reorder -F "$keys_s,product_name,$vals_s" |
  (read h; echo "$h"; sort -t$DELIMITER -k1,1) |
  pivot -F $keys_s -P product_name -A $vals_s |
  ./add_student_totals.pl -p $payments
  # |
  # mergekeys -A student_name -B student_name -l -D 0 \
  #   - $payments

