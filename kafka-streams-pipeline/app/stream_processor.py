from confluent_kafka import Producer, Consumer, KafkaError

# Kafka Producer and Consumer configurations
producer_conf = {'bootstrap.servers': 'localhost:9092'}
consumer_conf = {
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'data-processing-group',
    'auto.offset.reset': 'earliest'
}

producer = Producer(producer_conf)
consumer = Consumer(consumer_conf)
consumer.subscribe(['input_topic'])

def process_message(message):
    return message.value().upper()

def produce_to_output_topic(message):
    producer.produce('output_topic', value=message)
    producer.flush()

try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue
            else:
                print(msg.error())
                break

        processed_value = process_message(msg)
        produce_to_output_topic(processed_value)

except KeyboardInterrupt:
    pass
finally:
    consumer.close()
