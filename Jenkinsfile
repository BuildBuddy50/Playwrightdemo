pipeline {
    agent { label 'dev-qa' }

    stages {
        stage('Clean Workspace') {
            steps { cleanWs() }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/BuildBuddy50/Playwrightdemo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'sudo docker build -t playwright-tests .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
                // Only mount the report folder
                sh '''
                sudo docker run --rm \
                  -v $WORKSPACE/playwright-report:/app/playwright-report \
                  playwright-tests \
                  npx playwright test --project=chromium --reporter=line --reporter=html --output=/app/playwright-report
                '''
            }
        }
    }

    post {
        always {
            echo '📦 Archiving Playwright HTML report...'

            archiveArtifacts artifacts: 'playwright-report/**', followSymlinks: false

            publishHTML(target: [
                allowMissing: true,
                keepAll: true,
                alwaysLinkToLastBuild: true,
                reportDir: 'playwright-report',
                reportFiles: 'index.html',
                reportName: 'Playwright Report'
            ])
        }
    }
}
