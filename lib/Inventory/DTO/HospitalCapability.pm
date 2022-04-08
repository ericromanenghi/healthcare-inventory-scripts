package Inventory::DTO::HospitalCapability;

use Moose;

has 'name' => (
    is => 'ro',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;