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
	}
}