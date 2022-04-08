package Inventory::DTO::Country;

use Moose;

has 'country_code' => (
    is => 'ro',
    isa => 'Str',
);

has 'name_en' => (
    is => 'ro',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;