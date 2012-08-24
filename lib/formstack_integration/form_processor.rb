module FormstackIntegration

  #
  # Process a formstack form into a hash of model attributes
  #

  class FormProcessor

    def initialize(options = {})
      @mapping = options[:mapping] || {}
      @field_ids_to_ignore = options[:field_ids_to_ignore] || []
      @convertors = options[:convertors] || {}
      @root_fields = %w(id remote_addr timestamp payment_status)
    end

    #
    # 1. Remaps the fields to match model attributes using @mapping
    # 2. Serializes formstack strings to specified types
    #    e.g. turns 'true' into a ruby boolean
    #
    def process(data)
      data = remap(data)
      data = convert!(data)
      data
    end

  protected

    #
    # Maps formstack fields to model attributes using @mapping
    #
    def remap(data)
      new_data = []
      data.submissions.each do |submission|
        new_datum = Hashie::Mash.new
        extras = []
        @root_fields.each do |field|
          extras << Hashie::Mash.new(:field => field, :value => submission[field])
        end
        (submission.data + extras).each do |d|
          new_datum[(@mapping[d.field] || d.field)] = d.value unless @field_ids_to_ignore.include?(d.field)
        end
        new_data << new_datum
      end
      new_data
    end
    
    #
    # Applies registered converters on the data
    #
    def convert!(data)
      @convertors.each do |field, convertor|
        data.each do |submission|
          key = field.to_s
          if submission.has_key?(key)
            c = convertor.new(submission[key])
            submission[key] = c.convert
          end
        end
      end
      data
    end

  end

end
