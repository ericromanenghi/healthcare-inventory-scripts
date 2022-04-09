package Inventory::Client::Hospital;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::Hospital;

my @REQUIRED_FIELDS = qw(
    name
    address
);

my @OPTIONAL_FIELDS = qw(
    google_maps_link
    phone
    admition_protocol
    can_accommodate_family
    comments
    website
    localization
);

my @RELATIONAL_FIELDS = qw(
    country
    specialized_units
    contact_people
    spoken_languages
    translated_languages
    hospital_capabilities
    availability
    treatments
);

sub create_hospital {
    my ($self, $hospital_dto) = @_;

    my $hospital_data = _from_dto_to_data($hospital_dto);

    my $response = $self->post($hospital_data);

    return unless $response;

    return _render_response($response);
}

sub _from_dto_to_data {
    my ($hospital_dto) = @_;
    
    my %hospital_data = %{ $hospital_dto }{(@REQUIRED_FIELDS, @OPTIONAL_FIELDS)};

    return { data =>  \%hospital_data };
}

sub _render_response {
    my ($response) = @_;
    
    my $data = $response->{data};
    my $attributes = $data->{attributes};
    
    return Inventory::DTO::Hospital->new(
        id => $data->{id},
        %{$attributes}
    );
}

no Moose;
__PACKAGE__->meta->make_immutable;