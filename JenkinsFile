pipeline {
    agent any

    environment {
        BLUE_IP = "192.168.1.10"
        GREEN_IP = "192.168.1.11"
        NGINX_IP = "192.168.1.100"
        DEPLOY_USER = "ubuntu"
        SSH_KEY = "/path/to/key.pem"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-user/blue-green-ci-cd.git'
            }
        }

        stage('Build App') {
            steps {
                sh 'zip -r app.zip app/'
            }
        }

        stage('Deploy to Green') {
            steps {
                script {
                    def CURRENT = sh(script: "ssh -i $SSH_KEY $DEPLOY_USER@$NGINX_IP cat ~/nginx/live_env.txt", returnStdout: true).trim()
                    def TARGET = CURRENT == "blue" ? GREEN_IP : BLUE_IP
                    sh "./deploy.sh $TARGET $SSH_KEY"
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    def CURRENT = sh(script: "ssh -i $SSH_KEY $DEPLOY_USER@$NGINX_IP cat ~/nginx/live_env.txt", returnStdout: true).trim()
                    def TEST_IP = CURRENT == "blue" ? GREEN_IP : BLUE_IP
                    sh "curl --fail http://$TEST_IP:3000/health"
                }
            }
        }

        stage('Switch Traffic') {
            steps {
                script {
                    def CURRENT = sh(script: "ssh -i $SSH_KEY $DEPLOY_USER@$NGINX_IP cat ~/nginx/live_env.txt", returnStdout: true).trim()
                    def NEXT = CURRENT == "blue" ? "green" : "blue"
                    sh "ssh -i $SSH_KEY $DEPLOY_USER@$NGINX_IP '~/nginx/switch_traffic.sh $NEXT'"
                }
            }
        }
    }
}
