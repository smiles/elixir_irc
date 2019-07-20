defmodule ElixirIRC.IRCClient do

  @enforce_keys [:server, :port, :user, :nick]

  defstruct [

    :server,
    :port,
    :user,
    :nick
  
  ]


end 
