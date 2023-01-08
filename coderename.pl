#!/usr/bin/perl

use strict;
use List::Permutor;

if ( $#ARGV + 1 != 2 ) {
    print "Wrong count of command line arguments: $#ARGV.\n";
    exit(1);
}

my ( $words_before_str, $words_after_str ) = @ARGV;

my @words_before = split /\s+/, $words_before_str;
my @words_after  = split /\s+/, $words_after_str;

my $count_words_before = $#words_before + 1;
print "Count of words: $count_words_before:\n";

foreach my $word_index ( 0 .. $#words_before ) {
    print "- $words_before[$word_index] => $words_after[$word_index]\n";
}

print "\n";

my @replacements = ();

foreach my $word_index ( 0 .. $#words_before ) {

    my $separator_permutor = List::Permutor->new( '-', '_', '.', '/', '\\', '', );
    while ( my @separator_permutation = $separator_permutor->next() ) {

        print "@separator_permutation\n";
        my $s = '';
        foreach my $word_index_inner ( 0 .. $word_index ) {

        }

    }

}

