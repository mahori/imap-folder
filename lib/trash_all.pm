package trash_all;

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

  my @folders = $client->folders_hash or die $@;
  my @trash   = grep { grep { $_ eq '\\Trash' } @{$_->{attrs}} } @folders;
  unless ( scalar @trash == 1 ) {
    return;
  }

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $@;

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

  foreach my $message ( @messages ) {
    $client->move( $trash[0]->{name}, $message ) or die $@;
  }

  $client->expunge( $folder ) or die $@;
}

1;
