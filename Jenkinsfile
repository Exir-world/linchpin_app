pipeline {
    agent any

    environment {
        GIT_REPO_URL = 'git@github.com:Exir-world/linchpin_app.git'
        TELEGRAM_CHAT_ID = '-1002585379912'
        TELEGRAM_BOT_TOKEN = '8027466900:AAG6Q_0p6rSeEXtg8e0gDcYJmIJ_R7zBVew'

        SERVER_IP = credentials('server_ip')
        SERVER_USER = credentials('server_user')
        SSH_PRIVATE_KEY = credentials('ssh_private_key')
        ARVAN_API_KEY = credentials('arvan_api_key')

        DOCKER_REGISTRY_URL = 'docker.exirtu.be'
        IMAGE_NAME = 'front.linchpin.exir'
    }

    stages {
        stage('Checkout Flutter App') {
            steps {
                git branch: 'v2', url: "${GIT_REPO_URL}"
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def imageTag = "${DOCKER_REGISTRY_URL}/${IMAGE_NAME}:latest"
                    sh """
                        docker build -t ${imageTag} .
                        docker push ${imageTag}
                    """
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent (credentials: ['ssh_private_key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
                        docker pull ${DOCKER_REGISTRY_URL}/${IMAGE_NAME}:latest
                        docker stop flutter_front || true
                        docker rm flutter_front || true
                        docker run -d --name flutter_front -p 80:80 ${DOCKER_REGISTRY_URL}/${IMAGE_NAME}:latest
                    ENDSSH
                    """
                }
            }
        }

        stage('Purge ArvanCloud Cache') {
            steps {
                sh """
                curl --location 'https://napi.arvancloud.ir/cdn/4.0/domains/420dccd6-fe45-4fee-8e94-4b48e2177c30/caching/purge' \\
                  -H "Authorization: Apikey ${ARVAN_API_KEY}" \\
                  -H "Content-Type: application/json" \\
                  --data '{"purge":"all"}'
                """
            }
        }

        stage('Notify Telegram') {
            steps {
                sh """
                curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \\
                  -d chat_id=${TELEGRAM_CHAT_ID} \\
                  -d text="✅ Flutter PWA Docker image built and deployed. Cache purged on ArvanCloud."
                """
            }
        }
    }
}
