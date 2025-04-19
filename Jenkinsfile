pipeline {
    agent any

    environment {
        DOCKER_REGISTRY_URL = 'docker.exirtu.be'
        IMAGE_NAME = 'linchpin.exir' // not used here but kept for consistency
        GIT_REPO_URL = 'git@github.com:Exir-world/linchpin_app.git'
        TELEGRAM_CHAT_ID = '-1002585379912'
        TELEGRAM_BOT_TOKEN = '8027466900:AAG6Q_0p6rSeEXtg8e0gDcYJmIJ_R7zBVew'

        SERVER_IP = credentials('server_ip')
        SERVER_USER = credentials('server_user')
        SSH_PRIVATE_KEY = credentials('ssh_private_key')
        ARVAN_API_KEY = credentials('arvan_api_key')
    }

    stages {
        stage('Checkout Flutter App') {
            steps {
                git branch: 'v2', url: "${GIT_REPO_URL}"
            }
        }

        stage('Build Flutter Web') {
            agent {
                docker {
                    image 'cirrusci/flutter:stable'
                    args '-u root:root'
                }
            }
            steps {
                sh 'flutter pub get'
                sh 'flutter build web'
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent (credentials: ['ssh_private_key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
                        export PATH="\$PATH:/opt/flutter/bin"
                        cd /var/www/html

                        if [ ! -d "flutter/.git" ]; then
                            rm -rf flutter
                            git clone https://github.com/Exir-world/linchpin_app.git flutter
                        fi

                        git config --global --add safe.directory /var/www/html/flutter

                        cd flutter
                        git checkout v2
                        git pull origin v2

                        flutter build web
                        rm -rf /var/www/html/pwa/*
                        cp -r build/web/* /var/www/html/pwa
                        systemctl restart nginx
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
                  -d text="✅ Flutter PWA deployed successfully to production and ArvanCloud cache purged."
                """
            }
        }
    }
}
