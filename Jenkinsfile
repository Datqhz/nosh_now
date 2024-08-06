pipeline{
    agent any
    environment{
        PATH_PROJECT = '/home/project/tttn'

        DOCKER_USERNAME = 'dat1edf'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        TOKEN_ISSUER = credentials('TOKEN_ISSUER')
        TOKEN_AUDIENCE = credentials('TOKEN_AUDIENCE')
        TOKEN_KEY = credentials('TOKEN_KEY')
    }

    stages{
        stage ('Deploy APIs'){
            steps{
                    sh "echo 'Deploying and cleaning'"
                    sh "DOCKER_USERNAME=${DOCKER_USERNAME}"
                    sh "TOKEN_ISSUER=${TOKEN_ISSUER}"
                    sh "TOKEN_AUDIENCE=${TOKEN_AUDIENCE}"
                    sh "TOKEN_KEY=${TOKEN_KEY}"
                    sh "docker-compose up -d --build"
            }
        }
    }
}