pipeline {
	agent any

    triggers {
        pollSCM '*/5 * * * *'
    }

    environment {
        MONGO_URL = credentials('mongo-url')
        JWT_SECRET = credentials('jwt-secret')
    }

	stages {
		stage('Checkout') {
			steps {
				checkout scm
			}
		}
        stage('Client Tests') {
            steps {
                dir('client') {
                    sh 'npm install'
                    sh 'npm run test'
                }
            }
        }
        stage('Server Tests') {
            steps {
                dir('api') {
                    sh 'npm install'
                    sh 'npm run test'
                }
            }
        }
        stage('Build Images') {
            steps {
                sh 'docker build -t dominikkoltai/mern_chat_app_client:latest client'
                sh 'docker build -t dominikkoltai/mern_chat_app_api:latest api'
            }
        }
        stage('Push Images to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'owLvoNvi7sTsWT9', usernameVariable: 'dominikkoltai')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push dominikkoltai/mern_chat_app_client:latest'
                    sh 'docker push dominikkoltai/mern_chat_app_api:latest'
                }
            }
        }
	}
}