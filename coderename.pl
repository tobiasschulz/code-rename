#!/usr/bin/perl

use warnings;
use strict;
use List::Permutor;
use JSON;

if ( $#ARGV + 1 != 2 )
{
    print "Wrong count of command line arguments: $#ARGV.\n";
    exit(1);
}

## functions

sub unique_strings
{
    my ($input_ref) = @_;

    my @ret = do
    {
        my %seen;
        grep { !$seen{$_}++ } @$input_ref;
    };
    return @ret;
}

sub get_combinations
{
    my ( $length, @values ) = @_;

    my @a = ( [] );
    my @b = ();
    foreach my $word_index ( 0 .. ( $length - 1 ) )
    {
        foreach my $s_origin (@a)
        {
            foreach my $value (@values)
            {
                my @s = ( @{$s_origin}, $value );
                push @b, \@s;
            }
        }
        @a = @b;
        @b = ();
    }

    return @a;
}

sub get_variations
{
    my ($input_ref) = @_;

    # print "get_variations: input = " . ( encode_json \@$input_ref ) . "\n";

    foreach my $word_variations_ref (@$input_ref)
    {
        my %word_variations = %$word_variations_ref;

        # print "  word_variations: " . ( encode_json \@word_variations ) . "\n";
    }

    my $length = $#$input_ref + 1;

    my @a = ( [] );
    my @b = ();
    foreach my $word_index ( 0 .. ( $length - 1 ) )
    {
        foreach my $s_origin (@a)
        {
            print "  s_origin: " . ( encode_json $s_origin) . ", values current = " . ( encode_json $input_ref->[$word_index] ) . "\n"
              if 0;

            my %word_variation = %{ $input_ref->[$word_index] };
            foreach my $character ( keys %word_variation )
            {
                my $value = $word_variation{$character};

                my @s = ( @{$s_origin}, $value );
                push @b, \@s;
            }
        }
        @a = @b;
        @b = ();
    }

    # print "get_variations: output = " . ( encode_json \@a ) . "\n";

    return @a;
}

## words

my ( $words_before_str, $words_after_str ) = @ARGV;

my @words_before = split /\s+/, $words_before_str;
my @words_after  = split /\s+/, $words_after_str;

while ( $#words_before < $#words_after )
{
    push @words_before, '';
}
while ( $#words_after < $#words_before )
{
    push @words_after, '';
}

my $count_words     = $#words_before + 1;
my $lastindex_words = $#words_before;
print "count of words: $count_words\n";

my @words_before_alternatives = ();
my @words_after_alternatives  = ();
foreach my $word_index ( 0 .. $lastindex_words )
{
    my $word_before = $words_before[$word_index];
    my $word_after  = $words_after[$word_index];

    push @words_before_alternatives, { 'original' => $word_before, 'lc' => lc $word_before, 'ucfirst lc' => ucfirst lc $word_before, };
    push @words_after_alternatives,  { 'original' => $word_after,  'lc' => lc $word_after,  'ucfirst lc' => ucfirst lc $word_after, };
}
my $count_words_alternatives             = 3;
my @words_before_alternatives_variations = get_variations( \@words_before_alternatives );
my @words_after_alternatives_variations  = get_variations( \@words_after_alternatives );
print "words before variations: \n";
foreach my $words_before_alternatives_variation (@words_before_alternatives_variations)
{
    print "- " . ( encode_json \@$words_before_alternatives_variation ) . "\n";
}
print "words after variations: \n";
foreach my $words_after_alternatives_variation (@words_after_alternatives_variations)
{
    print "- " . ( encode_json \@$words_after_alternatives_variation ) . "\n";
}

foreach my $word_index ( 0 .. $lastindex_words )
{
    print "- $words_before[$word_index] => $words_after[$word_index]\n";
}

print "\n";

## separators

my @separators             = ( '-', '_', '.', '/', '\\', '\\\\', '', );
my @separator_combinations = get_combinations( $count_words, @separators );

## replacements

my %replacements = ();

foreach my $words_alternatives_variation_index ( 0 .. $#words_before_alternatives_variations )
{
    my @words_before_alternatives_variation = @{ $words_before_alternatives_variations[$words_alternatives_variation_index] };
    my @words_after_alternatives_variation  = @{ $words_after_alternatives_variations[$words_alternatives_variation_index] };

    foreach my $separator_combination (@separator_combinations)
    {

        my @separator_combination = @{$separator_combination};

        my $details = '';

        my $s_before = '';
        my $s_after  = '';
        foreach my $word_index ( 0 .. $lastindex_words )
        {
            my $word_before = $words_before_alternatives_variation[$word_index];
            my $word_after  = $words_after_alternatives_variation[$word_index];

            if ( $word_before eq '' )
            {
                $separator_combination[$word_index] = $separator_combination[ $word_index - 1 ];
            }

            if ( $word_index != 0 )
            {
                if ( $word_before ne '' )
                {
                    $s_before .= $separator_combination[$word_index];
                }

                if (
                    ( $word_after ne '' )
                    and (  $word_before ne ''
                        or $separator_combination[ $word_index - 1 ] eq $separator_combination[$word_index] )
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

        # print "- $s_before => $s_after ($details)\n";

    }
}

print "replacements:\n";
foreach my $replacement_before ( keys %replacements )
{
    my $replacement_after = $replacements{$replacement_before};

    print "- $replacement_before => $replacement_after\n";
}

## ...

foreach my $word_index ( 0 .. $lastindex_words )
{

    my $separator_permutor = List::Permutor->new( '-', '_', '.', '/', '\\', '', );
    while ( my @separator_permutation = $separator_permutor->next() )
    {

        # print "@separator_permutation\n";
        my $s = '';
        foreach my $word_index_inner ( 0 .. $word_index )
        {

        }

    }

}

