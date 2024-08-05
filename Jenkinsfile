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
        stage('Check source'){
            steps{
                sh "sudo cp -r . $PATH_PROJECT"
            }
        }
        stage('Test dotnet'){
            steps{
                sh "cd $PATH_PROJECT/nosh_now_apis \
                && docker build -t dotnet7-app -f Dockerfile.dotnet7 . \
                && docker run --rm -v .:/app -w /app dotnet7-app dotnet test"
            }
        }

        stage('Build and push images') {
            steps {
                script {
                    sh "cd $PATH_PROJECT \
                    && DOCKER_USERNAME=${env.DOCKER_USERNAME} \
                    && TOKEN_ISSUER=${env.TOKEN_ISSUER} \
                    && TOKEN_AUDIENCE=${env.TOKEN_AUDIENCE} \
                    && TOKEN_KEY=${env.TOKEN_KEY} \
                    && docker-compose build\
                    && echo ${env.DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${env.DOCKERHUB_CREDENTIALS_USR} --password-stdin \
                    && docker push ${env.DOCKER_USERNAME}/api \
                    && docker rmi ${env.DOCKER_USERNAME}/api \
                    && docker-compose up -d db" 
                }
            }
        }

        stage('Migration database'){
            steps{
                script{
                    try{
                        timeout(time: 20, unit: 'SECONDS') {
                            env.userChoice = input message: "Do you want to migrate the database?",
                                parameters: [choice(name: 'Versioning Service', choices: 'no\nyes', description: 'Choose "yes" if you want to migrate!')]

                        }
                        if( env.userChoice == 'yes') {
                            sh "cd $PATH_PROJECT/nosh_now_apis \
                            && docker run --rm -v .:/app -w /app dotnet7-app dotnet ef migrations add InitDB \
                            && docker run --rm -v .:/app -w /app dotnet7-app dotnet ef database update"
                        } else {
                            echo "Migration cancelled."
                        }
                    }catch (Exception err) {
                        def user = err.getCauses()[0].getUser()
                        if('SYSTEM' == user.toString()) {
                            def didTimeout = true
                            echo "Timeout. Migration cancelled."
                        } else {
                            echo "Migration cancelled by: ${user}"
                        }
                    }
                }
            }
        }

        stage ('Deploy APIs'){
            steps{
                script {
                    sh "echo 'Deploying and cleaning' \
                    cd $PATH_PROJECT \
                    && DOCKER_USERNAME=${env.DOCKER_USERNAME} \
                    && TOKEN_ISSUER=${env.TOKEN_ISSUER} \
                    && TOKEN_AUDIENCE=${env.TOKEN_AUDIENCE} \
                    && TOKEN_KEY=${env.TOKEN_KEY} \
                    && docker-compose up -d"
                }
            }
        }
    }
}