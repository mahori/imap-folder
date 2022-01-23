package delete;

use strict;
use warnings;
use Encode qw( from_to );
use Encode::IMAPUTF7;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $@;

  my $count = $client->message_count;
  unless ( defined $count ) {
    die $@;
  }
  unless ( $count == 0 ) {
    return;
  }

  $client->close or die $@;

  $client->delete( $folder ) or die $@;
}

1;
