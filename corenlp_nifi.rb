require 'nifi_sdk_ruby'
require 'erb'

class TemplateBuilder

  TEMPLATE_NAME = 'template.erb'

  def initialize(*args)
    args = args.reduce Hash.new, :merge

    @template_name = args[:template_name]
    @extract_regex = args[:extract_regex]
    @sentence_nifi_regex = args[:sentence_nifi_regex]
    @kafka_ip = args[:kafka_ip]
    @consume_topic = args[:consume_topic]
    @consume_group_id = args[:consume_group_id]
    @publish_topic = args[:publish_topic]
    @replacement_regex = args[:replacement_regex]
  end

  def to_file(filepath)
    File.open(filepath,'w') do |f|
      f.puts ERB.new(File.read(TEMPLATE_NAME)).result(binding)
    end
  end
end


nifi_client = Nifi.new()
nifi_client.set_debug true

TemplateBuilder.new(
    :template_name =>  'Kafka_CoreNLP2',
    :extract_regex =>  '(.*)',
    :sentence_nifi_regex =>  '${sentence}',
    :kafka_ip =>  'localhost:9092',
    :consume_topic =>  'test',
    :consume_group_id =>  'some_id',
    :publish_topic =>  'test_output',
    :replacement_regex =>  '(\s?$)'
).to_file('Kafka_CoreNLP.xml')
begin
  nifi_client.upload_template(:path => 'Kafka_CoreNLP.xml')
rescue => e
  p e
end

sleep 1

hash = nifi_client.create_template_instance(:name => 'Kafka_CoreNLP')
puts hash

sleep 1

hash['flow']['processors'].each do |processor|
  puts nifi_client.start_process(id: processor['id'], version: processor['revision']['version'].to_s)
end