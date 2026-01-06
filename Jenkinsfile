pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
        nodejs 'nodejs'
    }

    environment {
        IMAGE_NAME = "nayana/sample-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/nayanahg-16/Devsecops.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('SonarQube Scan') {
    steps {
        withEnv(["SONAR_AUTH_TOKEN=${credentials('sonar-token')}"]) {
            sh "sonar-scanner -Dsonar.projectKey=devsecops-node -Dsonar.projectName=devsecops-node -Dsonar.sources=src -Dsonar.tests=test -Dsonar.login=${SONAR_AUTH_TOKEN}"
        }
    }
}


        stage('Quality Gate') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker push $IMAGE_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 80:8080 $IMAGE_NAME:$BUILD_NUMBER'
            }
        }
    }
}
