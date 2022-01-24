package messages;

use strict;
use warnings;
use feature qw( say );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

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
  if ( $count == 0 ) {
    return;
  }

  my @messages = $client->messages or die $@;
  unless ( @messages ) {
    return;
  }

  foreach my $message ( sort { $a <=> $b } @messages ) {
    say $message;
  }
}

1;
