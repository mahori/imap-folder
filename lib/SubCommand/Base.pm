package SubCommand::Base;

use strict;
use warnings;
use Mail::IMAPClient;

sub new {
  my ( $class, $args ) = @_;

  my $client = Mail::IMAPClient->new( Server   => $args->{h},
                                      Port     => $args->{p},
                                      User     => $args->{U},
                                      Password => $args->{P},
                                      Ssl      => $args->{s},
                                      Uid      => 1 )
    or die $!;

  unless ( defined $client ) {
    return undef;
  }

  my $self = {};
  bless $self, $class;

  $self->{client} = $client;

  return $self;
}

sub DESTROY {
  my $self = shift;

  my $client = $self->{client};

  if ( defined $client && $client->IsConnected ) {
    $client->logout or die $!;
  }
}

1;
