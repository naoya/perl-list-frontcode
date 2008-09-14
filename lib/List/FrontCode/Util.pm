package List::FrontCode::Util;
use strict;
use warnings;

use Exporter::Lite;
use Params::Validate qw/validate_pos SCALARREF/;

our @EXPORT_OK = qw/encode_vb decode_vb decode_vbx front_encode front_decodex/;
our @EXPORT    = @EXPORT_OK;

sub encode_vb ($) {
    pack('w', shift);
}

sub decode_vb ($) {
    unpack('w', shift);
}

sub decode_vbx ($) {
    my ($binref) = validate_pos(@_, { type => SCALARREF });

    my $n = decode_vb $$binref;
    substr($$binref, 0, length encode_vb $n) = '';

    return $n;
}

sub front_encode ($$) {
    my ($cur, $prev) = @_;

    my $out;
    my @prev = split //, $prev;
    my @cur  = split //, $cur;

    my $nmatch = 0;
    while ( $nmatch < @prev and
            $nmatch < @cur  and
            $prev[ $nmatch ] eq $cur[ $nmatch ] ) {
        $nmatch++;
    }

    ## $prev との一致部分を削除
    substr($cur, 0, $nmatch) = '';

    ## 一致長、残りの長さ、不一致部分を出力
    $out .= encode_vb $nmatch;
    $out .= encode_vb length $cur;
    $out .= $cur;

    return $out;
}

sub front_decodex ($$) {
    my ($in, $prev) = validate_pos(@_, { type => SCALARREF }, 1);

    my $nmatch = decode_vbx($in);
    my $nrest  = decode_vbx($in);

    ## 前要素との一致部分、残り部分を接続して復元
    my $cur = sprintf "%s%s", substr($prev, 0, $nmatch), substr($$in, 0, $nrest);

    ## 読み出した分削る
    substr($$in, 0, $nrest) = '';

    return $cur;
}

1;
