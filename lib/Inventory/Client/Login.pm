package Inventory::Client::Login;

use Moose;

use JSON;

use Inventory::Environment;
use Inventory::Utils::Request;
use Inventory::DTO::AuthenticatedUser;

has 'uri' => (
    is       => 'ro',
    isa      => 'Str',
    builder  => '_build_uri'
);

has 'environment' => (
    is => 'ro',
    isa => 'Inventory::Environment',
    builder => '_fetch_environment'
);

sub _build_uri {
    return '/auth/local';
}

sub _fetch_environment {
    return Inventory::Environment->new();
}

sub get_authenticated_user {
    my ($self, $username, $password) = @_;

    my $response;
    eval {
        $response = Inventory::Utils::Request::post(
            $self->environment->api_url,
            $self->uri,
            {
                identifier => $username ? $username : $self->environment->api_username,
                password   => $password ? $password : $self->environment->api_password,
            }
        );
    } or do {
        my $error = $@;
        warn "Something went wrong: $error";
    };

    if ($response->code() != 200) {
        warn "API called failed with status " . $response->code();
    }

    if (!defined $response || $response->code() != 200) {
        return {};
    }

    my $decoded_content = $response->decoded_content();

    my $user_data = decode_json($decoded_content);

    return Inventory::DTO::AuthenticatedUser->new(
        id       => $user_data->{user}->{id},
        username => $user_data->{user}->{username},
        email    => $user_data->{user}->{email},
        jwt      => $user_data->{jwt},
    );
}

no Moose;
__PACKAGE__->meta->make_immutable;