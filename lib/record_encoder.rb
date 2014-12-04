require 'active_support/concern'
require 'record_encoder/bert'

module RecordEncoder
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    def acts_as_record_encoder *attributes
      @record_encoders ||= {}
      @record_encoders[:bert] ||= RecordEncoder::Bert.new self, *attributes

      extend RecordEncoder::LocalClassMethods
    end

  end

  module LocalClassMethods
    def to_bert
      @record_encoders[:bert].to_bert {|r| yield r }
    end
  end

end

ActiveRecord::Base.send :include, RecordEncoder
