require 'minitest/autorun'
require 'merimee'

class ConfigTest < MiniTest::Unit::TestCase
  def setup
    @config = Merimee::Config.new
  end

  def test_ignore_type_not_empty_by_default
    refute_empty @config.ignore_types
  end

  def test_add_dict_with_word
    @config.dict_add "OHAI"
    assert_includes @config.dictionary, "OHAI"
  end

  def test_add_dict_with_array
    @config.dict_add "OHAI"
    @config.dict_add ["Foo", "Bar"]
    assert_equal ["OHAI", "Foo", "Bar"], @config.dictionary
  end
end
