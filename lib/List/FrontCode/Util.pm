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

    ## $prev �Ȥΰ�����ʬ����
    substr($cur, 0, $nmatch) = '';

    ## ����Ĺ���Ĥ��Ĺ�����԰�����ʬ�����
    $out .= encode_vb $nmatch;
    $out .= encode_vb length $cur;
    $out .= $cur;

    return $out;
}

sub front_decodex ($$) {
    my ($in, $prev) = validate_pos(@_, { type => SCALARREF }, 1);

    my $nmatch = decode_vbx($in);
    my $nrest  = decode_vbx($in);

    ## �����ǤȤΰ�����ʬ���Ĥ���ʬ����³��������
    my $cur = sprintf "%s%s", substr($prev, 0, $nmatch), substr($$in, 0, $nrest);

    ## �ɤ߽Ф���ʬ���
    substr($$in, 0, $nrest) = '';

    return $cur;
}

1;
