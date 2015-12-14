require 'test_helper'
require 'record_encoder'

class RecordEncoderTest < ActiveSupport::TestCase

  DummyClass = Class.new
  DummyClassWithIncludedModule = Class.new(DummyClass) { include RecordEncoder }
  ActiveRecordSubclass = Class.new(ActiveRecord::Base) { self.abstract_class = true }
  ARSubclassWithActAs = Class.new(ActiveRecordSubclass) { acts_as_record_encoder }

  test "dummy class does not define to_bert" do
    assert_raises(NoMethodError) do
      DummyClass.to_bert
    end
  end

  test "dummy class + included module does not define to_bert" do
    assert_raises(NoMethodError) do
      DummyClassWithIncludedModule.to_bert
    end
  end

  test "dummy class inheriting from ActiveRecord::Bert does not define to_bert" do
    assert_raises(NoMethodError) do
      ActiveRecordSubclass.to_bert
    end
  end

  test "dummy class inheriting from ActiveRecord::Bert + acts_as_record_encoder responds to to_bert" do
    exception = assert_raises(LocalJumpError) do
      ARSubclassWithActAs.to_bert
    end
    assert_equal "no block given (yield)", exception.message
  end

  test "dummy class inheriting from ActiveRecord::Bert + acts_as_record_encoder responds to to_bert with block" do
    RecordEncoder::Bert.any_instance.expects(:to_bert_internal).once.returns('result')
    ARSubclassWithActAs.to_bert {}
  end

end
