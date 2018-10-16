# --
# Copyright (C) 2018 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::de_ToolbarTicketCreator;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Translation = $Self->{Translation};

    $Translation->{'Creator view'}                     = 'Von mir erstellte Tickets';
    $Translation->{'My Created Tickets'}               = 'Von mir erstellte Tickets';
    $Translation->{'Creator Tickets New'}              = 'Von mir erstellte Tickets (neu)';
    $Translation->{'Creator Tickets Reminder Reached'} = 'Von mir erstellte Tickets (Erinnerungszeit erreicht)';
    $Translation->{'Creator Tickets Available'}        = 'Von mir erstellte Tickets (verfügbar)';
    $Translation->{'Creator Tickets Total'}            = 'Von mir erstellte Tickets (gesamt)';

    return 1;
}

1;
