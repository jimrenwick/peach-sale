#!/usr/bin/perl

use Data::Dumper;
use DART::HeaderIndexedStream;
use Getopt::Long;
GetOptions( 'd' => \my $debug, 'p=s' => \my $payment_file );
sub dp (@) { print STDERR "@_.\n" if $debug }


my $h = new DART::HeaderIndexedStream;
my %p;
open(my $pfh, '<', $payment_file) || die "Can;t open file: $payment_file";
while (my $l = <$pfh>) {
  chomp($l);
  my @f = split /\Q$ENV{DELIMITER}\E/o, $l;
  $p{$f[0]} = $f[3];  # remaining_due
}
close($pfh);
dp Dumper(\%p);


# 1-5
# 6-14  (6-10)  (6-8)

sub getTotalsArray {
  return ( ('') x 5, (0) x 2 );
}

sub emit {
  my ($ralines, $ratotals, $rhp, $student_name) = @_;
  my @lines = @$ralines;
  my @totals = @$ratotals;
  my %p = %$rhp;
  
  dp "emit : ", Dumper(\@lines), Dumper(\@totals), Dumper(\%p);
  for (my $i = 0; $i < scalar @lines; $i++) {
    print $lines[$i] . $ENV{DELIMITER} . "\n";
  }
  print join($ENV{DELIMITER}, 
             (@totals, exists $p{$student_name} ? $p{$student_name} : 0)), "\n";
  print join($ENV{DELIMITER}, ('') x scalar(@totals)), "\n";
  dp "exit emit";
}


# header
print join($h->delim,
           ($h->getRawHeader(),
            qw(total_remaining_due))), "\n";

my $student_name = '';
my @lines = ();
my @totals = getTotalsArray();
my $num_key_fields = 5;

# body
while (my @line = @{$h->next}) {
  dp "s: " . $h->student_name . " L :  @line";
  if ($student_name ne $h->student_name && @lines) {
    emit(\@lines, \@totals, \%p, $student_name);
    dp "After emit: ", Dumper(\@lines);
    @lines = ();
    @totals = getTotalsArray();
  }
  $student_name = $h->student_name;
  push @lines, $h->getRawLine;
  for (my $i = 5; $i < 7; $i++) {
    $totals[$i] += $line[$i];
  }
}
emit(\@lines, \@totals, \%p, $student_name);

