pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "psd2001/pipeline:latest"
        REPO_URL = "https://github.com/Psd1516/pipeline.git"
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${REPO_URL}", branch: 'master'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy') {
            steps {
                sh "docker run -d -p 8081:8081 --name pipeline-app ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        success {
            echo 'Build and Deploy completed successfully!'
        }
        failure {
            echo 'Build failed. Please check the logs for errors.'
        }
    }
}
