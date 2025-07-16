pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jenkins-python-test'
        CONTAINER_NAME = 'test-runner'
        TEST_REPORT_PATH = 'test-results/pytest-report.xml'
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
                    // Запуск контейнера на фоне с бесконечным sleep, чтобы он не завершился
                    docker.image("${IMAGE_NAME}").withRun('--network=host --name ' + CONTAINER_NAME, 'sleep infinity') { c ->

                        // Выполняем установку и запуск тестов внутри контейнера
                        sh """
                            docker exec ${CONTAINER_NAME} /bin/bash -c '
                                python -m venv /tmp/venv &&
                                /tmp/venv/bin/pip install --upgrade pip &&
                                /tmp/venv/bin/pip install -r requirements.txt &&
                                mkdir -p /tmp/test-results &&
                                /tmp/venv/bin/pytest --junitxml=/tmp/test-results/pytest-report.xml -v || true
                            '
                        """

                        // Удаляем старые результаты через root-контейнер (обход ограничения прав)
                        sh "docker run --rm -v \$PWD:/workspace alpine sh -c 'rm -rf /workspace/test-results'"

                        // Создаём директорию заново
                        sh "mkdir -p test-results"

                        // Копируем новые тест-результаты из контейнера
                        sh "docker cp ${CONTAINER_NAME}:/tmp/test-results/. ./test-results"
                    }
                }
            }
        }

        stage('Publish Test Results') {
            steps {
                junit allowEmptyResults: true, testResults: "${TEST_REPORT_PATH}"
            }
        }
    }
}
