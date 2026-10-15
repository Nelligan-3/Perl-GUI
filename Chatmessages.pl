#!C:\Strawberry\perl\bin\perl.exe
use strict;
use Tk;
use Tk::Widget;
use Tk::MsgBox;
require './action/MessageAction.pl';
require './object/MessageObject.pl';
require './service/MessageService_SQLite3.pl';
require './action/LabelTextAction.pl';
require './object/LabelTextObject.pl';
require './service/LabelTextService_SQLite3.pl';
package Chatmessages;

sub new {
  my $class = shift;
  my $self = {
    _root => shift,
    _lang => shift,
    _channel_id => shift,
    _account_id => shift,
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

sub getChannelId {
    my ($self) = @_;
    return $self->{_channel_id};
}

sub setChannelId {
    my ($self, $channel_id) = @_;
    $self->{_channel_id} = $channel_id if defined($channel_id);
}

sub getAccountId {
    my ($self) = @_;
    return $self->{_account_id};
}

sub setAccountId {
    my ($self, $account_id) = @_;
    $self->{_account_id} = $account_id if defined($account_id);
}

sub getTxtMessage {
    my ($self) = @_;
    return $self->{_txtMessage};
}

sub setTxtMessage {
    my ($self, $txtMessage) = @_;
    $self->{_txtMessage} = $txtMessage if defined($txtMessage);
}

sub getTxtMsgBox {
    my ($self) = @_;
    return $self->{_txtMsgBox};
}

sub setTxtMsgBox {
    my ($self, $txtMsgBox) = @_;
    $self->{_txtMsgBox} = $txtMsgBox if defined($txtMsgBox);
}

sub getMLabeltexts {
	my ($self) = @_;
	my $action = LabelTextAction->new();
	$action->setForm(LabelTextObject->new);
	$action->getForm()->setId(0);
	$action->getForm()->setLang($self->getLang());
	$action->getForm()->setPage("messages");
	$action->getForm()->setPosition("");
	$action->getForm()->setLabelText("");
	my %mLabeltexts = $action->doGet();
	$action = undef;
	if(defined($self->getRoot()->Widget(".lblMessage"))){
		$self->getRoot()->Widget(".lblMessage")->configure(-text => $mLabeltexts{"lblMessage"});
	}
	if(defined($self->getRoot()->Widget(".cmdNewMessage"))){
		$self->getRoot()->Widget(".cmdNewMessage")->configure(-text => $mLabeltexts{"cmdNewMessage"});
	}
	$self->setTxtMsgBox($mLabeltexts{"1"});
}

sub getMessages {
	my ($self) = @_;
	$self->getRoot()->Widget(".txtMessages")->delete("1.0", "end");
	my $action = MessageAction->new();
	$action->setForm(MessageObject->new);
	$action->getForm()->setId(0);
	$action->getForm()->setAccountId(0);
	$action->getForm()->setChannelId($self->getChannelId());
	$action->getForm()->setMessage("");
	$action->getForm()->setLang($self->getLang());
	my %jsonMessages = $action->doGet();
	$action = undef;
	my $cpt = 1;
    foreach my $message (keys %jsonMessages){
      $cpt = $cpt + 1;
	  $self->getRoot()->Widget(".txtMessages")->insert("end", $jsonMessages{$message}{"accountname"} . " : " . $jsonMessages{$message}{"time"} . "\n" . $jsonMessages{$message}{"message"} . "\n\n");
	}
}

sub doInsert {
	my ($self) = @_;
	my $amessage = $self->getRoot()->Widget(".txtMessage")->get('1.0','end');
	$amessage =~ s/unistr\u0028//g;
	$amessage =~ s/\u000a\u0029//g;
	$self->setTxtMessage($amessage);
	if($self->getTxtMessage() eq ""){
	  $self->getRoot()->MsgBox(-title=>'Info',-message=>$self->getTxtMsgBox(),-type=>'ok')->Show();
	} else{
	  my $action = MessageAction->new();
	  $action->setForm(MessageObject->new);
	  $action->getForm()->setId(0);
	  $action->getForm()->setAccountId($self->getAccountId());
	  $action->getForm()->setChannelId($self->getChannelId());
	  $action->getForm()->setMessage($self->getTxtMessage());
	  $action->getForm()->setLang($self->getLang());
	  $action->doInsert();
	  $action = undef;
	  $self->getRoot()->Widget(".txtMessage")->delete('1.0','end');
	  $self->setTxtMessage("");
	  $self->getMessages();
	}
}

sub run {
    my ($self) = @_;
    my $mainWin = new MainWindow(-title=>'Chat');
    $self->setRoot($mainWin);
    $mainWin->Text(Name=>"txtMessages",-height=>20,-width=>40,-bg=>"grey",-fg=>"black")->grid(-row=>0,-column=>0);
	$mainWin->Widget(".txtMessages")->tagConfigure('find',-background => 'white',-font => "9x15bold");
	#$mainWin->Scrollbar(Name=>"sclMessages")->configure(-command => ['yview' => $self->getRoot()->Widget(".txtMessages")]);
    $mainWin->Label(Name=>"lblMessage",-text=>'')->grid(-row=>1,-column=>0);
    $mainWin->Text(Name=>"txtMessage",-bg=>"grey",-fg=>"black",-height=>20,-width=>40)->grid(-row=>2,-column=>0);
    $mainWin->Button(Name=>'cmdNewMessage',-text=>'',-command=>sub {$self->doInsert();})->grid(-row=>3,-column=>0);
    $mainWin->Button(Name=>'cmdQuit',-text=>'X',-command=>sub {$self->getRoot()->destroy();})->grid(-row=>3,-column=>1);
    $self->getMLabeltexts();
    $self->getRoot()->MainLoop();
}
1;
