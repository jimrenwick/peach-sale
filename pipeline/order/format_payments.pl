#!/usr/bin/perl

use Getopt::Long;

GetOptions( 'd' => \my $debug );

sub dp (@) { print STDERR "@_.\n" if $debug }

# header
print join($ENV{DELIMITER}, ("student_name", "amount_collected")), "\n";


my $stop_now = 0;
# body
while (<>) {
  last if $stop_now;
  $stop_now = 1 if /^Zhang/;
  chomp;
  my @fields = split /\Q$ENV{DELIMITER}\E/o, $_;
  my @row = @fields[0..1];
  my $total = 0;
  dp "r: @row   f: @fields";
  foreach my $f (@fields[2..@fields]) {
    if ($f ne '') {
      $f =~ s/\$//;
      $total += $f;
    }
  }
  print join($ENV{DELIMITER}, ("$row[1] $row[0]", $total)), "\n";
}

