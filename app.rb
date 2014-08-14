require 'sinatra'
require 'trie'
require 'json'

TRIE = Trie.new

def measure_time(str)
  init = Time.now
  x = yield
  comp = Time.now
  puts "#{str} took #{comp - init} seconds."
  x
end

gems = measure_time('Reading all gems') { Marshal.load(Gem.gunzip(File.read('latest_specs.4.8.gz'))) }

measure_time 'Adding gems to trie' do
  gems.each do |gem|
    TRIE.add gem[0]
  end
end

get '/' do
<<-doc
  <!doctype>
  <html>
    <head>
      <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
      <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
      <script>
        $(function() {
          $('.autocomplete').typeahead({
            source: function(query, process) {
              return $.ajax({
                url: '/autocomplete',
                     type: 'get',
                     data: {q: query},
                     dataType: 'json',
                     success: function(json) {
                       return typeof json == 'undefined' ? false : process(json);
                     }
              });
            }
          });
        });
      </script>
      <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet">
    </head>
    <body>
      <div class="container">
        <div class="row">
          <div class="span12 text-center">
            <form style="display:inline-block;">
              <h2>Partial Match Proof of Concept</h2>
              <h3>Type the name of any gem</h3>
              <input type='text' class='autocomplete' name='autocomplete'>
            </form>
          </div>
        </div>
      </div>
    </body>
  </html>
doc
end

get '/autocomplete' do
  measure_time("Returning children for #{params[:q]}") { TRIE.children(params[:q]).to_json }
end
