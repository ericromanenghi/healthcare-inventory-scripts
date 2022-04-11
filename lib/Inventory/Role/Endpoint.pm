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

sub get_all {
    my ($self, $args) = @_;

    my $response = $self->_get($args);

    return unless $response;

    return $self->_render_response_plural($response);
}

sub delete {
    my ($self, $id) = @_;

    my $response = $self->_delete({
        id => $id
    });

    return $response;
}

sub create {
    my ($self, $dto) = @_;

    my $data = $self->_from_dto_to_data($dto);

    my $response = $self->_post($data);

    return unless $response;

    return $self->_render_response($response);
}

sub _from_dto_to_data {
    my ($self, $dto) = @_;
    
    my %data = %{ $dto }{(
        @{ $self->required_fields },
        @{ $self->optional_fields },
    )};

    return { data =>  \%data };
}

sub _render_response_plural {
    my ($self, $response) = @_;

    return [map {
        $self->dto_class->new(
            id => $_->{id},
            %{$_->{attributes}}
        );
    } @{$response->{data}}];
}

sub _render_response {
    my ($self, $response) = @_;

    return $self->dto_class->new(
        id => $response->{data}->{id},
        %{$response->{data}->{attributes}}
    );
}

# Returns a hashref with the decoded data or an undef in case of errors
sub _get {
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
sub _post {
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
sub _delete {
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