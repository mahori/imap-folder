package trash;

use strict;
use warnings;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder, $uid ) = @_;

  unless ( defined $folder && defined $uid ) {
    return;
  }

  my $client = $self->{client};

  my @folders = $client->folders_hash or die $@;
  my @trash   = grep { grep { $_ eq '\\Trash' } @{$_->{attrs}} } @folders;
  unless ( scalar @trash == 1 ) {
    return;
  }

  $self->folder_select( $folder );

  $client->move( $trash[0]->{name}, $uid ) or die $@;

  $client->expunge( $folder ) or die $@;
}

1;
