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
                script {
                    def planResult = sh(script: 'terraform plan -out=tfplan', returnStatus: true)
                    if (planResult != 0) {
                        error("Terraform Plan failed! Stopping pipeline.")
                    }
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    input message: "Do you want to proceed with Terraform Apply?", ok: "Approve"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply tfplan'
            }
        }
    }
}
