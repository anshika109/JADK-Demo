pipeline{
    
    environment {
        def ARTID = 'LoginWebApp'
        def ARTTYPE = 'war'
        def ARTGRPID = 'com.ltidevops'
        def ARTURL = '13.232.205.66:8081'  //change ip
        def ARTREPO = 'demo'  
        def ARTVER = '1'
        def ARTPROTO = 'http'
        def ARTDOWPATH = '$ARTPROTO://$ARTURL/repository/$ARTREPO' //http://3.108.44.96:8081/repository/hello/
        
        DOCKER_TAG = getVersion()
    }
    
    agent any
    tools{
        maven 'maven3'
    }
    stages{
        stage('SCM Pull'){
            steps{
                git credentialsId: 'git', 
                url: 'https://github.com/anshika109/JADK-Demo.git'
            }
        }
        stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
        }
        /*stage("Upload Artifactory to Nexus"){
            steps{
                script{
                  def mavenPom = readMavenPom file: 'pom.xml'
                  nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: "${env.ARTPROTO}",
                    nexusUrl: "${env.ARTURL}",  
                    groupId:  "${mavenPom.groupId}",
                    version: "${mavenPom.version}",
                    repository: "${env.ARTREPO}",
                    credentialsId: "nexus3",   //nexus3 //shubhnexus
                    artifacts: [
                        [artifactId: 'LoginWebApp',  
                         classifier: '',
                         file: "target/LoginWebApp-${mavenPom.version}.${mavenPom.packaging}",
                         type: "${mavenPom.packaging}"] 
                    ]
                    )
                }
           }
        }*/
        
        /*stage('Artifactory Pull on docker') {
            agent {
                label 'doc'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus3', passwordVariable: 'nexpwd', usernameVariable: 'nexurl')]) {
                sh 'wget --user=$nexurl --password=$nexpwd "http://$ARTURL/repository/$ARTREPO/com/ltidevops/LoginWebApp/1/LoginWebApp-$ARTVER.$ARTTYPE"'
            }
            }
        }*/
        stage('Docker Image Build & Tag'){
            steps{
                sh '''docker build -t demo:${DOCKER_TAG} .    
                    docker tag demo signin/hello:${DOCKER_TAG}
                    '''   
            }
        }
        stage('Publish Docker image to hub'){
            steps{
                withDockerRegistry(credentialsId: 'docker', url:'') {
                    sh "docker push signin/hello:${DOCKER_TAG}"
                }
            }
        }
        stage('Run docker container'){
            steps{
                sh "docker run -itd --name democontainer1 -p 8003:8080 demo"
                //sh "docker run -d -p 8070:8080 signin/hello"
            }
        }
        /*stage('Run docker container on remote hosts'){
            steps{
                sh "docker -H ssh://ec2-user@ip-43.205.143.129 run -d -p 8070:8080 signin/hello"
            }
        }*/
        /*stage('Docker Build'){
            agent{
                label 'doc'
            }
            steps{
                sh '''docker build -t demo:${DOCKER_TAG} .    
                    docker tag demo signin/hello:${DOCKER_TAG}
                    '''   
            }
        }
        stage('Docker Image Push'){
            agent{
                label 'doc'
            }
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'docpwd', usernameVariable: 'docuser')]) {
                sh "docker login -u signin -p ${docpwd}"
                sh "docker push signin/hello:${DOCKER_TAG}"
                sh "docker run -d -p 8080:8080 signin/hello"
                }
                }
            }*/
        /*stage('Run docker container'){
            agent{
                label 'doc'
            }
            steps{
                sh "docker run -d -p 8080:8080 signin/hello"
            }
        }*/
        /*stage('Pull deployment file') {
            agent {
                label 'kub'
            }
            steps {
                git branch: 'main', url: 'https://github.com/anshika109/kub.git'
            }
        }
        stage('Deploy to EKS'){
            agent{
                label 'kub'
            }
            steps{
                script{
                    sh "chmod +x changeTag.sh"
                    sh "./changeTag.sh ${DOCKER_TAG}"
                    sh "kubectl apply -f services.yaml"
                    sh "kubectl apply -f node-app.yaml"    //will run deployment file
                    sh "kubectl get pods" 
                }
                echo '**********Through Kubernetes, docker image is running as a pod & deployed to cluster**********'
            }
        }*/
    }
}
def getVersion(){
    def CommitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return CommitHash
}
