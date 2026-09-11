#!C:\Strawberry\perl\bin\perl.exe
use strict;
use Tk;
use Tk::Widget;
use Tk::MsgBox;
require './action/ChannelAction.pl';
require './object/ChannelObject.pl';
require './service/ChannelService_SQLite3.pl';
require './action/LabelTextAction.pl';
require './object/LabelTextObject.pl';
require './service/LabelTextService_SQLite3.pl';
require './Chatmessages.pl';
package Chatchannels;

sub new {
  my $class = shift;
  my $self = {
    _root => shift,
    _lang => shift,
    _account_id => shift,
    _rdbChannel => shift,
    _txtName => shift,
    _txtMsgBox => shift,
  };
  bless $self, $class;
  return $self;
}

sub getRoot {
    my ($self) = @_;
    return $self->{_root};
}

sub setRoot {
    my ($self, $root) = @_;
    $self->{_root} = $root if defined($root);
}

sub getLang {
    my ($self) = @_;
    return $self->{_lang};
}

sub setLang {
    my ($self, $lang) = @_;
    $self->{_lang} = $lang if defined($lang);
}

sub getAccountId {
    my ($self) = @_;
    return $self->{_account_id};
}

sub setAccountId {
    my ($self, $account_id) = @_;
    $self->{_account_id} = $account_id if defined($account_id);
}

sub getRdbChannel{
    my ($self) = @_;
    return $self->{_rdbChannel};
}

sub setRdbChannel {
    my ($self, $rdbChannel) = @_;
    $self->{_rdbChannel} = $rdbChannel if defined($rdbChannel);
}

sub getTxtName {
    my ($self) = @_;
    return $self->{_txtName};
}

sub setTxtName {
    my ($self, $txtName) = @_;
    $self->{_txtName} = $txtName if defined($txtName);
}

sub getTxtMsgBox {
    my ($self) = @_;
    return $self->{_txtMsgBox};
}

sub setTxtMsgBox {
    my ($self, $txtMsgBox) = @_;
    $self->{_txtMsgBox} = $txtMsgBox if defined($txtMsgBox);
}

sub getCLabeltexts {
	my ($self) = @_;
	my $action = LabelTextAction->new();
	$action->setForm(LabelTextObject->new);
	$action->getForm()->setId(0);
	$action->getForm()->setLang($self->getLang());
	$action->getForm()->setPage("channels");
	$action->getForm()->setPosition("");
	$action->getForm()->setLabelText("");
	my %cLabeltexts = $action->doGet();
	$action = undef;
	if(defined($self->getRoot()->Widget(".lblName"))){
		$self->getRoot()->Widget(".lblName")->configure(-text => $cLabeltexts{"lblName"});
	}
	if(defined($self->getRoot()->Widget(".cmdNewChannel"))){
		$self->getRoot()->Widget(".cmdNewChannel")->configure(-text => $cLabeltexts{"cmdNewChannel"});
	}
	$self->setTxtMsgBox($cLabeltexts{"1"});
}

sub doSelect {
	my ($self) = @_;
	my $cm = Chatmessages->new;
	$cm->setLang($self->getLang());
	$cm->setAccountId($self->getAccountId());
	$cm->setChannelId($self->getRdbChannel());
	$cm->run();
}

sub getChannels {
	my ($self) = @_;
	my $action = ChannelAction->new();
	$action->setForm(ChannelObject->new);
	$action->getForm()->setId(0);
	$action->getForm()->setAccountId(0);
	$action->getForm()->setName("");
	$action->getForm()->setLang($self->getLang());
	my %jsonChannels = $action->doGet();
	$action = undef;
	my $cpt = 1;
    foreach my $channel (keys %jsonChannels){
      $cpt = $cpt + 1;
	  if(defined($self->getRoot()->Widget(".rdbChannel" . $channel))){
	    $self->getRoot()->Widget(".rdbChannel" . $channel)->destroy();
	  }
      $self->getRoot()->Radiobutton(Name => "rdbChannel" . $channel,-text=>$jsonChannels{$channel},-value=>$channel,-variable=>\$self->{_rdbChannel},-command=>sub {$self->doSelect();})->grid(-row=>$cpt,-column=>0);
	}
}

sub doInsert {
    my ($self) = @_;
	if($self->getTxtName() eq ""){
      $self->getRoot()->MsgBox(-title=>'Info',-message=>$self->getTxtMsgBox(),-type=>'ok')->Show();
	} else{
	  my $action = ChannelAction->new();
	  $action->setForm(ChannelObject->new);
	  $action->getForm()->setId(0);
	  $action->getForm()->setAccountId($self->getAccountId());
	  $action->getForm()->setName($self->getTxtName());
	  $action->getForm()->setLang($self->getLang());
	  $action->doInsert();
	  $action = undef;
	  $self->setTxtName("");
	  $self->getChannels();
	}
}

sub run {
    my ($self) = @_;
    my $mainWin = new MainWindow(-title=>'Chat');
    $self->setRoot($mainWin);
    $mainWin->Label(Name=>"lblName",-text=>'')->grid(-row=>0,-column=>0);
    $mainWin->Entry(Name=>"txtName",-textvariable=>\$self->{_txtName})->grid(-row=>0,-column=>1);
    $mainWin->Button(Name=>'cmdNewChannel',-text=>'',-command=>sub {$self->doInsert();})->grid(-row=>1,-column=>0);
    $mainWin->Button(Name=>'cmdQuit',-text=>'X',-command=>sub {$self->getRoot()->destroy();})->grid(-row=>1,-column=>1);
    $self->getCLabeltexts();
    $self->getRoot()->MainLoop();
}
1;
