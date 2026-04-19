pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Repo') {
            steps {
                sh 'bash scripts/ci/validate_repo.sh'
            }
        }
    }

    post {
        success {
            echo 'Kube_Local 검증 완료'
        }
        failure {
            echo 'Kube_Local 검증 실패'
        }
    }
}
