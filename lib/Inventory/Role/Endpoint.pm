package Inventory::Role::Endpoint;

use Moose::Role;

use Inventory::Environment;
use Inventory::Utils::Request;
use Inventory::DTO::AuthenticatedUser;

use JSON;

has 'environment' => (
    is => 'ro',
    isa => 'Inventory::Environment',
    builder => '_fetch_environment'
);

has 'uri' => (
    is       => 'ro',
    isa      => 'Str',
);

has 'authenticated_user' => (
    is   => 'ro',
    isa  => 'Inventory::DTO::AuthenticatedUser',
);

sub _fetch_environment {
    return Inventory::Environment->new();
}

# Returns a hashref with the decoded data or an undef in case of errors
sub get {
    my ($self, $args) = @_;

    my $jwt;
    if ($self->authenticated_user) {
        $jwt = $self->authenticated_user->jwt();
    }

    my $response;
    eval {
        $response = Inventory::Utils::Request::get(
            $self->environment->api_url,
            $self->uri,
            $args,
            $jwt
        );
    } or do {
        my $error = $@;
        warn "Something went wrong: $error";
    };

    if ($response->code() != 200) {
        warn "API called failed with status " . $response->code();
    }

    if (!defined $response || $response->code() != 200) {
        return;
    }

    my $decoded_data;
    eval {
        $decoded_data = decode_json($response->decoded_content());
    } or do {
        my $error = $@;
        warn "Couldn't decode response: $error";
    };

    return $decoded_data;
}

# Returns a hashref with the decoded data or an undef in case of errors
sub post {
    my ($self, $args) = @_;

    my $jwt;
    if ($self->authenticated_user) {
        $jwt = $self->authenticated_user->jwt();
    }

    my $response;
    eval {
        $response = Inventory::Utils::Request::post(
            $self->environment->api_url,
            $self->uri,
            $args,
            $jwt
        );
    } or do {
        my $error = $@;
        warn "Something went wrong: $error";
    };

    if ($response->code() != 200) {
        warn "API call failed with status " . $response->code();
    }

    if (!defined $response || $response->code() != 200) {
        return;
    }

    my $decoded_data;
    eval {
        $decoded_data = decode_json($response->decoded_content());
    } or do {
        my $error = $@;
        warn "Couldn't decode response: $error";
    };

    return $decoded_data;
}

# Returns a hashref with the decoded data or an undef in case of errors
sub delete {
    my ($self, $args) = @_;

    my $jwt;
    if ($self->authenticated_user) {
        $jwt = $self->authenticated_user->jwt();
    }

    my $response;
    eval {
        $response = Inventory::Utils::Request::delete(
            $self->environment->api_url,
            $self->uri,
            $args,
            $jwt
        );
    } or do {
        my $error = $@;
        warn "Something went wrong: $error";
    };

    if ($response->code() != 200) {
        warn "API call failed with status " . $response->code();
    }

    if (!defined $response || $response->code() != 200) {
        return;
    }

    my $decoded_data;
    eval {
        $decoded_data = decode_json($response->decoded_content());
    } or do {
        my $error = $@;
        warn "Couldn't decode response: $error";
    };

    return $decoded_data;
}

1;