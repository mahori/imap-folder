package message;

use strict;
use warnings;
use feature qw( say );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub options {
  my $class = shift;

  return 'folder', 'uid';
}

sub execute {
  my ( $self, $folder, $uid ) = @_;

  unless ( defined $folder && defined $uid ) {
    return;
  }

  my $client = $self->{client};

  $self->folder_select( $folder );

  my $message = $client->message_string( $uid ) or die $@;
  unless ( $message ) {
    return;
  }

  say $message;
}

1;
