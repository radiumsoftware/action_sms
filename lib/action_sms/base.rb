require 'action_mailer'

module ActionSMS
  class Base < ActionMailer::Base
    @@delivery_method = :http

    @@gateway_configuration = {}
    cattr_accessor :gateway_configuration

    adv_attr_accessor :to
    adv_attr_accessor :from
    adv_attr_accessor :message

    attr_reader :sms

    @@sms_deliveries = []

    def self.deliveries
      @@sms_deliveries
    end

    def self.deliveries=(obj)
      @@sms_deliveries = obj
    end

    # Initialize the mailer via the given +method_name+. The body will be
    # rendered and a new SMS::Message object created.
    def create!(method_name, *parameters) #:nodoc:
      initialize_defaults(method_name)
      __send__(method_name, *parameters)

      unless @message === String
        template_exists ||= template_root["#{mailer_name}/#{@template}"]
        @message = render_message(@template, @message) if template_exists
      end

      create_sms_message
    end

    def deliver!(sms = @sms)
      raise "no sms object available for delivery!" unless sms
      unless logger.nil?
        logger.info  "Sent sms to #{sms.to}"
        logger.debug "\n#{sms.inspect}"
      end

      begin
        __send__("perform_delivery_#{delivery_method}", sms) if perform_deliveries
      rescue Exception => e
        raise e if raise_delivery_errors
      end

      return sms
    end

    private
    # Set up the default values for the various instance variables of this
    # mailer. Subclasses may override this method to provide different
    # defaults.
    def initialize_defaults(method_name)
      @template ||= method_name
      @mailer_name ||= self.class.name.underscore
      @message ||= {}
    end

    def render_message(method_name, body)
      render :file => method_name, :body => body
    end

    def render(opts)
      body = opts.delete(:body)
      if opts[:file] && (opts[:file] !~ /\// && !opts[:file].respond_to?(:render))
        opts[:file] = "#{mailer_name}/#{opts[:file]}"
      end

      begin
        old_template, @template = @template, initialize_template_class(body)
        @template.render(opts)
      ensure
        @template = old_template
      end
    end

    def template_root
      self.class.template_root
    end

    def initialize_template_class(assigns)
      template = ActionView::Base.new(self.class.view_paths, assigns, self)
      template
    end

    def create_sms_message
      @sms = Message.new(:to => @to, :from => @from, :text => @message)
      @mail = @sms # for ActionMailer
      @sms
    end

    def perform_delivery_http(sms)
      sms.deliver
    end

    def perform_delivery_test(sms)
      ActionSMS::Base.deliveries << sms
    end
  end
end
