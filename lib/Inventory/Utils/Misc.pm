package Inventory::Utils::Misc;

use strict;
use warnings;

sub is_empty {
    my ($object) = @_;

    return !defined $object || _emptiness_by_ref($object);
}

sub _emptiness_by_ref {
    my ($object) = @_;

    return 1 if ref $object eq 'ARRAY' && @{$object} == 0;

    return 0;
}

1;