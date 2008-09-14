package List::FrontCode::Iterator;
use strict;
use warnings;
use base qw/Class::Accessor::Lvalue::Fast/;

use List::FrontCode::Util;

__PACKAGE__->mk_accessors(qw/bin prev/);

sub new {
    my ($class, $bin) = @_;
    my $self = $class->SUPER::new({
        bin  => $bin,
        prev => '',
    });
    bless $self, $class;
}

sub has_next {
    length shift->bin > 0 ? 1 : 0;
}

sub next {
    my $self = shift;

    if (my $value = front_decodex(\$self->bin, $self->prev)) {
        $self->prev = $value;
        return $value;
    }

    return;
}

1;
