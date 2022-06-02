pipeline {
    agent {
        node {
            label 'master'
        }
    }

    options {
        ansiColor 'xterm'
        buildDiscarder logRotator(numToKeepStr: '25', artifactNumToKeepStr: '25')
        timestamps()
    }

    tools {
        terraform 'terraform'
    }
    
    environment {
        // AWS_API_KEY = credentials('aws-api-key')
        // AWS_API_SECRET = credentials('aws-api-secret')
        GIT_URL = 'git@github.com:LDevop/infra.git'
    }

    stages {
        stage('Chekout') {
            steps {
                script {
                    git branch: 'main',
                        credentialsId: 'github-ssh-key',
                        url: GIT_URL
                }
            }
        }

        stage('Terraform apply') {
            steps {
                script {
                    sh '''
                        terraform init
                        terraform plan -out tfplan
                    '''
                    timeout(time:10, unit:'MINUTES') {
                        input 'Are you sure to run terraform apply?'
                    }
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
    post {
        failure {
            echo 'Something went wrong' //notifications placeholder
        }
        success {
            echo 'Successful build'
        }
        always {
            // cleanWs deleteDirs: true
            echo 'Successful'
        }
    }
}
