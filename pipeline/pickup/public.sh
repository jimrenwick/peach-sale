#!/bin/bash

data=data/peach_sales-2017-09-12_21-03.csv.orig
payments=data/peach_sales-payments-2017-09-12_21-03.csv.orig
export DELIMITER=$(tochar 0xfe)

keys=(email customer_name payment_status order_total telephone note_for_staff)
vals=(quantity)

keys_s="$(echo ${keys[@]} | tr ' ' ,)"
vals_s="$(echo ${vals[@]} | tr ' ' ,)"

set -e
grepfield -F student_name '^$' $data |
  grepfield -F product_name -v '^$' |
  grepfield -F product_name -v 'Conventional Palisade Peaches' |
  grepfield -F product_name -v 'Conventional Pears' |
  grepfield -F product_name -v 'Donation Only' |
  grepfield -F product_name -v 'Organic Peaches' |
  reorder -F "$keys_s,product_name,$vals_s" |
  (read h; echo "$h"; sort -t$DELIMITER -k1,1) |
  pivot -F $keys_s -P product_name -A $vals_s |
  reorder -f 1-5,7-8,6 |
  (read h; echo "$h"; sort -t$DELIMITER -k2,2)

#   ./add_public_totals.pl  |
     
   # |
  # mergekeys -A student_name -B student_name -l -D 0 \
  #   - $payments

