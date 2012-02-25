# merimee
[![Build Status](https://secure.travis-ci.org/atwam/merimee.png)](http://travis-ci.org/atwam/merimee)

> Pour parler sans ambiguïté, ce dîner à Sainte-Adresse, près du Havre, malgré les effluves embaumés de la mer, malgré les vins de très bons crus, les cuisseaux de veau et les cuissots de chevreuil prodigués par l’amphitryon, fut un vrai guêpier.

_merimee_ adds some rspec macros (Test::Case to come ... maybe) to add automatic spell checking to your tests.

## Install

```
gem 'merimee'
```

## Usage

### Rspec/rails
Just drop a `require 'merimee'` in your `spec_helper.rb`.
It gives you the following in your views :

```ruby
describe 'splash/index' do
  it_should_have_correct_spelling
end

# Which is equivalent to
describe 'splash/logout' do
  it "should have a correct spelling" do
    render
    rendered.should have_a_correct_spelling
  end
end
```

### Standalone use

Well, you need to initalize a `Merimee::Checker` with a `Merimee::Config`

```ruby
checker = Merimee::Checker.new do |config|
  # Configure if needed
end
# checker = Merimee::Checker.new would be equivalent here
# checker = Merimee::Checker.new(Merime::Config.new) too

checker.check('This text has one BIGE error')
=> [BIGE spelling]
```

Error objects have some interesting fields (`type`, `suggestions`, `url`, `description`), inspect them to know more.

## Configuration

The config object has the following methods/arguments :

```ruby
Merime::Checker.new do |config|
  # Ignore OHAI spelling errors. This is case sensitive for now, feel free to tell me if you feel it shouldn't be the case.
  config.dict_add 'OHAI' 
  config.dict_add %w{Trealiu Chtulu} # Ignore other words, method takes any enumerable too !

  # Ignore all words contained in blah.txt, one per line
  config.dict_add_file 'blah.txt'

  # English by default, but AfterTheDeadline also supports French(fr), Spanish(es), German(de), Portuguese(pt)
  config.language = 'en' 

  # AtD says that you should provide a key, unique per use. You don't need to register/get it, but
  # you can't have more than one request on their servers at the same time with the same key.
  # Since merimee is intended for test mode, it should be fine.
  config.api_key = 'blah' 
  
  # You can ignore some types of errors.
  # Some are already ignored by default, see Merimee::DEFAULT_IGNORE_TYPES in lib/merimee/config.rb
  config.ignore 'spelling', 'grammar'
  # You can also include some types that were ignored
  config.error 'cliches', 'double negatives'
end
```

#### Configuration with RSpec
You can still modify your config within RSpec :

```ruby
#In your spec_helper.rb
require 'merimee'

RSpec.configure do |config|
  config.merimee_config.dict_add 'ignoreThisWord'
end
```

Or you can set your config in your test (for example to ignore just a word in one view) :

```ruby
describe "blah/index" do
  it_should_have_correct_spelling do |config|
    config.dict_add "mybrand"
  end
end
```

## Known issues

See http://github.com/coutud/merimee/issues
Feel free to fork, send request (especially for Test::Case ... I'm a bit lazy for that).

## License

This gem is licensed under the MIT license. See LICENSE.md

## Thanks etc.

This gem was based on some code from https://github.com/msepcot/after_the_deadline
