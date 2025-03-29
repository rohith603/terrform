pipeline {
    agent any
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "/var/lib/jenkins/gcp-credentials/your-service-account.json"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/rohith603/terrform.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
