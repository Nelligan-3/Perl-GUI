#!C:\Strawberry\perl\bin\perl.exe
use strict;
use Tk;
use Tk::Widget;
use Tk::MsgBox;
require './action/AccountAction.pl';
require './object/AccountObject.pl';
require './service/AccountService_SQLite3.pl';
require './action/LabelTextAction.pl';
require './object/LabelTextObject.pl';
require './service/LabelTextService_SQLite3.pl';
require './Chatchannels.pl';
package Chataccounts;

sub new {
  my $class = shift;
  my $self = {
    _root => shift,
    _lang => shift,
    _txtAccountname => shift,
    _txtPassword => shift,
    _txtNewAccountname => shift,
    _txtNewPassword => shift,
    _txtNewPassword2 => shift,
    _txtNewFirstname => shift,
    _txtNewLastname => shift,
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

sub getTxtAccountname {
    my ($self) = @_;
    return $self->{_txtAccountname};
}

sub setTxtAccountname {
    my ($self, $txtAccountname) = @_;
    $self->{_txtAccountname} = $txtAccountname if defined($txtAccountname);
}

sub getTxtPassword {
    my ($self) = @_;
    return $self->{_txtPassword};
}

sub setTxtPassword {
    my ($self, $txtPassword) = @_;
    $self->{_txtPassword} = $txtPassword if defined($txtPassword);
}

sub getTxtNewAccountname {
    my ($self) = @_;
    return $self->{_txtNewAccountname};
}

sub setTxtNewAccountname {
    my ($self, $txtNewAccountname) = @_;
    $self->{_txtNewAccountname} = $txtNewAccountname if defined($txtNewAccountname);
}

sub getTxtNewPassword {
    my ($self) = @_;
    return $self->{_txtNewPassword};
}

sub setTxtNewPassword {
    my ($self, $txtNewPassword) = @_;
    $self->{_txtNewPassword} = $txtNewPassword if defined($txtNewPassword);
}

sub getTxtNewPassword2 {
    my ($self) = @_;
    return $self->{_txtNewPassword2};
}

sub setTxtNewPassword2 {
    my ($self, $txtNewPassword2) = @_;
    $self->{_txtNewPassword2} = $txtNewPassword2 if defined($txtNewPassword2);
}

sub getTxtNewFirstname {
    my ($self) = @_;
    return $self->{_txtNewFirstname};
}

sub setTxtNewFirstname {
    my ($self, $txtNewFirstname) = @_;
    $self->{_txtNewFirstname} = $txtNewFirstname if defined($txtNewFirstname);
}

sub getTxtNewLastname {
    my ($self) = @_;
    return $self->{_txtNewLastname};
}

sub setTxtNewLastname {
    my ($self, $txtNewLastname) = @_;
    $self->{_txtNewLastname} = $txtNewLastname if defined($txtNewLastname);
}

sub getTxtMsgBox {
    my ($self) = @_;
    return $self->{_txtMsgBox};
}

sub setTxtMsgBox {
    my ($self, $txtMsgBox) = @_;
    $self->{_txtMsgBox} = $txtMsgBox if defined($txtMsgBox);
}

sub doInsert {
    my ($self) = @_;
	if($self->getTxtNewAccountname() eq '' || $self->getTxtNewPassword() eq '' || $self->getTxtNewPassword2() eq '' || $self->getTxtNewPassword() ne $self->getTxtNewPassword2() || $self->getTxtNewFirstname() eq '' || $self->getTxtNewLastname() eq ''){
      $self->getRoot()->MsgBox(-title=>'Info',-message=>$self->getTxtMsgBox(),-type=>'ok')->Show();
	} else{
	  my $action = AccountAction->new();
	  $action->setForm(AccountObject->new);
	  $action->getForm()->setId(0);
	  $action->getForm()->setAccountname($self->getTxtNewAccountname());
	  $action->getForm()->setPassword($self->getTxtNewPassword());
	  $action->getForm()->setFirstname($self->getTxtNewFirstname());
	  $action->getForm()->setLastname($self->getTxtNewLastname());
	  $action->getForm()->setLang($self->getLang());
      my $errortext = $action->doInsert();
	  $action = undef;
      $self->getRoot()->MsgBox(-title=>'Info',-message=>$errortext,-type=>'ok')->Show();
	  $self->setTxtNewAccountname('');
	  $self->setTxtNewPassword('');
	  $self->setTxtNewPassword2('');
	  $self->setTxtNewFirstname('');
	  $self->setTxtNewLastname('');
	}
}

sub doLogin {
    my ($self) = @_;
	my $action = AccountAction->new();
	  $action->setForm(AccountObject->new);
	  $action->getForm()->setId(0);
	  $action->getForm()->setAccountname($self->getTxtAccountname());
	  $action->getForm()->setPassword($self->getTxtPassword());
	  $action->getForm()->setFirstname("");
	  $action->getForm()->setLastname("");
	  $action->getForm()->setLang($self->getLang());
	my @errortext = $action->doLogin();
	$action = undef;
	if($errortext[0][0] == 0){
      $self->getRoot()->MsgBox(-title=>'Info',-message=>$errortext[0][1],-type=>'ok')->Show();
	} else {
      my $cc = Chatchannels->new();
	  $cc->setAccountId($errortext[0][0]);
	  $cc->setLang($self->getLang());
	  $cc->run();
      $self->getRoot()->destroy();
	}
}

sub getALabeltexts {
	my ($self) = @_;
	my $action = LabelTextAction->new();
	$action->setForm(LabelTextObject->new());
	$action->getForm()->setId(0);
	$action->getForm()->setLang($self->getLang());
	$action->getForm()->setPage("index");
	$action->getForm()->setPosition("");
	$action->getForm()->setLabelText("");
	my %aLabeltexts = $action->doGet();
	$action = undef;
	if(defined($self->getRoot()->Widget(".cmdLogin"))){
		$self->getRoot()->Widget(".cmdLogin")->configure(-text => $aLabeltexts{"cmdLogin"});
	}
	if(defined($self->getRoot()->Widget(".lblAccountname"))){
		$self->getRoot()->Widget(".lblAccountname")->configure(-text => $aLabeltexts{"lblAccountname"});
	}
	if(defined($self->getRoot()->Widget(".lblPassword"))){
		$self->getRoot()->Widget(".lblPassword")->configure(-text => $aLabeltexts{"lblPassword"});
	}
	if(defined($self->getRoot()->Widget(".lblNewAccountname"))){
		$self->getRoot()->Widget(".lblNewAccountname")->configure(-text => $aLabeltexts{"lblNewAccountname"});
	}
	if(defined($self->getRoot()->Widget(".lblNewPassword"))){
		$self->getRoot()->Widget(".lblNewPassword")->configure(-text => $aLabeltexts{"lblNewPassword"});
	}
	if(defined($self->getRoot()->Widget(".lblNewPassword2"))){
		$self->getRoot()->Widget(".lblNewPassword2")->configure(-text => $aLabeltexts{"lblNewPassword2"});
	}
	if(defined($self->getRoot()->Widget(".lblNewFirstname"))){
		$self->getRoot()->Widget(".lblNewFirstname")->configure(-text => $aLabeltexts{"lblNewFirstname"});
	}
	if(defined($self->getRoot()->Widget(".lblNewLastname"))){
		$self->getRoot()->Widget(".lblNewLastname")->configure(-text => $aLabeltexts{"lblNewLastname"});
	}
	if(defined($self->getRoot()->Widget(".cmdNewAccount"))){
		$self->getRoot()->Widget(".cmdNewAccount")->configure(-text => $aLabeltexts{"cmdNewAccount"});
	}
	$self->setTxtMsgBox($aLabeltexts{'1'});
}

sub run {
    my ($self) = @_;
    my $mainWin = new MainWindow(-title=>'Chat');
    $self->setRoot($mainWin);
    $mainWin->Button(Name=>'cmdQuit',-text=>'X',-command=>sub {$self->getRoot()->destroy();})->grid(-row=>0,-column=>0);
    $mainWin->Radiobutton(Name=>'rdbLangEn',-text=>'English',-value=>'en',-variable=>\$self->{_lang},-command=>sub {$self->getALabeltexts();})->grid(-row=>1,-column=>0);
    $mainWin->Radiobutton(Name=>'rdbLangFr',-text=>'Français',-value=>'fr',-variable=>\$self->{_lang},-command=>sub {$self->getALabeltexts();})->grid(-row=>1,-column=>1);
    $mainWin->Radiobutton(Name=>'rdbLangEs',-text=>'Español',-value=>'es',-variable=>\$self->{_lang},-command=>sub {$self->getALabeltexts();})->grid(-row=>2,-column=>0);
    $mainWin->Radiobutton(Name=>'rdbLangPt',-text=>'Português',-value=>'pt',-variable=>\$self->{_lang},-command=>sub {$self->getALabeltexts();})->grid(-row=>2,-column=>1);
    $mainWin->Label(Name=>"lblAccountname",-text=>'')->grid(-row=>3,-column=>0);
    $mainWin->Entry(Name=>"txtAccountname",-textvariable=>\$self->{_txtAccountname})->grid(-row=>3,-column=>1);
    $mainWin->Label(Name=>"lblPassword",-text=>'')->grid(-row=>4,-column=>0);
    $mainWin->Entry(Name=>"txtPassword",-textvariable=>\$self->{_txtPassword})->grid(-row=>4,-column=>1);
    $mainWin->Button(Name=>'cmdLogin',-text=>'',-command=>sub {$self->doLogin();})->grid(-row=>5,-column=>0);
    $mainWin->Label(Name=>"lblNewAccountname",-text=>'')->grid(-row=>6,-column=>0);
    $mainWin->Entry(Name=>"txtNewAccountname",-textvariable=>\$self->{_txtNewAccountname})->grid(-row=>6,-column=>1);
    $mainWin->Label(Name=>"lblNewPassword",-text=>'')->grid(-row=>7,-column=>0);
    $mainWin->Entry(Name=>"txtNewPassword",-textvariable=>\$self->{_txtNewPassword})->grid(-row=>7,-column=>1);
    $mainWin->Label(Name=>"lblNewPassword2",-text=>'')->grid(-row=>8,-column=>0);
    $mainWin->Entry(Name=>"txtNewPassword2",-textvariable=>\$self->{_txtNewPassword2})->grid(-row=>8,-column=>1);
    $mainWin->Label(Name=>"lblNewFirstname",-text=>'')->grid(-row=>9,-column=>0);
    $mainWin->Entry(Name=>"txtNewFirstname",-textvariable=>\$self->{_txtNewFirstname})->grid(-row=>9,-column=>1);
    $mainWin->Label(Name=>"lblNewLastname",-text=>'')->grid(-row=>10,-column=>0);
    $mainWin->Entry(Name=>"txtNewLastname",-textvariable=>\$self->{_txtNewLastname})->grid(-row=>10,-column=>1);
    $mainWin->Button(Name=>'cmdNewAccount',-text=>'',-command=>sub {$self->doInsert();})->grid(-row=>11,-column=>0);
    $self->getALabeltexts();
    $self->getRoot()->MainLoop();
}
1;

my $chat = Chataccounts->new;
$chat->setLang("en");
$chat->run();
