package Inventory::Client::Hospital;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::Hospital;

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
    default => sub { 1 },
);

sub _build_dto_class {
    return 'Inventory::DTO::Hospital';
}

sub _build_required_fields {
    return [qw(
        name
        address
    )];
}

sub _build_optional_fields {
    return [qw(
        google_maps_link
        phone
        admition_protocol
        can_accommodate_family
        comments
        website
        localization
    )];
}

sub _build_relational_fields {
    return {
        country               => 'Inventory::DTO::Country',
        specialized_units     => 'Inventory::DTO::SpecializedUnit',
        contact_people        => 'Inventory::DTO::HospitalContactPerson',
        spoken_languages      => 'Inventory::DTO::Language',
        translated_languages  => 'Inventory::DTO::Language',
        hospital_capabilities => 'Inventory::DTO::HospitalCapability',
        availability          => 'Inventory::DTO::Availability',
        treatments            => 'Inventory::DTO::Treatment',
    };
}

no Moose;
__PACKAGE__->meta->make_immutable;