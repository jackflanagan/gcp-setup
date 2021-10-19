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
    }
}