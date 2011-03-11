module SMS
  module Gateways
    autoload :Labyrintti, 'sms/gateways/labyrintti'

    MAP = {
      :fi => Labyrintti
    }

  end
end
