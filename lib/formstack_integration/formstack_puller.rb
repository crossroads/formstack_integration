require 'formstack'

module FormstackIntegration

  #
  # Gets the form from formstack and enables it to be processed.
  #
  class FormstackPuller

    #
    # @api_key - the api key of your user account provided by Formstack
    # @form_id - the form_id of the Formstack form you wish to use
    # @mapping - a hash of formstack field ids to model attributes. This
    #   is used to map formstack data into a form your model can read.
    # @field_ids_to_ignore - a list of formstack fields to exclude
    # @do_not_delete - if true, doesn't delete the formstack entry once processing is complete (default=false)
    # @processor - an instance for FormProcessor to define what data conversion should happen
    #
    def initialize(options = {})
      @api_key = options[:api_key]
      @form_id = options[:form_id]
      @mapping = Hashie::Mash.new(options[:mapping])
      @field_ids_to_ignore = options[:field_ids_to_ignore] || []
      @do_not_delete = options[:do_not_delete] || false
      @processor = options[:processor]
      @root_fields = %w(id remote_addr timestamp payment_status)
      raise "Please initialise with an api_key" if @api_key.nil?
      raise "Please initialise with a form_id" if @form_id.nil?
    end

    #
    # Process formstack submissions
    #
    def process
      @processor.process(data)
    end

    #
    # Gets the formstack form_id by looking up the form name
    #
    def form_id_from_form_name(name)
      client.forms.select{|f| f.name == name}.first.id unless (name.nil? || name.empty?)
    end

    #
    # Delete form entries once processing has finished (optional)
    #
    def delete(ids=[])
      unless @do_not_delete
        ids.each do |id|
          client.delete(id)
        end
      end
    end

    #
    # Compares @mapping with formstack form and reports which fields are missing.
    #
    def check_form_mapping_integrity
      ignore = (@field_ids_to_ignore + @root_fields).uniq
      formstack_fields = Hash[*(form.fields.map{|x| [x.id, x.name]}).flatten]
      formstack_field_keys = Set.new(formstack_fields.keys).merge(ignore)
      mapping_fields = @mapping
      mapping_field_keys = Set.new(mapping_fields.keys).merge(ignore)
      x = mapping_field_keys.difference(formstack_field_keys)
      y = formstack_field_keys.difference(mapping_field_keys)
      "Fields that are in our mapping but not on formstack: #{x.empty? ? 'none' : x.to_a.join(', ')}\n" + \
      "Fields that are on formstack but not in our mapping: #{y.to_a.map{|i| formstack_fields[i].empty? ? i : formstack_fields[i]}.join(', ')}\n" +\
      "Note the following fields are ignored or always included: #{ignore.join(', ')}\n"
    end

    #
    # Returns a hash of id to field name from the form - useful for building a mapping
    #
    def idmap
      mapping = {}
      form.fields.each{|field| mapping[field.id] = field.name}
      mapping
    end

  protected

    #
    # The formstack form
    #
    def form
      @form ||= client.form(@form_id)
    end

    #
    # The formstack data
    #
    def data
      @data ||= client.data(@form_id)
    end

    #
    # Creates a new formstack client connection
    #
    def client
      @client ||= Formstack::Client.new(@api_key)
    end

  end

end
