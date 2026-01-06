pipeline {
  agent any

  tools {
    jdk 'jdk17'
    maven 'maven3'
    nodejs "nodejs"
    sonarScanner 'sonar-scanner'
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
        withSonarQubeEnv('sonar-server') {
            sh '''
              sonar-scanner \
              -Dsonar.projectKey=devsecops-node \
              -Dsonar.projectName=devsecops-node \
              -Dsonar.sources=src \
              -Dsonar.tests=test
            '''
        }
    }
}


    stage('Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
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
        sh '''
        docker login -u $DOCKER_USER -p $DOCKER_PASS
        docker push $IMAGE_NAME:$BUILD_NUMBER
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh 'docker run -d -p 80:8080 $IMAGE_NAME:$BUILD_NUMBER'
      }
    }
  }
}
