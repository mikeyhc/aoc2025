-module(cafeteria).

-export([run/1]).

run(Filename) ->
    {Fresh, Ingredients} = aoc_common:read_and_parse_two_part(
                             fun build_range/1,
                             fun list_to_integer/1,
                             Filename),
    {part1(Fresh, Ingredients), part2(Fresh)}.

part1(Fresh, Ingredients) ->
    FilterFn = fun(I) ->
                       lists:any(fun(F) -> aoc_range:contains(I, F) end, Fresh)
               end,
    length(lists:filter(FilterFn, Ingredients)).

part2(Fresh) ->
    [H|T] = aoc_range:sort(Fresh),
    Combine = fun(R0, [R1|Acc]) ->
                      case aoc_range:conj(R0, R1) of
                          {error, no_overlap} -> [R0,R1|Acc];
                          {ok, R} -> [R|Acc]
                      end
              end,
    Combined = lists:foldl(Combine, [H], T),
    lists:sum(lists:map(fun aoc_range:size/1, Combined)).

% helper functions

build_range(Line) ->
    [L, R] = string:split(Line, "-"),
    aoc_range:new(list_to_integer(L), list_to_integer(R)).
