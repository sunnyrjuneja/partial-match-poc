## Partial Match Proof of Concept

### Description
On this [issue](https://github.com/sourcegraph/sourcegraph.com/issues/222#issuecomment-51410223), @sqs
mentions that sourcegraph doesn't do partial matches because of performance reasons. I was curious
what performance looked like on a typeahead that did do partial matching.

For this example, I used a list of every gem available on rubygems.org (source: http://rubygems.org/latest_specs.4.8.gz).
There is 80k+ gems. I used a C implementation of the trie data structure.

### Results
The results are with no options passed to the ruby vm, default Sinatra options (WEBrick), and no caching.

Reading all gems took 1.641352094 seconds.

Adding gems to trie took 0.332437554 seconds.

Returning children for "a" took 0.076774795 seconds.

### Requirements
Ruby 2.1 (tested)

### Setup
`bundle install`
