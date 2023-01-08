#!/usr/bin/perl

use warnings;
use strict;
use List::Permutor;

if ( $#ARGV + 1 != 2 ) {
    print "Wrong count of command line arguments: $#ARGV.\n";
    exit(1);
}

## functions

sub get_combinations {
    my ( $length, @values ) = @_;

    my @a = ( [] );
    my @b = ();
    foreach my $word_index ( 0 .. ( $length - 1 ) ) {
        foreach my $s_origin (@a) {
            foreach my $value (@values) {
                my @s = ( @{$s_origin}, $value );
                push @b, \@s;
            }
        }
        @a = @b;
        @b = ();
    }

    return @a;
}

## words

my ( $words_before_str, $words_after_str ) = @ARGV;

my @words_before = split /\s+/, $words_before_str;
my @words_after  = split /\s+/, $words_after_str;

while ( $#words_before < $#words_after ) {
    push @words_before, '';
}
while ( $#words_after < $#words_before ) {
    push @words_after, '';
}

my $count_words     = $#words_before + 1;
my $lastindex_words = $#words_before;
print "Count of words: $count_words:\n";

foreach my $word_index ( 0 .. $lastindex_words ) {
    print "- $words_before[$word_index] => $words_after[$word_index]\n";
}

print "\n";

## separators

my @separators             = ( '-', '_', '.', '/', '\\', '\\\\', '', );
my @separator_combinations = get_combinations( $count_words, @separators );

## replacements

my %replacements = ();

foreach my $separator_combination (@separator_combinations) {

    my @separator_combination = @{$separator_combination};

    my $details = '';

    my $s_before = '';
    my $s_after  = '';
    foreach my $word_index ( 0 .. $lastindex_words ) {
        my $word_before = $words_before[$word_index];
        my $word_after  = $words_after[$word_index];

        if ($word_before eq '') {
            $separator_combination[$word_index] = $separator_combination[$word_index - 1];
        }

        if ( $word_index != 0 ) {
            if ( $word_before ne '' ) {
                $s_before .= $separator_combination[$word_index];
            }

            if (
                ( $word_after ne '' )
                and (  $word_before ne ''
                    or $separator_combination[ $word_index - 1 ] eq
                    $separator_combination[$word_index] )
              )
            {
                $s_after .= $separator_combination[$word_index];
            }
        }

        # $details .= ', ';

        $s_before .= $word_before;
        $s_after  .= $word_after;
    }

    $replacements{$s_before} = $s_after;

    print "- $s_before => $s_after ($details)\n";
}

## ...

foreach my $word_index ( 0 .. $lastindex_words ) {

    my $separator_permutor =
      List::Permutor->new( '-', '_', '.', '/', '\\', '', );
    while ( my @separator_permutation = $separator_permutor->next() ) {

        # print "@separator_permutation\n";
        my $s = '';
        foreach my $word_index_inner ( 0 .. $word_index ) {

        }

    }

}

