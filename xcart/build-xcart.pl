#!/usr/bin/perl

my @products = (500, 510, 600, 610, 700, 710, 800, 810);

print <<EOF;
[PRODUCT_OPTIONS]
!PRODUCTCODE;!CLASS;!TYPE;!OPTION;!PRICE_MODIFIER;!MODIFIER_TYPE
EOF

my @roster = `sort ./formatted-roster.csv`;
foreach my $product (@products) {
    print "$product;Student Name;Y;Pick a Student;0;\n";
    foreach my $name (@roster) {
        chomp $name;
        print ";;;$name;0;\n";
    }
}

