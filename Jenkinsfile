pipeline {
    agent { label 'dev-qa' }

    parameters {
        choice(
            name: 'GIT_BRANCH',
            choices: ['main', 'master', 'develop'],  // static list, can later make dynamic
            description: 'Select the Git branch to build and test'
        )
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                // ✅ SCM Checkout with branch parameter
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${params.GIT_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/BuildBuddy50/Playwrightdemo.git'
                        // credentialsId: 'your-creds-id'  // uncomment if repo is private
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'sudo docker build -t playwright-tests .'
            }
        }

        stage('Run Tests in Docker') {
            steps {
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
