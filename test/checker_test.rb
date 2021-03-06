require 'minitest/autorun'
require 'merimee'

require 'digest/sha1'

class CheckerTest < MiniTest::Unit::TestCase
  ATD_SLEEP = 0.7
  def setup
    @checker = Merimee::Checker.new
  end

  def test_check_perfect_text
    sleep ATD_SLEEP # Make sure we sleep a bit, AtD returns 503 if requests are too close
    errors = @checker.check("Perfect text")
    assert_empty errors
  end

  def test_text_with_errors
    erroneous_text = "Wrong text garanteed with errors"
    sleep ATD_SLEEP # Make sure we sleep a bit, AtD returns 503 if requests are too close
    errors = @checker.check(erroneous_text)

    refute_empty errors
    assert_equal "garanteed", errors.first.string
  end
end
