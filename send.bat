@echo OFF


curl -H "Content-type: application/json;charset=UTF-8" -H "Authorization:key=AAAAW1OZtMk:APA91bH-qt8f4IcBTiKXR9VTXMMIDbQVude_obmpBbBn-EUhs4CNZH2XxkR0F-RkIyOkWVQx9aIwEqA6ZKVbQSgsy1HSMHbKjzEDE_mKozqHmKJe3XzeQWO9D1ry9au01ZZ-RvSkSQTF" -X POST -d @jsondataCustoId.json https://fcm.googleapis.com/fcm/send

REM curl -H "Content-type: application/json;charset=UTF-8" -H "Authorization:key=AAAAW1OZtMk:APA91bH-qt8f4IcBTiKXR9VTXMMIDbQVude_obmpBbBn-EUhs4CNZH2XxkR0F-RkIyOkWVQx9aIwEqA6ZKVbQSgsy1HSMHbKjzEDE_mKozqHmKJe3XzeQWO9D1ry9au01ZZ-RvSkSQTF" -X POST -d @jsondata.json https://fcm.googleapis.com/fcm/send

REM curl --header "Content-Type: application/json" --header "Authorization: key=2074b2163bc6ed51676a113b417800e0d5ac7979" https://fcm.googleapis.com/fcm/send -d '{"data": {"title": "The Title","body": "Hellof!", "sound": "default"},"priority": "high","to": "FMC push token"}'


REM curl -X POST --header "Authorization: key=2074b2163bc6ed51676a113b417800e0d5ac7979" --Header "Content-Type: application/json" https://fcm.googleapis.com/fcm/send -d {"data":{"body":"Test body from curl"},"registration_ids":["<reg_ids>"],"apns":{"headers":{"apns-priority":"10"}},"webpush":{"headers":{"Urgency": "high"}},"android":{"priority":"high"},"priority":10}