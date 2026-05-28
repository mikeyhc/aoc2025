-module(aoc_common).

-export([read_and_parse_lines/2, read_and_parse_csv_line/2]).

read_and_parse_lines(Parser, Filename) ->
    lists:foldl(fun(F, V) -> F(V) end,
                file:read_file(Filename),
                [fun({ok, V}) -> binary_to_list(V) end,
                 fun(V) -> string:split(V, "\n", all) end,
                 fun(V) -> lists:filter(fun(X) -> X =/= "" end, V) end,
                 fun(V) -> lists:map(Parser, V) end
                ]).

read_and_parse_csv_line(Parser, Filename) ->
    {ok, IoDevice} = file:open(Filename, read),
    {ok, Line} = file:read_line(IoDevice),
    ok = file:close(IoDevice),
    lists:foldl(fun(F, V) -> F(V) end,
                Line,
                [fun(V) -> string:trim(V, both) end,
                 fun(V) -> string:split(V, ",", all) end,
                 fun(V) -> lists:map(Parser, V) end
                ]).
