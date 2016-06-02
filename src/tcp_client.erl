%%%-------------------------------------------------------------------
%%% @author bylek
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2016 19:01
%%%-------------------------------------------------------------------
-module(tcp_client).
-author("bylek").

-export([start_client/0]).
-define(Port, 9000).
-define(Connections, 10).

start_client() ->
  Pid = spawn_link(fun() ->
    spawn(fun() -> connect(?Connections) end),
    timer:sleep(infinity)
  end),
  {ok, Pid}.

connect(Count) when Count > 0 ->
  spawn(fun() -> send() end),
  connect(Count - 1);

connect(0) -> ok.

send() ->
  {ok, Socket} = gen_tcp:connect("localhost", ?Port, [{active, false}, {packet, 2}]),
  gen_tcp:send(Socket, "Some Data"),
  {ok, Msg} = gen_tcp:recv(Socket, 0),
  gen_tcp:close(Socket),
  Msg.