package Inventory::Utils::Misc;

use strict;
use warnings;

use Module::Load;

sub is_empty {
    my ($object) = @_;

    return !defined $object || _emptiness_by_ref($object);
}

sub _emptiness_by_ref {
    my ($object) = @_;

    return 1 if ref $object eq 'ARRAY' && @{$object} == 0;

    return 0;
}

sub create_dto_from_data {
    my ($dto_class, $data) = @_;

    load $dto_class;

    return $dto_class->new(
        id => $data->{id},
        %{$data->{attributes}}
    );
}

1;