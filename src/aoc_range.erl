-module(aoc_range).

-export([new/2, contains/2, size/1, conj/2, sort/1]).

new(Start, End) when End < Start -> new(End, Start);
new(Start, End) ->
    {Start, End}.

contains(Point, {Start, End}) ->
    Point >= Start andalso Point =< End.

size({Start, End}) -> End - Start + 1.

conj({S0, E0}, {S1, E1}) ->
    if S0 > E1 orelse S1 > E0 -> {error, no_overlap};
       true ->
           S = if S0 < S1 -> S0; true -> S1 end,
           E = if E0 > E1 -> E0; true -> E1 end,
           {ok, {S, E}}
    end.

sort(Ranges) ->
    lists:sort(fun({S0, _}, {S1, _}) -> S0 < S1 end, Ranges).
