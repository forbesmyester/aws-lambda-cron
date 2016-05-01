'use strict';
const AWS = require('aws-sdk');

const SQS = new AWS.SQS({ apiVersion: '2012-11-05' });
const Lambda = new AWS.Lambda({ apiVersion: '2015-03-31' });

// TODO add your queue URL here
const QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/[SECRET]/docuconv';


exports.handler = function process(evt, ctx, callback) {

    // delete message
    const params = {
        QueueUrl: QUEUE_URL,
        MessageBody: '{"a": "1"}'
    };
    SQS.sendMessage(params, (err) => callback(err));

}
