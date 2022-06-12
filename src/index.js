const AWS = require('aws-sdk');

exports.handler = async (event, context, callback) => {
    const tableName = process.env.tableName ?? callback(new Error("Table name not provided"))
    const documentClient = new AWS.DynamoDB.DocumentClient();

    await Promise.all(
        event.Records.map(async record => {
            const {body} = record;
            const {MessageId, Message} = JSON.parse(body);

            const params = {
                TableName: tableName,
                Item: {
                    MessageId,
                    Message
                }
            };

            try {
                const data = await documentClient.put(params).promise();
                console.log("Item entered successfully:", data);
            } catch (err) {
                console.log("Error: ", err);
            }
        })
    )
};