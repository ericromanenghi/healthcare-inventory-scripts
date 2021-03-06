package Inventory::Role::StrapiEntity;

use Moose::Role;
use MooseX::UndefTolerant;

has 'id' => (
    is  => 'ro',
    isa => 'Int',
);

has 'createdAt' => (
    is  => 'ro',
    isa => 'Str',
);

has 'updatedAt' => (
    is  => 'ro',
    isa => 'Str',
);

has 'publishedAt' => (
    is  => 'ro',
    isa => 'Str',
);

1;