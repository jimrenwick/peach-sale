#!/usr/bin/perl

use Getopt::Long;

GetOptions( 'd' => \my $debug, 'f=s' => \my $file );

my @products = (1, 3, 5, 6, 8);

print <<EOF;
[PRODUCT_OPTIONS]
!PRODUCTCODE;!CLASS;!TYPE;!OPTION;!PRICE_MODIFIER;!MODIFIER_TYPE
EOF

my @roster = `sort $file`;
foreach my $product (@products) {
    print "$product;Student Name;Y;Pick a Student;0;\n";
    foreach my $name (@roster) {
        chomp $name;
        print ";;;$name;0;\n";
    }
}

