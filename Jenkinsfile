pipeline {
    agent {
        node {
            label 'slave'
        }
    }

    options {
        ansiColor 'xterm'
        buildDiscarder logRotator(numToKeepStr: '25', artifactNumToKeepStr: '25')
        timestamps()
    }

    parameters {
        string name: 'VERSION', defaultValue: '', description: 'Application version'
    }

    tools {
        terraform 'terraform'
    }
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-api-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-api-secret')
        AWS_REGION = 'eu-central-1'
        AWS_PUBLIC_KEY = credentials('aws_public_key')
        DB_CREDS = credentials('db_creds')
        GIT_URL = 'git@github.com:LDevop/infra.git'
        
    }

    stages {
        stage('Terraform apply') {
            steps {
                script {
                    sh """
                        terraform init
                        terraform plan -out tfplan -parallelism=2 \
                            -var app_image=ldevop/adminer:${VERSION} \
                            -var db_username=\$DB_CREDS_USR \
                            -var db_password=\$DB_CREDS_PSW \
                            -var public_key="\$AWS_PUBLIC_KEY"
                    """
                    // timeout(time:10, unit:'MINUTES') {
                    //     input 'Are you sure to run terraform apply?'
                    // }
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
    post {
        failure {
            withCredentials([string(credentialsId: 'tokenid', variable: 'TOKEN'), string(credentialsId: 'chatWebid', variable: 'CHAT_ID')]) {
            sh ("""
            curl -s -X POST https://api.telegram.org/bot\$TOKEN/sendMessage\
            -d chat_id=\$CHAT_ID\
            -d parse_mode=markdown\
            -d text='*${env.JOB_NAME}* : *Branch*: ${env.GIT_BRANCH} *Build* : `NOT OK` *Published* = `NO`'
            """)
            }
            echo 'Something went wrong' //notifications placeholder
        }
        success {
            withCredentials([string(credentialsId: 'tokenid', variable: 'TOKEN'), string(credentialsId: 'chatWebid', variable: 'CHAT_ID')]) {
            sh ("""
            curl -s -X POST https://api.telegram.org/bot\$TOKEN/sendMessage\
            -d chat_id=\$CHAT_ID\
            -d parse_mode=markdown\
            -d text='*${env.JOB_NAME}* : *Branch*: ${env.GIT_BRANCH} *Build* : `OK` *Published* = `YES`'
            """)
            }
            echo 'Successful'
        }
    }
}
