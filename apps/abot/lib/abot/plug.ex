defmodule Abot.Plug do

  @callback plug({String.t, DateTime.t}) :: any

end 
