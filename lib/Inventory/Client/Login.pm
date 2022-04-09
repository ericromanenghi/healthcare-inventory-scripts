package Inventory::Client::Login;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::AuthenticatedUser;

sub get_authenticated_user {
    my ($self, $username, $password) = @_;

    return unless $username && $password;

    my $user_data = $self->post({
        identifier => $username,
        password   => $password,
    });

    if (!$user_data) {
        return;
    }

    return Inventory::DTO::AuthenticatedUser->new(
        id       => $user_data->{user}->{id},
        username => $user_data->{user}->{username},
        email    => $user_data->{user}->{email},
        jwt      => $user_data->{jwt},
    );
}

no Moose;
__PACKAGE__->meta->make_immutable;