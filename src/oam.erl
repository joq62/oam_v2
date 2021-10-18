%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(oam).  
    
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-define(ClusterNodes,['controller@c0','controller@c2']).

%% External exports
-export([
	 start/0,
	 sd_all/0,
	 restart/1,
	 restart/0
	]).


%% ====================================================================
%% External functions
%% ====================================================================
start()->
   
    Ping=[{Node,net_adm:ping(Node)}||Node<-?ClusterNodes],
    io:format("Ping ~p~n",[{Ping,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    ok.

%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
sd_all()->
    rpc:multicall(?ClusterNodes,sd,all,[],1000).

%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
restart(Host)->
    
    I=[{Node,misc_node:vmid_hostid(Node)}||Node<-?ClusterNodes],
    case I of
	[]->
	    {error,[not_not_running,Host]};
	_->
	    case [Node||{Node,{_,HostId}}<-I,HostId=:=Host] of
		[]->
		    {error,[not_not_running,Host]};
		[NodeToRestart]->
		    ShutdownMsg=rpc:call(NodeToRestart,os,cmd,["shutdown -r"],2000),
		    io:format("ShutdownMsg ~p~n",[{ShutdownMsg,?MODULE,?FUNCTION_NAME,?LINE}]),
		    ShutdownMsg
	    end
    end.
%% --------------------------------------------------------------------
%% Function:start
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
restart()->    
    [{Node,rpc:call(Node,os,cmd,["shutdown -r"],2000)}||Node<-?ClusterNodes].
