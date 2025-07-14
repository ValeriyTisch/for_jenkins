pipeline {
    agent any

    environment {
        IMAGE_NAME = 'python-pytest-image'
        CONTAINER_NAME = 'pytest-runner'
        TEST_REPORT = 'test-results/pytest-report.xml'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://your-git-repo-url.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}").inside('--name ' + CONTAINER_NAME) {
                        sh 'pip install -r requirements.txt'
                        sh 'mkdir -p test-results'
                        sh "pytest --junitxml=${TEST_REPORT} --maxfail=1 --disable-warnings -v"
                    }
                }
            }
        }

        stage('Publish JUnit Report') {
            steps {
                // Copy the report out of Docker container to workspace if needed
                // But since `docker.image(...).inside()` shares the workspace, it will persist
                junit allowEmptyResults: true, testResults: "${TEST_REPORT}"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker container if exists'
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
        success {
            echo 'Tests passed!'
        }
        failure {
            echo 'Tests failed!'
        }
    }
}
