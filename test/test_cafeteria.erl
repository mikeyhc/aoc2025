-module(test_cafeteria).

-include_lib("eunit/include/eunit.hrl").

sample_test() ->
    ?assertEqual({3, 14},
                 cafeteria:run("data/day05_sample.txt")).

input_test() ->
    ?assertEqual({712, 332998283036769},
                 cafeteria:run("data/day05_input.txt")).
