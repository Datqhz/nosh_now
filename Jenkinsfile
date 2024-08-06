pipeline{
    agent any
    environment{
        DOCKER_USERNAME = 'dat1edf'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        TOKEN_ISSUER = credentials('TOKEN_ISSUER')
        TOKEN_AUDIENCE = credentials('TOKEN_AUDIENCE')
        TOKEN_KEY = credentials('TOKEN_KEY')
    }

    stages{
        stage ('Deploy APIs'){
            steps{
                    sh "echo 'Deploying and cleaning' \
                    && DOCKER_USERNAME=${DOCKER_USERNAME} \
                    && TOKEN_ISSUER=${TOKEN_ISSUER} \
                    && TOKEN_AUDIENCE=${TOKEN_AUDIENCE} \
                    && TOKEN_KEY=${TOKEN_KEY} \
                    && docker-compose up -d --build"
            }
        }
    }
}