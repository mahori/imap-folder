package folders;

use strict;
use warnings;
use feature qw( say );
use Encode qw( from_to );
use Encode::IMAPUTF7;

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

  @folders = map { from_to( $_, 'IMAP-UTF-7', 'UTF-8' ); $_ } @folders;
  foreach my $folder ( sort @folders ) {
    say $folder;
  }
}

1;
