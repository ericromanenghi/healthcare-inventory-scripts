package Inventory::DTO::Language;

use Moose;

with 'Inventory::Role::StrapiEntity';

has 'code' => (
    is => 'ro',
    isa => 'Str',
);

has 'name_en' => (
    is => 'ro',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;