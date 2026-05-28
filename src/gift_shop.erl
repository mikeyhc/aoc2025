-module(gift_shop).

-export([run/1]).

-define(MAX_GEN_VALUE, 99999).
-define(MAX_VALUE, 99999999999).

run(Filename) ->
    Input = aoc_common:read_and_parse_csv_line(fun parse_value/1, Filename),
    {solve(Input, generate_double_values()),
     solve(Input, generate_all_values())}.

solve(Input, Invalid) ->
    Output = lists:flatmap(fun(Ids) -> validate_ids(Ids, Invalid) end,
                           lists:map(fun({Min, Max}) -> lists:seq(Min, Max) end,
                                     Input)),
    sets_sum(sets:from_list(Output)).

sets_sum(Set) ->
    sets:fold(fun(X, Acc) -> X + Acc end, 0, Set).

validate_ids(Ids, Invalid) ->
    lists:filter(fun(Id) -> sets:is_element(Id, Invalid) end, Ids).

%% generators

generate_double_values() ->
    generate_double_values_(lists:seq(1, ?MAX_GEN_VALUE), sets:new()).

generate_double_values_([], Acc) -> Acc;
generate_double_values_([H|T], Acc0) ->
    Multi = find_multi(H),
    Acc = sets:add_element(H * Multi + H, Acc0),
    generate_double_values_(T, Acc).

generate_all_values() ->
    generate_all_values_(lists:seq(1, ?MAX_GEN_VALUE), sets:new()).

generate_all_values_([], Acc) -> Acc;
generate_all_values_([H|T], Acc0) ->
    Acc = lists:foldl(fun(V, A) -> sets:add_element(V, A) end,
                      Acc0,
                      generate_values(H)),
    generate_all_values_(T, Acc).

generate_values(N) ->
    Multi = find_multi(N),
    generate_values_(N, N, Multi, []).

generate_values_(N, Last, Multi, Acc) ->
    Current = Last * Multi + N,
    if Current > ?MAX_VALUE -> Acc;
       true ->
           generate_values_(N, Current, Multi, [Current|Acc])
    end.

find_multi(N) ->
    find_multi_(N, 1).

find_multi_(0, Acc) -> Acc;
find_multi_(N, Acc) ->
    find_multi_(N div 10, Acc * 10).

parse_value(Input) ->
    Parts = string:split(Input, "-"),
    Nums = lists:map(fun list_to_integer/1, Parts),
    list_to_tuple(Nums).
