#!/usr/bin/perl

use Data::Dumper;
use DART::HeaderIndexedStream;
use Getopt::Long;
GetOptions( 'd' => \my $debug, 'p=s' => \my $payment_file );
sub dp (@) { print STDERR "@_.\n" if $debug }


my $h = new DART::HeaderIndexedStream;

my $num_keys = 6;

sub getTotalsArray {
  return ( ('') x $num_keys, (0) x 8 );
}

sub emit {
  my ($ralines, $ratotals) = @_;
  my @lines = @$ralines;
  my @totals = @$ratotals;
  
  dp "emit : ", Dumper(\@lines), Dumper(\@totals);
  for (my $i = 0; $i < scalar @lines; $i++) {
    print $lines[$i] . $ENV{DELIMITER} . "\n";
  }
  print join($ENV{DELIMITER}, @totals), "\n";
  print join($ENV{DELIMITER}, ('') x scalar(@totals)), "\n";
  dp "exit emit";
}


# header
print $h->getRawHeader(), "\n";

my $email = '';
my @lines = ();
my @totals = getTotalsArray();

# body
while (my @line = @{$h->next}) {
  dp "s: " . $h->email . " L :  @line";
  if ($email ne $h->email && @lines) {
    emit(\@lines, \@totals);
    @lines = ();
    @totals = getTotalsArray();
  }
  $email = $h->email;
  push @lines, $h->getRawLine;
  for (my $i = $num_keys; $i < scalar @totals; $i++) {
    $totals[$i] += $line[$i];
  }
}
emit(\@lines, \@totals);

