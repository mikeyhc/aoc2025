-module(test_gift_shop).

-include_lib("eunit/include/eunit.hrl").

sample_test() ->
    ?assertEqual({1227775554, 4174379265},
                 gift_shop:run("data/day02_sample.txt")).

input_test() ->
    ?assertEqual({20223751480, 30260171216},
                 gift_shop:run("data/day02_input.txt")).
