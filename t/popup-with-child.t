use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Gtk2::Ex::PopupWindow;
use Gtk2::Ex::Simple::List;
use Data::Dumper;

use Gtk2::TestHelper tests => 6;

my $window = Gtk2::Window->new;
$window->signal_connect('destroy', sub {Gtk2->main_quit;});

my $label = Gtk2::Label->new(' Sample Label ');
my $eventbox = add_arrow($label);
my $popupwindow = Gtk2::Ex::PopupWindow->new($eventbox);

my $childlabel = Gtk2::Label->new(' Child Label ');
my $childeventbox = add_arrow($childlabel);
my $childpopupwindow = Gtk2::Ex::PopupWindow->new($childeventbox);

my $outsidelabel = Gtk2::Label->new(' Outside Label ');
my $outsideeventbox = Gtk2::EventBox->new;
$outsideeventbox->add($outsidelabel);

my $vbox = Gtk2::VBox->new (FALSE, 0);
$vbox->pack_start ($eventbox, FALSE, TRUE, 0);
$vbox->pack_start ($outsideeventbox, TRUE, TRUE, 0);

my $childvbox = Gtk2::VBox->new (FALSE, 0);
$childvbox->pack_start ($childeventbox, FALSE, TRUE, 0);
$childvbox->pack_start (Gtk2::Label->new, TRUE, TRUE, 0);

my $frame = Gtk2::Frame->new;
$popupwindow->{window}->add($frame);
$frame->add($childvbox);

$childpopupwindow->{window}->add(Gtk2::Frame->new);
$childpopupwindow->{window}->set_default_size(100, 200);
$childpopupwindow->signal_connect('show' => 
	sub {
		$popupwindow->set_move_with_parent(TRUE);
		$popupwindow->show;
	}
);
$childpopupwindow->signal_connect('hide' => 
	sub {
		$popupwindow->set_move_with_parent(FALSE);
	}
);

$eventbox->signal_connect('button-release-event' => sub { $popupwindow->show; } );
$childeventbox->signal_connect('button-release-event' => sub { $childpopupwindow->show; } );

$window->add ($vbox);
$window->set_default_size(400, 50);
$window->show_all;

Glib::Timeout->add(100, \&parent_clicked);
Glib::Timeout->add(200, \&child_clicked);
Glib::Timeout->add(500, \&move_window);
Glib::Timeout->add(1000, \&terminate);

Gtk2->main;

sub add_arrow {
	my ($label) = @_;
	my $arrow = Gtk2::Arrow -> new('down', 'none');
	my $labelbox = Gtk2::HBox->new (FALSE, 0);
	$labelbox->pack_start ($label, FALSE, FALSE, 0);    
	$labelbox->pack_start ($arrow, FALSE, FALSE, 0);    
	my $eventbox = Gtk2::EventBox->new;
	$eventbox->add ($labelbox);
	return $eventbox;
}

sub parent_clicked {
	$eventbox->signal_emit('button-release-event' => $_[1]);
    ok($popupwindow->{window}->visible());
    ok(!$childpopupwindow->{window}->visible());
	return FALSE;
}

sub child_clicked {
	$childeventbox->signal_emit('button-release-event' => $_[1]);
    ok($popupwindow->{window}->visible());
    ok($childpopupwindow->{window}->visible());
	return FALSE;
}

sub move_window {
    my ($x, $y) = $window->get_position;
    $window->move($x+100, $y+100);
    ok($popupwindow->{window}->visible());
    if ($^O =~ /Win32/) {
    	ok($childpopupwindow->{window}->visible());
    } else {
    	ok(!$childpopupwindow->{window}->visible());    
    }
    return FALSE;
}

sub terminate {
    Gtk2->main_quit;
}