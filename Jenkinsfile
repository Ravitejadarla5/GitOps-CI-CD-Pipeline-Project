pipeline{
    agent any 
    tools {
        jdk 'jdk-17'
        nodejs 'nodejs-16'
    }
    environment {
        SCANNER_HOME            = tool 'sonar-scanner'
        APP_NAME                = 'reddit-clone-app'
        RELEASE                 = '1.0.0'
        DOCKER_USER             = 'ravitejadarla5'
        DOCKER_PASS             = 'docker'
        IMAGE_NAME              = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG               = "${RELEASE}-${BUILD_NUMBER}"
        // JENKINS_API_TOKEN       = credenticals("JENKINS_API_TOKEN")
    }
    stages {
        stage ('Clean Work-Space'){
            steps {
                cleanWs()
            }
        }
        stage ('Git CheckOut'){
            steps {
                git branch: 'main', url: 'https://github.com/Ravitejadarla5/GitOps-CI-CD-Pipeline-Project.git'
            }
        }
        stage ('SonarQube-Analysis'){
            steps {
                withSonarQubeEnv ('sonar-server'){
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=GitOps-CICD \
                    -Dsonar.projectKey=GitOps-CICD''' 
                }
            }
        }
        stage ('Quality-Gate'){
            steps {
                script{
                    waitForQualityGate abortPipeline: false, credenticalsId: 'sonar-token'
                }
            }
        }
        stage ('Install-Packages'){
            steps {
                sh 'npm install'
            }
        }
        stage ('Trivy-Scan FSystem'){
            steps {
                sh 'trivy fs . > trivy-fileSystem-report.txt'
            }
        }
        stage ('Docker-Build') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS){
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                }
            }
        }
        stage ('Trivy-Scan Image'){
            steps {
                sh "trivy image ${IMAGE_NAME}:latest > trivy-image-report.txt"
            }
        }
        // stage ('Docker-Push') {
        //     steps {
        //         script {
        //             docker.withRegistry('', DOCKER_PASS) {
        //                 docker_image.push("${IMAGE_TAG}")
        //                 docker_image.push('latest')
        //             }
        //         }
        //     }
        // }
        // stage ('Clean Artfacts') {
        //     steps {
        //         script {
        //             sh "docker image rmi ${IMAGE_NAME}:${IMAGE_TAG}"
        //             sh "docker image rmi ${IMAGE_NAME}:latest"
        //         }
        //     }
        // }
    }
    






























}