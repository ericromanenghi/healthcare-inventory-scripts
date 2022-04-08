package Inventory::DTO::Availability;

use Moose;

has 'regular_availability' => (
    is  => 'ro',
    isa => 'Int',
);

has 'special_availability' => (
    is  => 'ro',
    isa => 'Int',
);

has 'assigned_regular_availability' => (
    is  => 'ro',
    isa => 'Int',
);

has 'assigned_special_availability' => (
    is  => 'ro',
    isa => 'Int',
);

has 'hospital' => (
    is  => 'ro',
    isa => 'Inventory::DTO::Hospital',
);

no Moose;
__PACKAGE__->meta->make_immutable;