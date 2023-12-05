namespace :elasticsearch do
    desc 'Build and import data into Elasticsearch indices'
    task build_index: :environment do
      Message.__elasticsearch__.create_index! force: true
      Message.import
    end
  end