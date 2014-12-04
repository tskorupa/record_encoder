require 'test_helper'
require 'record_encoder'

class RecordEncoderTest < ActiveSupport::TestCase

  test "dummy class does not define to_bert" do
    assert_raises(NoMethodError) do
      dummy_class.to_bert
    end
  end

  test "dummy class + included module does not define to_bert" do
    assert_raises(NoMethodError) do
      dummy_class_with_included_module.to_bert
    end
  end

  test "dummy class inheriting from ActiveRecord::Bert does not define to_bert" do
    assert_raises(NoMethodError) do
      dummy_class_inheriting_active_record.to_bert
    end
  end

  test "dummy class inheriting from ActiveRecord::Bert + acts_as_record_encoder responds to to_bert" do
    exception = assert_raises(LocalJumpError) do
      dummy_class_with_acts_as.to_bert
    end
    assert_equal "no block given (yield)", exception.message
  end

  test "dummy class inheriting from ActiveRecord::Bert + acts_as_record_encoder responds to to_bert with block" do
    RecordEncoder::Bert.any_instance.expects(:to_bert_internal).once.returns('result')
    dummy_class_with_acts_as.to_bert {}
  end

  private

  def dummy_class
    Class.new do
      def self.name
        "Dummy"
      end
    end
  end

  def dummy_class_with_included_module
    Class.new do
      include RecordEncoder
      def self.name
        "DummyWithModule"
      end
    end
  end

  def dummy_class_inheriting_active_record
    Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      def self.name
        "DummyAR"
      end
    end
  end

  def dummy_class_with_acts_as
    Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      acts_as_record_encoder
      def self.name
        "DummyActsAs"
      end
    end
  end

end
