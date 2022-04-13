package Inventory::Client;

use Moose;

use Inventory::Client::Login;
use Inventory::Client::Country;
use Inventory::Client::Language;
use Inventory::Client::Hospital;

has 'username' => (
    is  => 'ro',
    isa => 'Str',
);

has 'password' => (
    is  => 'ro',
    isa => 'Str',
);

has 'login' => (
    is      => 'ro',
    isa     => 'Inventory::Client::Login',
    builder => '_build_login',
    lazy    => 1
);

has 'country' => (
    is      => 'ro',
    isa     => 'Inventory::Client::Country',
    builder => '_build_country',
    lazy    => 1
);

has 'language' => (
    is      => 'ro',
    isa     => 'Inventory::Client::Language',
    builder => '_build_language',
    lazy    => 1
);

has 'hospital' => (
    is      => 'ro',
    isa     => 'Inventory::Client::Hospital',
    builder => '_build_hospital',
    lazy    => 1
);

has 'authenticated_user' => (
    is      => 'ro',
    isa     => 'Inventory::DTO::AuthenticatedUser',
    lazy    => 1,
    builder => '_fetch_authenticated_user',
);

sub _build_login {
    return Inventory::Client::Login->new(
        uri => '/auth/local',
    );
}

sub _build_country {
    my ($self) = @_;
    
    return Inventory::Client::Country->new(
        uri                => '/countries',
        authenticated_user => $self->authenticated_user,
    );
}

sub _build_language {
    my ($self) = @_;
    
    return Inventory::Client::Language->new(
        uri                => '/languages',
        authenticated_user => $self->authenticated_user,
    );
}

sub _build_hospital {
    my ($self) = @_;
    
    return Inventory::Client::Hospital->new(
        uri                => '/hospitals',
        authenticated_user => $self->authenticated_user,
    );
}

sub _fetch_authenticated_user {
    my ($self) = @_;
    my $authenticated_user = $self->login->get_authenticated_user($self->username, $self->password);

    die "Couldn't authenticate user" unless $authenticated_user;

    return $authenticated_user;
}

no Moose;
__PACKAGE__->meta->make_immutable;