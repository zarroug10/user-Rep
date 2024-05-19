pipeline {
    agent any

    environment {
        NODEJS_HOME = tool name: 'NodeJS', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
        PATH = "${env.NODEJS_HOME}/bin:${env.PATH}"
        CHROME_BIN = '/usr/bin/google-chrome' // Path to Chrome binary
        DOCKER_HUB_REGISTRY = 'docker.io' // Docker Hub registry URL
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install dependencies') {
          steps {
    powershell 'npm install'
    // powershell 'npm install jest --save-dev'
    // powershell 'npm install bcrypt'
}
            }
        


        stage('Build') {
            steps {
                // sh 'node app.js'
                powershell 'npm run build'
            }
        }

        // stage('Test') {
        //     steps {
        //         // Run Jest tests
        //         powershell 'npm test'
        //     }
        // }

        stage('Build Docker image') {
            steps {
                powershell 'docker build -t user:latest -f Dockerfile .'
                // Tag the Docker image with a version
                powershell 'docker tag user:latest zarroug/user:latest'
            }
        }

        stage('Deploy Docker image') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    withCredentials([string(credentialsId: 'token', variable: 'DOCKER_TOKEN')]) {
                        docker.withRegistry('https://index.docker.io/v1/', '12') {
                            // Push both the latest and tagged images
                            powershell "docker image push zarroug/user:latest"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build succeeded!'
            // Add any success post-build actions here
        }

        failure {
            echo 'Build failed!'
            // Add any failure post-build actions here
        }
    }
}
