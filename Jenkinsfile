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
                // создаем venv
                sh 'python -m venv .venv'
                
                // активируем и используем venv
                sh '''
                    . .venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    mkdir -p test-results
                    pytest --junitxml=${TEST_REPORT} -v || true
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
