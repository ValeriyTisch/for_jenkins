pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jenkins-python-test'
        CONTAINER_NAME = 'test-runner'
        TEST_RESULTS_DIR = 'test-results'
        ALLURE_RESULTS_DIR = 'allure-results'
        TEST_REPORT_PATH = "${TEST_RESULTS_DIR}/pytest-report.xml"
    }

    tools {
        allure 'AllureCommandline' // <-- Название в Jenkins Global Tool Configuration
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
                    docker.image("${IMAGE_NAME}").withRun("--network=host --name ${CONTAINER_NAME}", 'sleep infinity') { c ->

                        // Установка, запуск тестов + Allure-отчёты
                        sh """
                            docker exec ${CONTAINER_NAME} /bin/bash -c '
                                python -m venv /tmp/venv &&
                                /tmp/venv/bin/pip install --upgrade pip &&
                                /tmp/venv/bin/pip install -r requirements.txt &&
                                /tmp/venv/bin/pip install pytest-html allure-pytest &&
                                mkdir -p /tmp/test-results /tmp/allure-results &&
                                /tmp/venv/bin/pytest \
                                    --junitxml=/tmp/test-results/pytest-report.xml \
                                    --html=/tmp/test-results/report.html \
                                    --self-contained-html \
                                    --alluredir=/tmp/allure-results \
                                    -v || true
                            '
                        """

                        // Удаление старых результатов
                        sh "docker run --rm -v \$PWD:/workspace alpine sh -c 'rm -rf /workspace/${TEST_RESULTS_DIR} /workspace/${ALLURE_RESULTS_DIR}'"

                        // Копирование новых
                        sh "mkdir -p ${TEST_RESULTS_DIR} ${ALLURE_RESULTS_DIR}"
                        sh "docker cp ${CONTAINER_NAME}:/tmp/test-results/. ./${TEST_RESULTS_DIR}"
                        sh "docker cp ${CONTAINER_NAME}:/tmp/allure-results/. ./${ALLURE_RESULTS_DIR}"
                    }
                }
            }
        }

        stage('Publish HTML Report') {
            steps {
                archiveArtifacts artifacts: "${TEST_RESULTS_DIR}/report.html", fingerprint: true
            }
        }

        stage('Publish JUnit Report') {
            steps {
                junit allowEmptyResults: true, testResults: "${TEST_REPORT_PATH}"
            }
        }

        stage('Publish Allure Report') {
            steps {
                allure includeProperties: false,
                       jdk: '',
                       results: [[path: "${ALLURE_RESULTS_DIR}"]]
            }
        }
    }
}
