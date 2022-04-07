package Inventory::DTO::AuthenticatedUser;

use Moose;

has 'id' => (
    is  => 'ro',
    isa => 'Int'
);

has 'username' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'email' => (
    is  => 'ro',
    isa => 'Str'
);

has 'jwt' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

no Moose;
__PACKAGE__->meta->make_immutable;