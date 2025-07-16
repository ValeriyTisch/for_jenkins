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
            docker.image("${IMAGE_NAME}").withRun('--network=host --name ' + CONTAINER_NAME, 'sleep infinity') { c ->
                sh """
                    docker exec ${CONTAINER_NAME} /bin/bash -c '
                        python -m venv /tmp/venv &&
                        /tmp/venv/bin/pip install --upgrade pip &&
                        /tmp/venv/bin/pip install -r requirements.txt &&
                        mkdir -p /tmp/test-results &&
                        /tmp/venv/bin/pytest --junitxml=/tmp/test-results/pytest-report.xml -v || true
                    '
                """
                sh "mkdir -p test-results"
                sh "docker cp ${CONTAINER_NAME}:/tmp/test-results/. ./test-results"
                sh "chmod -R a+rw test-results"
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
