#!/usr/bin/perl

use Data::Dumper;
use Getopt::Long;
use Text::CSV;

GetOptions(
    'd' => \my $debug,
    'file=s' => \my $file
);

sub dp (@) { print STDERR "@_.\n" if $debug }
sub norm { my ($k, $v) = @_; $k = lc $k; $k =~ s/\s/_/g; return ($k, $v) }

my $options_idx = 7;
my @extra_headers = qw(student_last_name student_first_name food_allergies_or_restrictions  payment_method);

my %defaults = (
    student_last_name => '',
    student_first_name => '',
    food_allergies_or_restrictions => '',
    payment_method => ''
    );

my $csv = Text::CSV->new ({ binary => 1 });
$csv->sep(chr(0x09));
open my $io, "<", $file or die "$file: $!";

my $header = $csv->getline ($io);
push(@$header, qw(student_last_name student_first_name food inc_payment_method));
splice @$header, $options_idx, 1;
$csv->print(*STDOUT, $header);
print "\n";

while (my $row = $csv->getline ($io)) {
    my @fields = @$row;
    $fields[9] =~ s/,//g;
    my @options = split /\n/, $fields[$options_idx];
    my %seen = (%defaults);
    for (my $i = 0; $i < scalar @options; $i++) {
        %seen = (%seen, norm(split /:/, $options[$i]));
    }
    my %options = (%defaults, %seen);
    print STDERR Dumper(\%options, \%defaults, \%seen);
    foreach my $h (@extra_headers) {
        push(@fields, $options{$h});
    }
    splice @fields, $options_idx, 1;
    $csv->print (*STDOUT, \@fields); print "\n";
}
