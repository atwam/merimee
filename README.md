# merimee

> Pour parler sans ambiguïté, ce dîner à Sainte-Adresse, près du Havre, malgré les effluves embaumés de la mer, malgré les vins de très bons crus, les cuisseaux de veau et les cuissots de chevreuil prodigués par l’amphitryon, fut un vrai guêpier.

_merimee_ adds some `rspec` macros (`Test::Case` to come ... maybe) to add automatic spell checking to your tests.

## Install

```
gem 'merimee'
```

## Configuration

The config object has the following methods/arguments :
```
Merime::Checker.new do |config|
  config.dict_add 'OHAI' # Ignore OHAI spelling errors. This is case sensitive for now, feel free to tell me if you feel it shouldn't be the case.
  config.dict_add %w{Trealiu Chtulu} # Ignore other words, method takes any enumerable too !
  config.dict_add_file 'blah.txt' # Ignore all words from blah.txt, one per line
  config.language = 'en' # English by default, but AfterTheDeadline also supports French(fr), Spanish(es), German(de), Portuguese(pt)
  # AtD says that you should provide a key, unique per use. You don't need to register/get it, but
  # you can't have more than one request on their servers at the same time with the same key.
  # Since merimee is intended for test mode, it should be fine.
  config.api_key = 'blah' # See AtD documentation here : it's not needed, the gem is smart enough, especially in test mode
  
  config.ignore_types << 'spelling' # You can ignore some types of errors.
end
```

## Usage

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

#### Configuration with RSpec
You can still modify your config within RSpec :

```ruby In your spec_helper.rb
require 'merimee'

RSpec.configure do |config|
  config.merimee_config.dict_add 'ignoreThisWord'
end
```

## Known issues

See http://github.com/coutud/merimee/issues

## Thanks etc.

This gem was based on some code from https://github.com/msepcot/after_the_deadline
