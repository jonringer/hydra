use strict;
use Setup;
use Data::Dumper;
my %ctx = test_init();

require Hydra::Schema;
require Hydra::Model::DB;
require Hydra::Helper::Nix;

use Test2::V0;
require Catalyst::Test;
use HTTP::Request::Common;
Catalyst::Test->import('Hydra');

my $db = Hydra::Model::DB->new;
hydra_setup($db);

my $project = $db->resultset('Projects')->create({name => "tests", displayname => "", owner => "root"});

my $jobset = createBaseJobset("basic", "basic.nix", $ctx{jobsdir});

ok(evalSucceeds($jobset), "Evaluating jobs/basic.nix should exit with return code 0");

subtest "/evals" => sub {
    my $global = request(GET '/evals');
    ok($global->is_success, "The page showing the all evals returns 200.");
};

done_testing;
