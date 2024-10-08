pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "psd2001/pipeline:latest"
        REPO_URL = "https://github.com/Psd1516/pipeline.git"
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        GIT_CREDENTIALS_ID = 'af21707d-4fcc-49a7-baea-056b406f11a6'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'master', url: "${REPO_URL}", credentialsId: "${GIT_CREDENTIALS_ID}"
            }
        }

        stage('Clone Repository') {
            steps {
                git url: "${REPO_URL}", branch: 'master'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    echo "Docker Username: ${DOCKER_USER}"
                echo "Docker Password: ${DOCKER_PASS}"
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy') {
            steps {
                bat "docker run -d -p 8081:8081 --name pipeline-app ${DOCKER_IMAGE}"
            }
        }

        stage('Run Background Task') {
            steps {
                bat 'start your_background_task.bat'
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
