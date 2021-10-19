pipeline{
    agent {
        label node1
    }

    stages{
        stage{
            steps{
            git credentialsId: 'JenkinsPK', url: 'git@github.com:jackflanagan/gcp-setup.git'
            }
        }
        stage{
            steps{
                ansiblePlaybook credentialsId: 'JenkinsPK', installation: 'ansible', inventory: 'ansible/inventory', playbook: 'ansible/installDocker.yaml'
            }
        }
    }
}