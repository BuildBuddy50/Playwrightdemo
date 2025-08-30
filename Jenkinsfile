pipeline {
    agent { label 'qa-2' }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t playwright-tests .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                sh 'docker run --rm -v $WORKSPACE:/app playwright-tests'
            }
        }

        stage('Archive Report') {
            steps {
                archiveArtifacts artifacts: 'playwright-report/**', followSymlinks: false
            }
        }
    }
}
