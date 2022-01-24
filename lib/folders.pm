package folders;

use strict;
use warnings;
use feature qw( say );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my $self = shift;

  my $client = $self->{client};

  my @folders = $client->folders or die $@;
  unless ( @folders ) {
    return;
  }

  @folders = map { $self->folder_decode( $_ ) } @folders;
  foreach my $folder ( sort @folders ) {
    say $folder;
  }
}

1;
