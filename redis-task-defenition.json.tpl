[
    {
      "name": "redis",
      "image": "redis", 
      "essential": true,
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
  
