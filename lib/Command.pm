package Command;

use strict;
use warnings;
use Encode qw( from_to );
use Encode::IMAPUTF7;
use Mail::IMAPClient;

sub new {
  my ( $class, $args ) = @_;

  my $client = Mail::IMAPClient->new( Server   => $args->{h},
                                      Port     => $args->{p},
                                      User     => $args->{U},
                                      Password => $args->{P},
                                      Ssl      => $args->{s},
                                      Uid      => 1 )
    or die $@;

  unless ( $client->IsAuthenticated ) {
    die $@;
  }

  my $self = { client => $client };
  bless $self, $class;

  return $self;
}

sub DESTROY {
  my $self = shift;

  my $client = $self->{client};

  if ( defined $client ) {
    $client->logout or die $@;
  }
}

sub folder_encode {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return undef;
  }

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );

  return $folder;
}

sub folder_decode {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return undef;
  }

  from_to( $folder, 'IMAP-UTF-7', 'UTF-8' );

  return $folder;
}

1;
