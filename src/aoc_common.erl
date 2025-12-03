-module(aoc_common).

-export([read_and_parse_lines/2]).

read_and_parse_lines(Parser, Filename) ->
    lists:foldl(fun(F, V) -> F(V) end,
                file:read_file(Filename),
                [fun({ok, V}) -> binary_to_list(V) end,
                 fun(V) -> string:split(V, "\n", all) end,
                 fun(V) -> lists:filter(fun(X) -> X =/= "" end, V) end,
                 fun(V) -> lists:map(Parser, V) end
                ]).
