# HitCounter

[![Build status](https://github.com/FoveaCentral/hit_counter/workflows/test/badge.svg)](https://github.com/FoveaCentral/hit_counter/actions/workflows/test.yml)
[![Maintainability](https://qlty.sh/gh/FoveaCentral/projects/vaccinesignup/maintainability.svg)](https://qlty.sh/gh/FoveaCentral/projects/vaccinesignup)[![Coverage Status](https://coveralls.io/repos/github/FoveaCentral/vaccinesignup/badge.svg?branch=main&kill_cache=1)](https://coveralls.io/github/FoveaCentral/vaccinesignup?branch=main)
[![Coveralls](https://coveralls.io/repos/FoveaCentral/hit_counter/badge.svg?branch=master&service=github)](https://coveralls.io/github/FoveaCentral/hit_counter?branch=master)
[![CII Best Practices](https://www.bestpractices.dev/projects/5375/badge)](https://www.bestpractices.dev/en/projects/5375)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/FoveaCentral/hit_counter/badge)](https://scorecard.dev/viewer/?uri=github.com/FoveaCentral/hit_counter)
[![Gem Version](https://badge.fury.io/rb/hit_counter.svg)](https://badge.fury.io/rb/hit_counter)

Self-hosted Ruby version of that old 90s chestnut, `<BLINK>`the web-site hit counter`</BLINK>`.

## Installation

1. Install the gem and supporting files.

    `Gemfile`
    ```ruby
      gem 'hit_counter'
    ```

    Run:

    ```sh
      bundle
      rake hit_counter:install
    ```

2. Add a controller action to your app.

    `application_controller.rb`
    ```ruby
      def hit_counter
        return if params[:url].blank?

        # find or create a hit counter for this URL
        hc = HitCounter.get params[:url]

        # increase the tally by one
        hc.increment

        # get the image as a blob and stream it to the browser
        send_data hc.image(params[:style]).to_blob,
                  disposition: 'inline',
                  filename: "#{hc.hits}.png",
                  type: :png
     end
    ```

    `routes.rb`
    ```ruby
     get 'hit-counter' => 'application#hit_counter'
     # technically should be POST/PUT, but GET makes integration simpler
    ````

3. Add the hit-counter image tag to your site's HTML:

    ```html
      <img alt="Hit Counter" border="0" src="/hit-counter?url=https://cnn.com&style=1" />
    ````

Or try it out in `irb` with:

```ruby
require './spec/spec_helper'
hc = HitCounter.get('cnn.com')
```

## Customizing the Hit-Counter Image

### Use an Existing Style

| Name     | Style number                                                          |
| -------- | --------------------------------------------------------------------- |
| Celtic   | ![image of 3 in celtic style](/public/images/digits/celtic/3.png)     |
| Odometer | ![image of 1 in odometer style](/public/images/digits/odometer/1.png) |
| Scout    | ![image of 2 in scout style](/public/images/digits/scout/2.png)       |

You can use one of the three included styles by specifying a different `style` param in the HTML:

```html
  <img alt="Hit Counter" border="0" src="/hit-counter?url=cnn.com&style=1" />
```

### Create Your Own Style

1. To add your own style, create a PNG for each of the digits, `0.png` through `9.png`. Save the images in a folder named after your new style in `public/images/digits`.

2. In your controller, declare a new `STYLES` constant and add the folder name to it:

    ```ruby
      HitCounter::STYLES = %w(odometer scout celtic folder_name)
    ```

3. In your HTML, specify the new style with a `style` param equal to its index in the array plus one (unlike arrays, the `style` param's index is one-based):

    ```html
      <img alt="Hit Counter" border="0" src="/hit-counter?url=cnn.com&style=4" />
    ```

## Documentation

Complete RDoc documentation is available at [RubyDoc.info](https://www.rubydoc.info/gems/hit_counter).

## [Contributing to HitCounter](CONTRIBUTING.md)

## Cheers!

<a href="https://www.buymeacoffee.com/oblomov" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-green.png" alt="Buy Me A Coffee" height="41" width="174" ></a>

Copyright © 2011-2025 Roderick Monje. See LICENSE.txt for further details.
