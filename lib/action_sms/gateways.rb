module ActionSms
  module Gateways
    autoload :Labyrintti, 'action_sms/gateways/labyrintti'

    MAP = {
      :fi => Labyrintti
    }

  end
end
