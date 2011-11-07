module ActionSMS
  module Gateways
    autoload :Labyrintti, 'action_sms/gateways/labyrintti'

    MAP = {
      '358' => Labyrintti
    }

  end
end
