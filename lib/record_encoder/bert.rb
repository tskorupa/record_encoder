require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'
require 'bert'

module RecordEncoder
  class Bert

    SUPPORTED_OPTIONS = %i( primary_key delete_primary_key )

    def initialize klass, *attributes
      @klass = klass
      raise "klass can't be blank!" if @klass.blank?
      raise "klass must be a Class!" unless @klass.is_a? Class

      options = attributes.extract_options!.slice!(SUPPORTED_OPTIONS)
      @primary_key = options[:primary_key] || :id
      @delete_primary_key = options[:delete_primary_key] || true

      bert_prefix_and_suffix
    end

    def to_bert
      to_bert_internal {|r| yield r }
      nil
    end

    private

    def to_bert_internal
      yield @bert_prefix
      yield records_list_prefix
      @klass.find_each do |record|
        yield record_bert( record )
      end
      yield records_list_suffix
      yield @bert_suffix
    end

    # NOTE: records_list_prefix needs to be computed dynamically. no caching
    def records_list_prefix
      "l" + [records_count].pack("N").bytes.pack('c*')
    end

    def records_list_suffix
      "j"
    end

    # NOTE: records_count needs to be computed dynamically. no caching
    def records_count
      @klass.all.size
    end

    def encode datum, opts={}
      bert = BERT.encode( datum )
      bert = bert[1..-1] if opts.present? && opts[:offset].present?
      bert
    end

    def record_bert record
      encode record_tuple(record), offset: true
    end

    def record_tuple record
      # TODO: to enhanced performance, 'record_attributes_tuple_collection(record)' could be
      #   precomputed as a record column and accessed here directly
      tuple record.send(@primary_key), record_attributes_tuple_collection(record)
    end

    def record_attributes_tuple_collection record
      record_hash(record).collect {|k,v| tuple(k,v) }
    end

    def record_hash record
      hash = record.serializable_hash.deep_symbolize_keys
      hash.delete(@primary_key) if @delete_primary_key
      hash
    end

    def tuple key, value
      t[key, value]
    end

    def bert_prefix_and_suffix
      placeholder = [:placeholder]
      bert = encode( [ tuple(bert_name, placeholder) ] )
      placeholder_list = encode(placeholder, offset: true)
      @bert_prefix, @bert_suffix = bert.split( placeholder_list )
    end

    def bert_name
      @bert_name ||= @klass.to_s.underscore.pluralize.to_sym
    end

  end
end
