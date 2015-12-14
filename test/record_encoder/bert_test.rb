require 'test_helper'
require 'record_encoder/bert'

class RecordEncoderBertTest < ActiveSupport::TestCase

  test "instantiation requires at least one argument" do
    error = assert_raise(ArgumentError) do
      RecordEncoder::Bert.new
    end
    assert_equal "wrong number of arguments (0 for 1+)", error.message
  end

  test "instantiation requires a valid argument" do
    error = assert_raise(RuntimeError) do
      RecordEncoder::Bert.new ""
    end
    assert_equal "klass can't be blank!", error.message
  end

  test "instantiation requires a Class as argument" do
    error = assert_raise(RuntimeError) do
      RecordEncoder::Bert.new 123
    end
    assert_equal "klass must be a Class!", error.message
  end

  test "requires a block" do
    error = assert_raise(LocalJumpError) do
      RecordEncoder::Bert.new( Class ).to_bert
    end
    assert_equal "no block given (yield)", error.message
  end

  test "takes a block" do
    encoder = RecordEncoder::Bert.new( Class )
    encoder.expects(:to_bert_internal).once.yields('result')
    assert_nil encoder.to_bert {}
  end

end
