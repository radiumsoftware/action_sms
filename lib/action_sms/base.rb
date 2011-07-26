require 'action_mailer'

module ActionSms
  class Base
    include ::ActionMailer::AdvAttrAccessor

    if Object.const_defined?(:ActionController)
      include ::ActionController::UrlWriter
    end

    private_class_method :new #:nodoc:

    class_inheritable_accessor :view_paths
    self.view_paths = []

    cattr_accessor :logger

    @@raise_delivery_errors = true
    cattr_accessor :raise_delivery_errors

    @@perform_deliveries = true
    cattr_accessor :perform_deliveries

    @@delivery_method = :http
    cattr_accessor :delivery_method

    @@deliveries = []
    cattr_accessor :deliveries

    adv_attr_accessor :to

    adv_attr_accessor :from

    adv_attr_accessor :message

    # Specify the template name to use for current message. This is the "base"
    # template name, without the extension or directory, and may be used to
    # have multiple mailer methods share the same template.
    adv_attr_accessor :template

    # Override the mailer name, which defaults to an inflected version of the
    # mailer's class name. If you want to use a template in a non-standard
    # location, you can use this to specify that location.
    def mailer_name(value = nil)
      if value
        self.mailer_name = value
      else
        self.class.mailer_name
      end
    end

    def mailer_name=(value)
      self.class.mailer_name = value
    end

    # The sms object instance referenced by this mailer.
    attr_reader :sms
    attr_reader :template_name, :default_template_name, :action_name

    class << self
      attr_writer :mailer_name

      def mailer_name
        @mailer_name ||= name.underscore
      end

      # Default to ActionMailer's url options
      # This library uses the same configuration as ActionMailer
      def default_url_options
        ActionMailer::Base.default_url_options
      end

      # for ActionView compatibility
      alias_method :controller_name, :mailer_name
      alias_method :controller_path, :mailer_name

      def respond_to?(method_symbol, include_private = false) #:nodoc:
        matches_dynamic_method?(method_symbol) || super
      end

      def method_missing(method_symbol, *parameters) #:nodoc:
        if match = matches_dynamic_method?(method_symbol)
          case match[1]
            when 'create'  then new(match[2], *parameters).sms
            when 'deliver' then new(match[2], *parameters).deliver!
            when 'new'     then nil
            else super
          end
        else
          super
        end
      end

      # Deliver the given sms object directly. This can be used to deliver
      # a preconstructed sms object, like:
      #
      #   email = MyMailer.create_some_mail(parameters)
      #   email.set_some_obscure_header "frobnicate"
      #   MyMailer.deliver(email)
      def deliver(sms)
        new.deliver!(sms)
      end

      def template_root
        self.view_paths && self.view_paths.first
      end

      def template_root=(root)
        self.view_paths = ActionView::Base.process_view_paths(root)
      end

      private
      def matches_dynamic_method?(method_name) #:nodoc:
        method_name = method_name.to_s
        /^(create|deliver)_([_a-z]\w*)/.match(method_name) || /^(new)$/.match(method_name)
      end
    end

    # Instantiate a new mailer object. If +method_name+ is not +nil+, the mailer
    # will be initialized according to the named method. If not, the mailer will
    # remain uninitialized (useful when you only need to invoke the "receive"
    # method, for instance).
    def initialize(method_name=nil, *parameters) #:nodoc:
      create!(method_name, *parameters) if method_name
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
    end

    def perform_delivery_http(sms)
      sms.deliver
    end

    def perform_delivery_test(sms)
      deliveries << sms
    end
  end

  class Base
    include ::ActionMailer::Helpers
  end
end
