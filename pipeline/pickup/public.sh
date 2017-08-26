#!/bin/bash

data=data/peach_sales-2017-08-25_06-32.csv.orig
payments=data/peach_sales-payments-2017-08-25_06-32.csv.orig
export DELIMITER=$(tochar 0xfe)

keys=(email customer_name payment_status order_total telephone note_for_staff)
vals=(quantity)

keys_s="$(echo ${keys[@]} | tr ' ' ,)"
vals_s="$(echo ${vals[@]} | tr ' ' ,)"

set -e
grepfield -F student_name '^$' $data |
  reorder -F "$keys_s,product_name,$vals_s" |
  (read h; echo "$h"; sort -t$DELIMITER -k1,1) |
  pivot -F $keys_s -P product_name -A $vals_s |
  reorder -f 1-5,7-14,6 |
  (read h; echo "$h"; sort -t$DELIMITER -k2,2)

#   ./add_public_totals.pl  |
     
   # |
  # mergekeys -A student_name -B student_name -l -D 0 \
  #   - $payments

