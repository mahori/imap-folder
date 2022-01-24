package delete;

use strict;
use warnings;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub options {
  my $class = shift;

  return 'folder';
}

sub execute {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return;
  }

  my $client = $self->{client};

  $self->folder_select( $folder );

  my $count = $client->message_count;
  unless ( defined $count ) {
    die $@;
  }
  unless ( $count == 0 ) {
    return;
  }

  $self->folder_close( $folder );

  $client->delete( $folder ) or die $@;
}

1;
