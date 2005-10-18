use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Data::Dumper;
use Gtk2::Ex::PopupWindow;

use Gtk2::TestHelper tests => 5;

# ------------------------------------ #
# Show the popup, then hide it
# Then toggle it
# ------------------------------------ #

my $label = Gtk2::Label->new(' Sample Label ');
my $popupwindow = Gtk2::Ex::PopupWindow->new($label);
my $window = Gtk2::Window->new;
$window->add($label);
$window->show_all;

isa_ok($popupwindow, "Gtk2::Ex::PopupWindow");

$popupwindow->show;
ok($popupwindow->{window}->visible());

$popupwindow->hide;
ok(!$popupwindow->{window}->visible());

$popupwindow->toggle;
ok($popupwindow->{window}->visible());

$popupwindow->toggle;
ok(!$popupwindow->{window}->visible());
