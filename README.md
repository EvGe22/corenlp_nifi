# NiFi 
 
### Attributes for the template 
| Attribute | Description | Example | Processor|
| -------- | -------- | -------- | -------- |
|:template_name|The name of the template|CoreNLP_Kafka|-|
|:extract_regex|The regex for extracting a sentence from an incoming FlowFile|(.*)| ExtractText |
|:sentence_nifi_regex|The NiFi regex for extracting a sentence from the attributes of an incoming FlowFile|${sentence}| CoreNLPProcessor |
|:kafka_ip|The ip and port of the kafka|localhost:9092|ConsumeKafka_0_10, PublishKafka_0_10|
|:consume_topic |The info will be consumed from this topic(s)|test|ConsumeKafka_0_10|
|:consume_group_id|The group for consumer|some_id|ConsumeKafka_0_10|
|:publish_topic |The info will be published to this topic|test_output|PublishKafka_0_10|
|:replacement_regex|Info matching this regex will be replaced by the sentiment analysis result| (\s?$)|ReplaceText|