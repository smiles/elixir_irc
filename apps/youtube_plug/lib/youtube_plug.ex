defmodule YoutubePlug do
  def plug({irc, time}) do
    String.split(irc, " ")
    |> process_yt
  end 

  defp title(url) do
    youtube = Httpoison.get(url)
    Floki.find(youtube.body, "title")
    |> List.first
    |> elem(2)
    |> List.first 
  end

  defp its_youtube?(url) do
    String.starts_with?(url, "https://www.youtube.com")  
  end 

  defp process_yt([head|tail]) do
    if its_youtube(head) do
      title(head)
    else
      process_yt(tail)
    end 
  end 

  defp process_yt([]) do
  end 
end
