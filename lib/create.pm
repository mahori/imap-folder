package create;

use strict;
use warnings;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return;
  }

  my $client = $self->{client};

  $folder = $self->folder_encode( $folder );

  if ( $client->exists( $folder ) ) {
    return;
  }

  $client->create( $folder ) or die $@;
}

1;
