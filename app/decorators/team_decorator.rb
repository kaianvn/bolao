class TeamDecorator < Draper::Decorator
  delegate_all

  def flag
    logo_url.presence || "http://e.imguol.com/futebol/brasoes-redondos/100x100-borda-preta/#{slug}.png"
  end

end

