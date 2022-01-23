package trash;

use strict;
use warnings;
use Encode qw( from_to );
use Encode::IMAPUTF7;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder, $uid ) = @_;

  unless ( defined $folder && defined $uid ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $@;

  my @folders = $client->folders_hash or die $@;
  my @trash   = grep { grep { $_ eq '\\Trash' } @{$_->{attrs}} } @folders;
  unless ( scalar @trash == 1 ) {
    return;
  }

  $client->move( $trash[0]->{name}, $uid ) or die $@;

  $client->expunge( $folder ) or die $@;
}

1;
