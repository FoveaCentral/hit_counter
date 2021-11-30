# Closes: #

## Goal
What problem does this pull request solve? This should be close to the goal of the issue this pull request addresses.

## Approach
1. **Describe, in numbered steps, the approach you chose** to solve the above problem.
    1. This will help code reviewers get oriented quickly.
    2. It will also document for future maintainers exactly what changed (and why) when this PR was merged.
2. **Add specs** that either *reproduce the bug* or *cover the new feature*. In the former's case, *make sure it fails without the fix!*
3. Document any new public methods using standard RDoc syntax, or update the existing RDoc for any modified public methods. As an example, see the RDoc for `HitCounter.get`:

```ruby
  # Returns a <code>HitCounter</code> matching the specified URL. The HitCounter
  # is created if no matching one is found. In the latter case, the hits
  # argument specifies the starting count.
  #
  # @param url [String] the URL for the site being counted
  # @param hits [Integer] the number of hits to start with
  # @return [HitCounter] the site's HitCounter
  # @example
  #   hc = HitCounter.get 'cnn.com'
  #   hc = HitCounter.get 'cnn.com', 100
  def self.get(url, hits = 0)
    args = { url: normalize_url(url) }
    args[:hits] = hits unless where(conditions: args).exists?
    find_or_create_by args
  end
```

Signed-off-by: YOUR NAME <YOUR.EMAIL@EXAMPLE.COM>
