@Library('utils') _

pipeline{
    agent {
        label "node1"
    }

    stages{
        stage("Git Checkout"){
            steps{
            git credentialsId: 'JenkinsPK', url: 'git@github.com:jackflanagan/gcp-setup.git', branch: 'dev'
            }
        }
        stage("Run Install Docker playbook"){
            steps{
                ansiblePlaybook credentialsId: 'JenkinsPK', installation: 'ansible', inventory: 'ansible/inventory', playbook: 'ansible/installDocker.yaml'
            }
        }
        stage("Run Install KubeTools playbook"){
            steps{
                ansiblePlaybook credentialsId: 'JenkinsPK', installation: 'ansible', inventory: 'ansible/inventory', playbook: 'ansible/installKubeTools.yaml'
            }
        }
        stage("Run Init KubeController playbook"){
            steps{
                ansiblePlaybook credentialsId: 'JenkinsPK', installation: 'ansible', inventory: 'ansible/inventory', playbook: 'ansible/initKubeController.yaml'
            }
        }
        withCredentials([sshUserPrivateKey(credentialsId: "JenkinsPK", keyFileVariable: 'keyfile')])
        stage("Checking infrastructure"){
            steps{
                sh "scp -i ${keyfile} jack@controller/home/jack/.kube/config /home/jack/.kube/config" 
                KubectlChecks.CheckNodes()
            }
        }
    }
}