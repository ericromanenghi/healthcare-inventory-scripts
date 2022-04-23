package Inventory::Role::Endpoint;

use Moose::Role;

use Inventory::Environment;
use Inventory::Utils::Request;
use Inventory::Utils::Misc;
use Inventory::DTO::AuthenticatedUser;

use JSON;

has 'environment' => (
    is  => 'ro',
    isa => 'Inventory::Environment',
);

has 'uri' => (
    is  => 'ro',
    isa => 'Str',
);

has 'authenticated_user' => (
    is  => 'ro',
    isa => 'Inventory::DTO::AuthenticatedUser',
);

sub get_all {
    my ($self, $args) = @_;

    if (!defined $args->{populate} && $self->populate) {
        $args->{populate} = '*';
    }

    my $response = $self->_get($args);

    return unless $response;

    return $self->_render_response_plural($response);
}

# Strapi has a maximun number of items you can retrieve
# So here we paginate to get really all
sub get_all_forced {
    my ($self) = @_;

    my @all;
    my $page = 1;
    while (1) {
        my $batch = $self->get_all({
            "pagination[page]"     => $page++,
            "pagination[pageSize]" => 100
        });

        last unless $batch && @$batch > 0;

        push @all, @$batch;
    }

    return \@all;
}

# Not validating that field exists or is a unique field
sub get_map_by_field {
    my ($self, $field) = @_;

    my %entities_by_field = map {
        $_->{$field} => $_
    } @{$self->get_all_forced()};

    return \%entities_by_field;
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

    # For relations, we need to send ids instead of values
    my $relational_fields = $self->relational_fields;
    for my $relational_field (keys %$relational_fields) {
        my $relation = $dto->{$relational_field};

        next unless $relation;

        if (ref $relation eq 'ARRAY') {
            my @ids = map {
                $_->id
            } @$relation;
            $data{$relational_field} = \@ids;
            next; 
        }

        $data{$relational_field} = $relation->id;
    }

    return { data =>  \%data };
}

sub _render_response_plural {
    my ($self, $response) = @_;

    return [map { $self->_render($_) } @{$response->{data}}];
}

sub _render_response {
    my ($self, $response) = @_;

    return $self->_render($response->{data});
}

# TODO: support nested relations
sub _render {
    my ($self, $data) = @_;

    my $attributes = $data->{attributes};

    my @empty_fields;
    for my $relation (keys %{$self->relational_fields}) {
        my $relation_data = $attributes->{$relation}->{data};

        if (Inventory::Utils::Misc::is_empty($relation_data))  {
            push @empty_fields, $relation;
            next;
        }

        if (ref $relation_data eq 'ARRAY') {
            $attributes->{$relation} = [map {
                Inventory::Utils::Misc::create_dto_from_data(
                    $self->relational_fields->{$relation},
                    $_,
                )
            } @{$relation_data}];
        } else {
            $attributes->{$relation} = Inventory::Utils::Misc::create_dto_from_data(
                $self->relational_fields->{$relation},
                $relation_data,
            );
        }
    }

    map { delete $attributes->{$_} } @empty_fields;

    return Inventory::Utils::Misc::create_dto_from_data($self->dto_class, $data);
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