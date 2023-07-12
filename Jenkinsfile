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
                echo "MONGO_URL = ${env.MONGO_URL}"
                echo "JWT_SECRET = ${env.JWT_SECRET}"
				checkout scm
			}
		}
	}
}