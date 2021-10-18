pipeline{
     environment {
       IMAGE_NAME = "static"
       IMAGE_TAG = "latest"
	docker_user = "pintade"
     }
    agent none
    stages {
        stage("build"){
			agent any
            steps {
                sh """
                    docker build -t ${docker_user}/static-website-example:${IMAGE_TAG} .
                """
            }
        }
        stage("run"){
			agent any
            steps{
                sh """
                    docker run --name $IMAGE_NAME -d -p 80:80 ${docker_user}/static-website-example:${IMAGE_TAG}
                """
            }
        }
		
	stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                    curl http://172.17.0.1 | grep -q "Dimension"
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
	 
    }
	  

	
	
}
