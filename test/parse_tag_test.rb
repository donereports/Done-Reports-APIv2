require_relative './test_helper'

class QueryTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def parse_tags(string)
    Tag.parse_str string
  end

  def test_parse_leading_tag
    tags = parse_tags "#tag some text here"
    assert_equal ["tag"], tags
  end

  def test_parse_trailing_tag
    tags = parse_tags "some text here #tag"
    assert_equal ["tag"], tags
  end

  def test_parse_multiple_tags
    tags = parse_tags "some #tags #in #the middle"
    assert_equal ["tags","in","the"], tags
  end

  def test_reject_short_tags
    tags = parse_tags "this tag #m is too short"
    assert_equal [], tags
  end

  def test_parse_numeric_tags
    tags = parse_tags "#fo0 #111 #6bb"
    assert_equal ["fo0", "111", "6bb"], tags
  end

  def test_duplicate_tags
    tags = parse_tags "foo #bar #bar"
    assert_equal ["bar"], tags
  end

end
