pipeline{
     environment {
       IMAGE_NAME = "alpinehelloworld"
       IMAGE_TAG = "latest"
       STAGING = "pintade-staging"
       PRODUCTION = "pintade-production"
	   docker_user = "pintade"
     }
    agent none
    stages {
        stage("build"){
			agent any
            steps {
                sh """
                    docker build -t static-website-example .
                """
            }
        }
        stage("run"){
			agent any
            steps{
                sh """
                    docker run -rm static-website-example
                """
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
    }
	
	
}
