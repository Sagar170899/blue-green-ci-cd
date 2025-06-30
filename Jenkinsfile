pipeline {
    agent any

    environment {
        BLUE_IP = "16.171.43.23"
        GREEN_IP = "13.60.171.163"
        NGINX_IP = "16.171.174.95"
        DEPLOY_USER = "ubuntu"
        SSH_KEY = "/var/lib/jenkins/.ssh/ec2keypair.pem"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sagar170899/blue-green-ci-cd.git'
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
                    sh 'chmod +x deploy.sh'
                    def CURRENT = sh(script: "ssh -o StrictHostKeyChecking=no -i $SSH_KEY $DEPLOY_USER@$NGINX_IP 'cat ~/nginx/live_env.txt'", returnStdout: true).trim()
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
