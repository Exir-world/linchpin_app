pipeline {
     agent {
         docker {
             image 'docker:latest'
         }
     }
     environment {
         IMAGE_NAME = "linchpin-flutter-web"  // اسم ایمیج
         CONTAINER_NAME = "linchpin-container"  // اسم کانتینر
         SERVER = "user@your-deploy-server"  // آدرس سرور دیپلوی
         DEPLOY_PATH = "/var/www/html"  // پوشه‌ای که می‌خوای خروجی رو بهش منتقل کنی
     }
     stages {
         stage('Clone Repository') {
             steps {
                 git 'https://github.com/Exir-world/linchpin_app.git'  // آدرس پروژه
             }
         }
         stage('Build Docker Image') {
             steps {
                 sh 'docker build -t $IMAGE_NAME .'
             }
         }
         stage('Run Container') {
             steps {
                 sh 'docker stop $CONTAINER_NAME || true'
                 sh 'docker rm $CONTAINER_NAME || true'
                 sh 'docker run -d --name $CONTAINER_NAME -p 8080:80 $IMAGE_NAME'
             }
         }
         stage('Deploy to Server') {
             steps {
                 // انتقال خروجی وب به سرور
                 sh 'scp -r build/web/* $SERVER:$DEPLOY_PATH'
             }
         }
     }
 }