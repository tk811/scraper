#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use Mojo::Base -strict;
use Mojo::UserAgent;
use Mojo::DOM;


my $ua = Mojo::UserAgent
    ->new(max_redirects => 5);



#my $response = $ua->get('http://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=PEP_2014_PEPANNRES&src=pt' =>
#                 { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:44.0) Gecko/20100101 Firefox/44.0' })->res;


##Example 1: Print the text of the title element.
#say $response->dom->at('title')->text; 


##Example 2: Print all links in the page.
#say $response->dom->find('a[href]')         #Find all <a> tags that have href values
#                ->map(sub{ $_->{href}})     #Apply ->{href} to each result
#                ->join("\n");               #Join the resulting array with a newline separator.


#Example 3: Call JSON API and extract data from an HTML table.    
my $response = $ua->get('http://factfinder.census.gov/tablerestful/tableServices/renderProductData?renderForMap=f&renderForChart=f&pid=PEP_2014_PEPANNRES' =>
                 { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:44.0) Gecko/20100101 Firefox/44.0' })->res;
#
##$table_data will contain html table
my $table_data = $response->json->{ProductData}->{productDataTable}; 


my %data = Mojo::DOM->new($table_data)->find('#data tr')->map(
    sub {
        $_->at('th.left')->text
        =>
        $_->find('td')->map('text');   
    }
)->each;

#say "Florida" . $data{Florida};

my $key;
foreach $key (sort keys %data) {
    say "$key : ". $data{$key}->join(" | ") if scalar @{$data{$key}} > 0;
}
