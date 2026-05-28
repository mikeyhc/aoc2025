-module(lobby).

-export([run/1]).

run(Filename) ->
    Input = aoc_common:read_and_parse_lines(fun parse_line/1, Filename),
    {solve(Input, 2), solve(Input, 12)}.

solve(Input, Count) ->
    MaxFun = fun(Values) -> find_max_joltage(Values, Count) end,
    lists:sum(lists:map(MaxFun, Input)).

find_max_joltage(Values, Count) ->
    Fun = fun(Idx, {Length, SearchSpace, Acc}) ->
                  Depth = Length - (Count - Idx),
                  {Max, Tail} = find_max(SearchSpace, Depth, 0, undefined),
                  {length(Tail), Tail, Acc * 10 + Max}
          end,
    {_, _, Joltage} = lists:foldl(Fun, {length(Values), Values, 0},
                                  lists:seq(1, Count)),
    Joltage.

find_max(_Values, 0, Max, Tail) -> {Max, Tail};
find_max([H|T], Depth, Max, Tail) ->
    if H =:= 9 -> {H, T};
       H > Max -> find_max(T, Depth - 1, H, T);
       true -> find_max(T, Depth - 1, Max, Tail)
    end.


% helper functions

parse_line(Line) ->
    lists:map(fun(X) -> X - $0 end, Line).
