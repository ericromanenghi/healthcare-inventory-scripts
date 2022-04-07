package Inventory::Environment;

use Moose;

use Dotenv;

has 'env' => (
    is  => 'ro',
    isa => 'HashRef',
    builder => '_load_env'
);

has 'api_url' => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_api_url',
    lazy    => 1,
);

has 'api_username' => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_api_username',
    lazy    => 1,
);

has 'api_password' => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_api_password',
    lazy    => 1,
);

sub _load_env {
    return Dotenv->parse();
}

sub _build_api_url {
    my ($self) = @_;

    return $self->env->{API_URL};
}

sub _build_api_username {
    my ($self) = @_;

    return $self->env->{API_USERNAME};
}

sub _build_api_password {
    my ($self) = @_;

    return $self->env->{API_PASSWORD};
}

no Moose;
__PACKAGE__->meta->make_immutable;