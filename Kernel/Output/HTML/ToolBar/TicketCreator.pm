# --
# Copyright (C) 2018 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBar::TicketCreator;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Count = $TicketObject->TicketSearch(
        Result         => 'COUNT',
        StateType      => 'Open',
        CreatedUserIDs => [ $Self->{UserID} ],
        UserID         => 1,
    );
    my $CountNew = $TicketObject->TicketSearch(
        Result         => 'COUNT',
        StateType      => 'Open',
        CreatedUserIDs => [ $Self->{UserID} ],
        TicketFlag => {
            Seen => 1,
        },
        TicketFlagUserID => $Self->{UserID},
        UserID           => 1,
    );
    $CountNew = $Count - $CountNew;

    my $CountReached = $TicketObject->TicketSearch(
        Result                        => 'COUNT',
        StateType                     => ['pending reminder'],
        CreatedUserIDs                => [ $Self->{UserID} ],
        TicketPendingTimeOlderMinutes => 1,
        UserID                        => 1,
    );

    my $CountAvailable = $TicketObject->TicketSearch(
        Result         => 'COUNT',
        StateType      => 'Open',
        Locks          => ['unlock'],
        CreatedUserIDs => [ $Self->{UserID} ],
        UserID         => 1,
    );

    my $Class          = $Param{Config}->{CssClass};
    my $ClassNew       = $Param{Config}->{CssClassNew};
    my $ClassReached   = $Param{Config}->{CssClassReached};
    my $ClassAvailable = $Param{Config}->{CssAvailable};

    my $Icon          = $Param{Config}->{Icon};
    my $IconNew       = $Param{Config}->{IconNew};
    my $IconReached   = $Param{Config}->{IconReached};
    my $IconAvailable = $Param{Config}->{IconAvailable};

    my $URL = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($CountNew && $IconNew ) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Creator Tickets New'),
            Count       => $CountNew,
            Class       => $ClassNew,
            Icon        => $IconNew,
            Link        => $URL . 'Action=AgentTicketCreatorView;Filter=New',
            AccessKey   => $Param{Config}->{AccessKeyNew} || '',
        };
    }
    if ($CountReached && $IconReached ) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Creator Tickets Reminder Reached'),
            Count       => $CountReached,
            Class       => $ClassReached,
            Icon        => $IconReached,
            Link        => $URL . 'Action=AgentTicketCreatorView;Filter=ReminderReached',
            AccessKey   => $Param{Config}->{AccessKeyReached} || '',
        };
    }
    if ($CountAvailable && $IconAvailable ) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Creator Tickets Available'),
            Count       => $CountAvailable,
            Class       => $ClassAvailable,
            Icon        => $IconAvailable,
            Link        => $URL . 'Action=AgentTicketCreatorView;Filter=Available',
            AccessKey   => $Param{Config}->{AccessKeyAvailable} || '',
        };
    }
    if ($Count && $Icon) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Creator Tickets Total'),
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=AgentTicketCreatorView',
            AccessKey   => $Param{Config}->{AccessKey} || '',
        };
    }
    return %Return;
}

1;

