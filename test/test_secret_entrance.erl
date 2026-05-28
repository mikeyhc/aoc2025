-module(test_secret_entrance).

-include_lib("eunit/include/eunit.hrl").

sample_test() ->
    ?assertEqual({3, 6}, secret_entrance:run("data/day01_sample.txt")).

input_test() ->
    ?assertEqual({1191, 6858}, secret_entrance:run("data/day01_input.txt")).
