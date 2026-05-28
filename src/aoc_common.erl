-module(aoc_common).

-export([read_and_parse_lines/2, read_and_parse_csv_line/2, read_map/1,
         render_map/1]).

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

read_map(Filename) ->
    {ok, BinContents} = file:read_file(Filename),
    Contents = binary_to_list(BinContents),
    Lines = lists:filter(fun(V) -> V =/= "" end,
                         string:split(Contents, "\n", all)),
    Map0 = lists:foldl(fun parse_row/2, #{},
                       lists:zip(lists:seq(1, length(Lines)), Lines)),
    Map0#{size => {length(Lines), length(hd(Lines))}}.

render_map(Map) ->
    {Rows, Cols} = maps:get(size, Map),
    Out = lists:foldl(fun(Idx, Acc) -> [render_row(Idx, Map, Cols)|Acc] end, [],
                      lists:seq(1, Rows)),
    lists:join("\n", lists:reverse(Out)).

% helper methods

parse_row({RowIdx, Line}, Acc) ->
    lists:foldl(fun(Cell, Acc0) -> parse_cell(Cell, RowIdx, Acc0) end,
                Acc,
                lists:zip(lists:seq(1, length(Line)), Line)).

parse_cell({ColIdx, Char}, RowIdx, Acc) ->
    Acc#{{RowIdx, ColIdx} => Char}.

render_row(RowIdx, Map, Cols) ->
    lists:reverse(lists:foldl(fun(ColIdx, Acc0) ->
                                      [maps:get({RowIdx, ColIdx}, Map)|Acc0]
                              end,
                              [], lists:seq(1, Cols))).
