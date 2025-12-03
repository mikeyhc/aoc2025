-module(secret_entrance).

-export([run/1]).

-define(MAX, 100).

run(Filename) ->
    Input = aoc_common:read_and_parse_lines(fun parse_line/1, Filename),
    {part1(Input), part2(Input)}.

part1(Input) ->
    Fn = fun(V, Acc=[H|_]) -> [apply_turn(V, H)|Acc] end,
    length(lists:filter(fun(V) -> V =:= 0 end,
                        lists:foldl(Fn, [50], Input))).

part2(Input) ->
    {_, Count} = lists:foldl(fun apply_click/2, {50, 0}, Input),
    Count.

apply_turn({r, V}, Pos) -> (Pos + V) rem ?MAX;
apply_turn({l, V}, Pos) ->
    T = Pos - V rem ?MAX,
    if T < 0 -> T + ?MAX;
       true -> T
    end.

apply_click({r, V}, {Pos0, Count0}) ->
    Pos1 = (Pos0 + V) rem ?MAX,
    Count1 = Count0 + (Pos0 + V) div ?MAX,
    {Pos1, Count1};
apply_click({l, V}, {Pos0, Count0}) ->
    Pos1 = (Pos0 - V) rem ?MAX,
    Count1 = Count0 + abs((Pos0 - V) div ?MAX),
    Pos2 = if Pos1 < 0 -> Pos1 + ?MAX;
              true -> Pos1
           end,
    Count2 = if Pos0 > 0 andalso Pos1 =< 0 -> Count1 + 1;
                true -> Count1
             end,
    {Pos2, Count2}.

parse_line([$L|V]) -> {l, list_to_integer(V)};
parse_line([$R|V]) -> {r, list_to_integer(V)}.
