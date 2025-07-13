pipeline {
    agent { docker { image 'python:3.13.5-alpine3.22' } }
    stages {
        stage('build') {
            steps {
                sh 'python3 --version'
                sh 'python3 -r requirements.txt'
            }
        }
        stage('test') {
            steps {
                sh 'python3 test_something.py'
            }
        }
        stage('notification') {
            steps {
                emailext attachLog: true, body: 'письмо от jenkins', subject: 'jenkins_message', to: 'polmnot@mail.ru'
            }
        }   
    }
}
