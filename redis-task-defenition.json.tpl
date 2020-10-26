[
    {
      "name": "redis",
      "image": "redis", 
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "dummyapi-staging-service",
          "awslogs-group": "awslogs-dummyapi-staging"
        }
      },
      "portMappings": [
        {
          "containerPort": 6379,
          "hostPort": 6379,
          "protocol": "tcp"
        }
      ],
      "cpu": 1,
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "staging"
        },
        {
          "name": "PORT",
          "value": "6379"
        }
      ]
    }
  ]
  
