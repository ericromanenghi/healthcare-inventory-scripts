package Inventory::Client::Country;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::Country;

has 'dto_class' => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_dto_class'
);

has 'required_fields' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    builder => '_build_required_fields'
);

has 'optional_fields' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    builder => '_build_optional_fields'
);

has 'relational_fields' => (
    is      => 'ro',
    isa     => 'HashRef',
    builder => '_build_relational_fields'
);

has 'populate' => (
    is      => 'ro',
    isa     => 'Bool',
    default => sub { 0 },
);

sub _build_dto_class {
    return 'Inventory::DTO::Country';
}

sub _build_required_fields {
    return [qw(name_en country_code)];
}

sub _build_optional_fields {
    return [];
}

sub _build_relational_fields {
    return {};
}

no Moose;
__PACKAGE__->meta->make_immutable;