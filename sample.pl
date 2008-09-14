#!/usr/local/bin/perl
use strict;
use warnings;

use FindBin::libs;
use Perl6::Say;
use List::FrontCode;

my @keys = (
    'http://www.hoge.jp',
    'http://www.hoge.jp/a.htm',
    'http://www.hoge.jp/index.htm',
    'http://www.fuga.com/',
    'http://www.fugafuga.com/',
);

my $list = List::FrontCode->new;
for (@keys) {
    $list->push($_);
}

my $it = $list->iterator;
while ($it->has_next) {
    say $it->next;
}

say sprintf "%d bytes => %d bytes", length(join '', @keys), length $list;
