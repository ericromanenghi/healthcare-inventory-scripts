package Inventory::DTO::Hospital;

use Moose;
use Moose::Util::TypeConstraints;

has 'name' => (
    is  => 'ro',
    isa => 'Str',
);

has 'country' => (
    is  => 'ro',
    isa => 'Inventory::DTO::Country',
);

has 'address' => (
    is  => 'ro',
    isa => 'Str',
);

has 'google_maps_link' => (
    is  => 'ro',
    isa => 'Str',
);

has 'phone' => (
    is  => 'ro',
    isa => 'Str',
);

has 'admition_protocol' => (
    is  => 'ro',
    isa => 'Str',
);

has 'can_accommodate_family' => (
    is  => 'ro',
    isa => enum([qw(yes maybe no)]),
);

has 'comments' => (
    is  => 'ro',
    isa => 'Str',
);

has 'specialized_units' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::SpecializedUnit]',
);

has 'contact_people' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::HospitalContactPerson]',
);

has 'spoken_languages' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::Language]',
);

has 'translated_languages' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::Language]',
);

has 'hospital_capabilities' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::HospitalCapability]',
);

has 'availability' => (
    is  => 'ro',
    isa => 'Inventory::DTO::Availability'
);

has 'treatments' => (
    is  => 'ro',
    isa => 'ArrayRef[Inventory::DTO::Treatment]',
);

has 'website' => (
    is  => 'ro',
    isa => 'Str',
);

has 'localization' => (
    is  => 'ro',
    isa => 'Str',
);

no Moose::Util::TypeConstraints;
no Moose;
__PACKAGE__->meta->make_immutable;