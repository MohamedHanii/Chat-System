Elasticsearch::Model.client = Elasticsearch::Client.new log: true, host: ENV['ES_HOST'], retry_on_failure: true

# Define custom analyzer
Elasticsearch::Model.client.indices.create(index: Message.index_name,
    body: {
      settings: {
        analysis: {
          tokenizer: {
            ngram_tokenizer: {
              type: 'ngram',
              min_gram: 3,
              max_gram: 20,
              token_chars: ['letter', 'digit']
            }
          },
          analyzer: {
            custom_analyzer: {
              type: 'custom',
              tokenizer: 'ngram_tokenizer'
            }
          }
        }
      }
    })