pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jenkins-python-test'
        TEST_REPORT = 'test-results/pytest-report.xml'
    }

    stages {
        stage('Clone Repo') {
            steps {
                // Клонируем репозиторий (укажи свою ветку и url)
                git branch: 'main',
                    url: 'https://github.com/ValeriyTisch/for_jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Используем --network=host для корректной работы DNS во время сборки
                    docker.build("${IMAGE_NAME}", "--network=host .")
                }
            }
        }

        stage('Run Tests') {
    steps {
        script {
            docker.image("${IMAGE_NAME}").inside('--network=host') {
                sh '''
                    mkdir -p /tmp/test-results
                    python -m venv /tmp/venv
                    /tmp/venv/bin/pip install --upgrade pip
                    /tmp/venv/bin/pip install -r requirements.txt
                    /tmp/venv/bin/pytest --junitxml=/tmp/test-results/pytest-report.xml -v || true
                    cp -r /tmp/test-results ./  # скопировать в рабочую директорию Jenkins
                '''
            }
        }
    }
}



        stage('Publish Test Results') {
            steps {
                junit allowEmptyResults: true, testResults: "${TEST_REPORT}"
            }
        }
    }
}
