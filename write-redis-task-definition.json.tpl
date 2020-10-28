[
    {
      "name": "redis-write",
      "image": "768997443862.dkr.ecr.us-east-1.amazonaws.com/go-test-app", 
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ],
      "cpu": 1,
      "environment": [
        {
          "name": "REDIS_LOCATION",
          "value": "redis.example.test"
        },
        {
          "name": "MODE",
          "value": "write"
        },
        {
          "name": "REDIS_TEST_KEY",
          "value": "blablakey"
        },
        {
          "name": "REDIS_TEST_NAME",
          "value": "test"
        },
        {       
          "name": "REDIS_TEST_ID",
          "value": "1898919819"
        }
      ]
    }
  ]
  
