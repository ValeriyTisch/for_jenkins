pipeline {
    agent { docker { image 'python:3.13.5-alpine3.22' } }
    stages {
        stage('build') {
            steps {
                sh 'python3 --version'
                sh 'pwd'
                sh 'python3 -m venv venv'
                sh 'source venv/bin/activate'
                sh 'apt-get update && apt-get install python3-pip'
                sh 'pip3 install --default-timeout=1000 --no-cache-dir -r requirements.txt'
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
