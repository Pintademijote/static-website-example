pipeline {
     environment {
       IMAGE_NAME = "static_web"
       IMAGE_TAG = "latest"
	   docker_user = "pintade"
     }
     agent none
     stages {
         stage('Build image') {
             agent any
             steps {
                script {
                  sh '''
					docker build -t pintade/$IMAGE_NAME:$IMAGE_TAG .
					'''
                }
             }
        }
	}
        stage('Run container based on builded image') {
            agent any
            steps {
               script {
                 sh '''
                    docker run --name $IMAGE_NAME -d -p 80:5000 -e PORT=5000 pintade/$IMAGE_NAME:$IMAGE_TAG
                    sleep 5
                 '''
               }
            }
       }
       stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                    curl http://172.17.0.1 | grep -q "Hello world!"
                '''
              }
           }
      }
      stage('Clean Container') {
          agent any
          steps {
             script {
               sh '''
                 docker stop $IMAGE_NAME
                 docker rm $IMAGE_NAME
               '''
             }
          }
     }
     stage('Push image in staging and deploy it') {
       when {
              expression { GIT_BRANCH == 'origin/master' }
            }
	}

	
	  stage('Push docker') {
          agent any
          steps {
             script {
				node {
					withCredentials([string(credentialsId: 'docker_pw', variable: 'SECRET')]) {
					sh '''
						docker login -u ${docker_user} -p ${SECRET}
						docker image push pintade/$IMAGE_NAME:$IMAGE_TAG
					'''
					}
				}
             }
          }
     }
	 

  
      post {
        always{
            
            script{

                if ( currentBuild.result == "SUCCESS" ) {
                    slackSend color: "good", message: "CONGRATULATION: Job ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was successful ! more info ${env.BUILD_URL}"
                }
                else if( currentBuild.result == "FAILURE" ) { 
                    slackSend color: "danger", message: "BAD NEWS:Job ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was failed ! more info ${env.BUILD_URL}"
                }
                else if( currentBuild.result == "UNSTABLE" ) { 
                    slackSend color: "warning", message: "BAD NEWS:Job ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was unstable ! more info ${env.BUILD_URL}"
                }
                else {
                    slackSend color: "danger", message: "BAD NEWS:Job ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} its result was unclear ! more info ${env.BUILD_URL}"	
                }
            }
        }
    
    }

}


