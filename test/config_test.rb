require 'minitest/autorun'
require 'merimee'

class ConfigTest < MiniTest::Unit::TestCase
  def setup
    @config = Merimee::Config.new
  end

  def test_some_types_ignored_by_default
    assert @config.severity.any? {|k,v| v == :ignore }
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
