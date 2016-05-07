'use strict';
const AWS = require('aws-sdk');

const SQS = new AWS.SQS({ apiVersion: '2012-11-05' });
const Lambda = new AWS.Lambda({ apiVersion: '2015-03-31' });

const QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/            /docuconv';

exports.handler = function process(evt, ctx, callback) {

    console.info("Attempting to create SQS message");
    const params = {
        QueueUrl: QUEUE_URL,
        MessageBody: '{"a": "1"}'
    };
    SQS.sendMessage(
        params,
        (err) => {
            if (err) {
                console.error("Could not send message", err);
                return callback(err);
            }
            console.info("Message Sent!");
        }
    );

};
