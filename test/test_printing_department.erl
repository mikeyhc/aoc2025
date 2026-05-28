-module(test_printing_department).

-include_lib("eunit/include/eunit.hrl").

sample_test() ->
    ?assertEqual({13, 43},
                 printing_department:run("data/day04_sample.txt")).

input_test() ->
    ?assertEqual({1480, 8899},
                 printing_department:run("data/day04_input.txt")).
