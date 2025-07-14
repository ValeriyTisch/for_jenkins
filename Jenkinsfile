pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jenkins-python-test'
        TEST_REPORT = 'test-results/pytest-report.xml'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ValeriyTisch/for_jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}", "--network=host .")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}").inside('--dns=8.8.8.8') {
                        sh 'pip install -r requirements.txt'
                        sh 'mkdir -p test-results'
                        sh 'curl https://pypi.org/simple'  // Проверка подключения
                        sh "pytest --junitxml=${TEST_REPORT} -v"
                    }
                }
            }
        }

        stage('Publish JUnit Report') {
            steps {
                junit allowEmptyResults: true, testResults: "${TEST_REPORT}"
            }
        }
    }
}
