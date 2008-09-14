package List::FrontCode;
use strict;
use warnings;
use base qw/Class::Accessor::Lvalue::Fast/;

use List::FrontCode::Util;
use List::FrontCode::Iterator;

use overload
    '""'     => 'as_string',
    '@{}'    => 'as_array',
    fallback => 1;

__PACKAGE__->mk_accessors(qw/bin prev/);

sub push {
    my ($self, $value) = @_;

    $self->bin  .= front_encode( $value, $self->prev || '' );
    $self->prev = $value;

    return $value;
}

sub iterator {
    return List::FrontCode::Iterator->new( shift->bin );
}

sub as_array {
    my @values;
    my $it = shift->iterator;
    while ($it->has_next) {
        CORE::push @values, $it->next;
    }
    return \@values;
}

sub as_string {
    shift->bin;
}

1;
