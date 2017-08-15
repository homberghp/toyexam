#!/usr/bin/perl -w

sub digits;
sub field;
sub checkbox;
sub preamble;
sub trailer;
use Config::Properties;
my $defproperties = new Config::Properties();
my ($key,$value,@checks);
open PROPS, "/home/hom/teambin/fontys.properties" or die "unable to open ../fontys.properties file\n";
$defproperties->load(*PROPS);
close(PROPS);

my $fdfKeyMap = {
    'progresscode' => 'Opdracht 1 ToetscodeRow1',
    'ontvanger'   => 'Naam ontvanger in blokletters',
    'project'     => 'Project vrij in te vullen',
    'datum_aanlevering' => 'Datum aanlevering',
    'datum_gereed' =>'Datum gereed 1',
    'aantal_originelen' => 'Aantal originelen 2Row1',
    'oplage' => 'Oplage 3Row1'
};

# foreach $key ( sort(keys %$fdfKeyMap)){
#     print STDERR qq($key => $fdfKeyMap->{$key}\n);
# }
# #exit(0);

preamble();

my %props =$defproperties->properties;
while ( ($key,$value) = each %props){
#    print STDERR qq($key => $value\n);
    if ($key =~ m/\.digits/ ) {
	$key =~ s/\.digits//;
	digits($key,$value);
    } elsif ($key =~ m/checkbox/) {
	@checks = split/,/,$value;
	checkbox(@checks);
    } else {
	if (exists $fdfKeyMap->{$key}) {
#	    print STDERR qq(mapped $key => $fdfKeyMap->{$key}\n);
	    $key=$fdfKeyMap->{$key};
	}
	field($key,$value);
    }
}
field('Aantal originelen 2Row1','1 forms.pdf (131 pag), 65 bestanden s*.pdf (482 pag, 260 vellen)');
field('Oplage 3Row1','131+482=613 paginas op 131+ 260 = 391 vellen');
field('OmschrijvingRow1_2','forms.pdf zijn antwoordbladen, s*.pdf de vragen');
trailer();
exit(0);

# digits('PCNnummer','879417');
# field('Naam','Pieter van den Hombergh');
# field('Instituutorganisatieonderdeel','FTHenL');
# field('Telefoon','08850 79417');
# field('Afleveradres','Tegelsweg 255, 5912 BG, Venlo K 0.84'); 
# digits('Kostenplaats','047320');
# digits('BU','00047');
# digits('Product','200');
# field('OmschrijvingRows','Individueel tentamen\n\nSorteren op achternaam = bestandsnaamvolgorde');
# field('Email','p.vandenhombergh@fontys.nl');
# field('Project vrij in te vullen','Auto Multiple Choice');
# field('Datum aanlevering','2016-05-19');
# field('Datum gereed 1','2016-06-01');
# field('Naam ontvanger in blokletters','Angelique Bakkers');
# field('Aantal originelen 2Row1','60');
# field('Oplage 3Row1','1');
# field('Opdracht 1 ToetscodeRow1','MOD2T1I15');
# field('OmschrijvingRow1_2','Tentamen MOD2 2016-06-01');
# checkbox(4,6,7,9,10);
# trailer();
# exit(0);

sub digits {
    my @params=@_;
    my $prefix=$params[0];
    my $ds=$params[1];
    my (@parts) = split//,$ds;
    my $pos;
    for ($i =0; $i <= $#parts; $i++) {
	$pos=$i+1;
	print qq(<<
/V ($parts[$i])
/T (${prefix}${pos})
>> 
);
    }
}

sub checkbox{
    my @params=@_;
    for ($i =0; $i <= $#params; $i++) {
    print qq(<<
/V (Ja)
/T (Check Box$params[$i])
>>
);  
    }
}

sub field{
    my @params=@_;
    my $key=$params[0];
    my $value=$params[1];
    print qq(<<
/V (${value})
/T (${key})
>>
);
}

sub trailer{
print qq(]>>
>>
endobj 
trailer

<<
/Root 1 0 R
>>
%%EOF
);
}

sub preamble{
print qq(%FDF-1.2
%âãÏÓ
1 0 obj 
<<
/FDF 
<<
/Fields [
);
}
