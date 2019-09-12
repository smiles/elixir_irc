defmodule Abot do
  def exit(reason) do
    IO.puts(reason)
    Kernel.exit(:normal)
  end 
end
