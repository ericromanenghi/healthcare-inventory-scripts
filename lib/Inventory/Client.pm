package Inventory::Client;

use Moose;

use Inventory::Client::Login;

has 'login' => (
    is      => 'ro',
    isa     => 'Inventory::Client::Login',
    builder => '_build_login',
    lazy    => 1
);

sub _build_login {
    return Inventory::Client::Login->new(
        uri => '/auth/local',
    );
}

no Moose;
__PACKAGE__->meta->make_immutable;