pipeline {
    agent { docker { image 'python:3.13.5-alpine3.22' } }
    stages {
        stage('build') {
            steps {
                sh 'python --version'
            }
        }
        stage('print') {
            steps {
                echo 'ничего не получается'
            }
        }
    }
}
