-module(test_lobby).

-include_lib("eunit/include/eunit.hrl").

sample_test() ->
    ?assertEqual({357, 3121910778619},
                 lobby:run("data/day03_sample.txt")).

input_test() ->
    ?assertEqual({16887, 167302518850275},
                 lobby:run("data/day03_input.txt")).
