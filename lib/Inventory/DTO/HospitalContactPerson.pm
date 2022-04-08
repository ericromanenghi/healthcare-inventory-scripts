package Inventory::DTO::HospitalContactPerson;

use Moose;

has 'name' => (
    is => 'ro',
    isa => 'Str',
);

has 'phone' => (
    is => 'ro',
    isa => 'Str',
);

has 'email' => (
    is => 'ro',
    isa => 'Str',
);

has 'comments' => (
    is => 'ro',
    isa => 'Str',
);

has 'hospitals' => (
    is => 'ro',
    isa => 'ArrayRef[Inventory::DTO::Hospital]',
);

no Moose;
__PACKAGE__->meta->make_immutable;