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
        // stage('Check source'){
        //     steps{
        //         sh "sudo cp -r . $PATH_PROJECT"
        //     }
        // }
        stage('Test dotnet'){
            steps{
                sh "cd $PATH_PROJECT/nosh_now_apis"
                sh "docker build -t dotnet7-app -f Dockerfile.dotnet7 ."
                sh "docker run --rm -v .:/app -w /app dotnet7-app dotnet test"
            }
        }

        stage('Build and push images') {
            steps {
                    sh "cd $PATH_PROJECT"
                    sh "DOCKER_USERNAME=${DOCKER_USERNAME}"
                    sh "TOKEN_ISSUER=${TOKEN_ISSUER}"
                    sh "TOKEN_AUDIENCE=${TOKEN_AUDIENCE}"
                    sh "TOKEN_KEY=${TOKEN_KEY}"
                    sh "docker-compose build"
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_USERNAME}/api"
                    sh "docker rmi ${DOCKER_USERNAME}/api"
                    sh "docker-compose up -d db" 
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
                    sh "echo 'Deploying and cleaning'"
                    sh "cd $PATH_PROJECT"
                    sh "DOCKER_USERNAME=${DOCKER_USERNAME}"
                    sh "TOKEN_ISSUER=${TOKEN_ISSUER}"
                    sh "TOKEN_AUDIENCE=${TOKEN_AUDIENCE}"
                    sh "TOKEN_KEY=${TOKEN_KEY}"
                    sh "docker-compose up -d"
            }
        }
    }
}