Before do
  SMS.test_mode = true
  SMS.deliveries = []
end

World(SMS::Helpers)
World(SMS::Matchers)
