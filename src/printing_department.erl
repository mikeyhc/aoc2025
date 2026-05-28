-module(printing_department).

-export([run/1]).

run(Filename) ->
    Map = aoc_common:read_map(Filename),
    {part1(Map), part2(Map)}.

part1(Map) ->
    length(lists:filter(fun(V) -> has_space(V, Map) end,
                        lists:filtermap(fun({Pos, $@}) -> {true, Pos};
                                           (_) -> false
                                        end, maps:to_list(Map)))).

part2(Map) ->
    iterate(Map, 0).

iterate(Map0, Count) ->
    Builder = fun(Pos, {Map1, Changes}) ->
                      case has_space(Pos, Map0) of
                          true -> {Map1#{Pos => $.}, Changes + 1};
                          false -> {Map1, Changes}
                      end
              end,
    {Map, Changed} = lists:foldl(Builder,
                                 {Map0, 0},
                                 lists:filtermap(fun({Pos, $@}) -> {true, Pos};
                                                    (_) -> false
                                                 end, maps:to_list(Map0))),
    if Changed > 0 -> iterate(Map, Changed + Count);
       true -> Count
    end.

has_space({Row, Col}, Map) ->
    {MaxRow, MaxCol} = maps:get(size, Map),
    Matrix0 = [{Y, X} || Y <- [Row - 1, Row, Row + 1],
                         X <- [Col - 1, Col, Col + 1]],
    Matrix = lists:filter(fun({0, _C}) -> false;
                             ({_R, 0}) -> false;
                             ({R, C}) ->
                                  if R =:= Row andalso C =:= Col -> false;
                                     R > MaxRow -> false;
                                     C > MaxCol -> false;
                                     true -> true
                                  end
                          end, Matrix0),
    length(lists:filter(fun(Pos) -> maps:get(Pos, Map) =:= $@ end, Matrix)) < 4.
