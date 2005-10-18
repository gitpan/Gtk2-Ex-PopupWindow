use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Gtk2::Ex::PopupWindow;
use Gtk2::Ex::Simple::List;
use Data::Dumper;

my $window = Gtk2::Window->new;
$window->signal_connect('destroy', sub {Gtk2->main_quit;});

my $label = Gtk2::Label->new(' Sample Label ');
my $eventbox = add_arrow($label);
my $popupwindow = Gtk2::Ex::PopupWindow->new($eventbox);

my $childlabel = Gtk2::Label->new(' Child Label ');
my $childeventbox = add_arrow($childlabel);
my $childpopupwindow = Gtk2::Ex::PopupWindow->new($childeventbox);

my $vbox = Gtk2::VBox->new (FALSE, 0);
$vbox->pack_start ($eventbox, FALSE, TRUE, 0);
$vbox->pack_start (Gtk2::Label->new, TRUE, TRUE, 0);

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
		if ($^O =~ /Win32/) {
			$popupwindow->set_move_with_parent(TRUE);
			$popupwindow->show;
		}
	}
);
$childpopupwindow->signal_connect('hide' => 
	sub {
		if ($^O =~ /Win32/) {
			$popupwindow->set_move_with_parent(FALSE);
		}
	}
);
$popupwindow->signal_connect('hide' => 
	sub {
		$childpopupwindow->hide;
	}
);
$eventbox->signal_connect('button-release-event' => sub { $popupwindow->show; } );
$childeventbox->signal_connect('button-release-event' => sub { $childpopupwindow->show; } );


$window->add ($vbox);
$window->set_default_size(400, 50);
$window->show_all;

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
