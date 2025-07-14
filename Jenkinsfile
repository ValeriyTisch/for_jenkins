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
                    // Запускаем контейнер с принудительным DNS
                    docker.image("${IMAGE_NAME}").inside('--dns=8.8.8.8') {
                        sh 'pip install --upgrade pip'
                        sh 'pip install -r requirements.txt'
                        sh 'mkdir -p test-results'
                        // Проверка подключения (можно убрать позже)
                        sh 'curl https://pypi.org/simple'
                        // Запуск pytest с генерацией JUnit xml
                        sh "pytest --junitxml=${TEST_REPORT} -v"
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
