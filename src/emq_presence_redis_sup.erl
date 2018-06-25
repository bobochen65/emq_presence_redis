%%--------------------------------------------------------------------
%% Copyright (c) 2013-2018 EMQ Enterprise, Inc. (http://emqtt.io)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emq_presence_redis_sup).

-include("emq_presence_redis.hrl").
-behaviour(supervisor).
%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, Env} = application:get_env(?APP, redis_pool),
    PoolSpec = ecpool:pool_spec(?APP, ?APP, ?APP, Env),
    Server= {emq_presence_redis_server, {emq_presence_redis_server, start_link, [Env]},
    permanent, 5000, worker, [emq_presence_redis_server]},
    {ok, { {one_for_one, 0, 100}, [PoolSpec,Server]} }.

