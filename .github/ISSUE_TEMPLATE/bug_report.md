---
name: Bug report
about: Create a report to help us improve
labels: 'bug'
---

# Description

Provide as much background as you need to get the implementer up to speed on the problem to be solved. This can also include screenshots and links to other issues or pull requests.

# Steps to Reproduce

Don't forget to point out the difference between what *should* happen and what *does* happen. Here's an example:

1. Try getting the count on cnn.com:
    ```ruby
    HitCounter.get 'cnn.com'
    ```
2. The returned count is nil:
   ```ruby
   HitCounter.get 'cnn.com'
   => nil
   ```
