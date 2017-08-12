#!/usr/bin/perl

use DART::HeaderIndexedStream;
use Getopt::Long;

GetOptions( 'd' => \my $debug );

sub dp (@) { print STDERR "@_.\n" if $debug }

my $h = new DART::HeaderIndexedStream;

# header
print join($h->delim,
           $h->getRawHeader,
           qw(customer_name telephone address)
          ), "\n";

# body
while ($h->next) {
  my %results = ();
  my @fields = split("<br>", $h->order_comments);
  foreach my $f (@fields) {
    my ($k, $v) = split /:{2}/, $f;
    $results{$k} = $v;
  }

  print join($h->delim, (
                 $h->getRawLine,
                 $results{'Customer Name'},
                 $results{'Telephone Number'},
                 $results{'Address'})), "\n";
}

