pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Client Tests') {
      steps {
        dir(path: 'client') {
          sh 'npm install'
          sh 'npm test'
        }

      }
    }

    stage('Server Tests') {
      steps {
        dir(path: 'server') {
          sh 'npm install'
          sh 'export MONGO_URL=$MONGO_URL'
          sh 'export JWT_SECRET=$JWT_SECRET'
          sh 'npm test'
        }

      }
    }

    stage('Build Images') {
      steps {
        sh 'docker build -t dominikkoltai/mern_chat_app_client:latest client'
        sh 'docker build -t dominikkoltai/mern_chat_app_api:latest api'
      }
    }

  }
  environment {
    MONGO_URL = credentials('mongo-url')
    JWT_SECRET = credentials('jwt-secret')
  }
}