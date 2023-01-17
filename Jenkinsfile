pipeline{
    
    environment {
        def ARTID = 'LoginWebApp'
        def ARTTYPE = 'war'
        def ARTGRPID = 'com.ltidevops'
        def ARTURL = '13.234.37.215:8081'  //change ip
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
        stage('Sonar Analysis') {
            steps{
                withSonarQubeEnv('sonarqube-8.9.2'){
                   sh "mvn sonar:sonar"
                }
            }
        }
        stage("Upload Artifactory to Nexus"){
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
        }
        stage('Ansible Tomcat Deployment') {
            steps {
                ansiblePlaybook credentialsId: 'tomanscred',  
                disableHostKeyChecking: true, 
                installation: 'ansible', 
                inventory: 'hosts', 
                playbook: 'pb3.yaml'
            }
        }    
        stage('Artifactory Pull on docker') {
            agent{
                label 'doc'  // for label, jave should be installed on slave system
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus3', passwordVariable: 'nexpwd', usernameVariable: 'nexurl')]) {
                sh 'wget --user=$nexurl --password=$nexpwd "http://$ARTURL/repository/$ARTREPO/com/ltidevops/LoginWebApp/1/LoginWebApp-$ARTVER.$ARTTYPE"'
            }
            }
        }
        stage('Docker Image Build & Tag'){
            agent{
                label 'doc'
            }
            steps{
                sh 'docker build -t newimg4:$DOCKER_TAG .'
               // sh 'docker images'
                //sh 'docker tag newimg3 signin/loginapp:latest' // newimg3=imgName
            }
        }
        stage('Publish Docker image to hub'){
            agent{
                label 'doc'
            }
            steps{
                withDockerRegistry(credentialsId: 'docker', url:'') {
                    sh 'docker push signin/loginapp:$DOCKER_TAG'  // loginapp=repoName
                }
            }
        }
        stage('Run docker container'){
            agent{
                label 'doc'
            }
            steps{
                sh "docker run -itd --name newlogcon -p 8090:8080 newimg2"
                sh 'docker ps'
            }
        }
        stage('Pull deployment file') {
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
                    sh "./changeTag.sh latest"
                    sh "kubectl apply -f services.yaml"
                    sh "kubectl apply -f node-app.yaml"    //will run deployment file
                    sh "kubectl get pods" 
                }
                echo '**********Through Kubernetes, docker image is running as a pod & deployed to cluster**********'
            }
        }
    }
}
def getVersion(){
    def CommitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return CommitHash
}
