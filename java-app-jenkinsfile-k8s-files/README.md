
Jenkins Guide

Table of Contents
Create Jenkins Server	1
Installing Git on Ubuntu	1
Create Access Token for Git clone	2
Install Jenkins on Ubuntu	3
Install JAVA dependency then only installs Jenkins	5
Key Difference mvn clean Package and clean install	8
Example Use Case:	8
Docker Installation	14
Solution 1: Add Jenkins User to the Docker Group	17
Install Azure CLI	20
Jenkins Theory and Interview questions	24
1. Jenkins Basics	24
Detailed Installation of Jenkins on Ubuntu Linux VM	24
Step 1: Install Java (JDK)	24
Step 2: Add Jenkins Repository to Ubuntu	25
Step 3: Install Jenkins	26
Step 4: Open Jenkins in a Web Browser	26
Step 5: Enable Jenkins to Start on Boot	27
Step 6: Configure Firewall (Optional)	27
Jenkins is now installed and accessible!	27
Jenkins Interview Questions	27
2. Declarative vs. Scripted Pipelines	30
•	1. Syntax & Structure	30
•	2. Flexibility & Control	31
•	3. Use Cases	31
3. Key Pipeline Components	31
Webhooks, Poll SCM, and Cron Schedules in Jenkins	33
1. Webhooks: GitHub/GitLab Triggers on Push/PR	34
2. Poll SCM: Check Repository Periodically	35
3. Cron Schedules: Time-Based Triggers	37
Summary of Triggers:	38
4. Advanced Pipeline Features	39
5. Interview Topics	40
6. Sample CI/CD Pipeline (Declarative)	40
7. Practice Projects	41
8. Resources	41



Create Jenkins Server
 

Installing Git on Ubuntu
 apt-get install git
 









 
Create Access Token for Git clone
 

 







Install Jenkins on Ubuntu

https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

 

 

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
Adding Jenkins Repository to APT Sources List


•	sudo: This runs the command with superuser privileges (administrator access).
•	wget: A command-line utility for downloading files from the web.
•	-O /usr/share/keyrings/jenkins-keyring.asc: This option specifies the output file name (jenkins-keyring.asc). It is storing the downloaded key in /usr/share/keyrings/ directory.
•	https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key: This is the URL from where the Jenkins GPG key is being downloaded. The key is used to verify the authenticity of the Jenkins packages you'll be downloading from their repository.
The purpose of this command is to download and save the GPG key used to sign Jenkins packages so that your package manager can verify the integrity and authenticity of the packages when installing Jenkins.


sudo apt-get update

sudo apt-cache show Jenkins

sudo apt install jenkins=2.289.1


If Jenkins installation fails.

 



 




Install JAVA dependency then only installs Jenkins

 

 


 

 



Installation of git on Servers and Jenkins UI both servers differently.



pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Use the credential ID for GitHub access
                sh 'echo passed'
            }
        }
    }
}

Key Difference mvn clean Package and clean install
•	mvn clean package will build your project and create a .jar or .war file, but will not install it into the local repository.
•	mvn clean install will build the project, create the .jar or .war file, and install it into the local Maven repository.
Example Use Case:
•	mvn clean package: If you just want to build the project for deployment or testing (for example, just to create a .jar for distribution, without needing to install it into your local repository).
•	mvn clean install: If you're working on a multi-module project and you want to build the current module and make it available for other modules (or other projects on your local machine) to use as a dependency.


 


 



Download Apache Maven – Maven
 

 

 

 

 

 

Under Tool Configuration

 

 





 

 


 

Docker File
 



 

Throws error, docker not found

Docker Installation

Ubuntu | Docker Docs

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


 

stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the directory containing the Dockerfile and build the image
                    sh """
                        cd java-maven-sonar-argocd-helm-k8s/spring-boot-app
                        docker build -t ${ACR_REGISTRY}/my-spring-app:${env.BUILD_ID} .
                    """
                }
            }

Here “”” also important.

cd java-maven-sonar-argocd-helm-k8s/spring-boot-app + docker build -t jenkinsacr.azurecr.io/my-spring-app:.BUILD_ID . ERROR: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied



Solution 1: Add Jenkins User to the Docker Group
In order to grant Jenkins permission to access the Docker socket, you need to add the Jenkins user to the Docker group. This will allow Jenkins to run Docker commands without needing sudo.
sudo usermod -aG docker Jenkins
restart Jenkins service

Then
pipeline {
    agent any
    environment {
        // Define ACR registry URL (replace with your ACR name)
        ACR_REGISTRY = "jenkinsacr.azurecr.io"
        
    }
    stages {
        stage('Checkout') {
            steps {
                // Use the credential ID for GitHub access
                sh 'echo passed'
            }
        }

        stage('Build and Test') {
            steps {
                sh 'ls -ltr'
                // Build the project and create a JAR file
                sh 'cd java-maven-sonar-argocd-helm-k8s/spring-boot-app && mvn clean install'
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    // Use the Jenkins credentials securely with the 'withCredentials' block
                    withCredentials([usernamePassword(credentialsId: 'ACR_Cred', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')]) {
                        // Login to Azure Container Registry (ACR) using credentials
                        sh """
                            az acr login --name ${ACR_REGISTRY} --username ${ACR_USERNAME} --password ${ACR_PASSWORD}
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the directory containing the Dockerfile and build the image
                    sh """
                        cd java-maven-sonar-argocd-helm-k8s/spring-boot-app
                        docker build -t ${ACR_REGISTRY}/my-spring-app:${env.BUILD_ID} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to ACR
                    sh """
                        docker push ${ACR_REGISTRY}/my-spring-app:${env.BUILD_ID}
                    """
                }
            }
        }
    }
}


 





Install Azure CLI
Install the Azure CLI on Linux | Microsoft Learn

 

 



pipeline {
    agent any
    environment {
        // Define ACR registry URL (replace with your ACR name)
        ACR_REGISTRY = "jenkinsacr.azurecr.io"
        
    }
    stages {
        stage('Checkout') {
            steps {
                // Use the credential ID for GitHub access
                sh 'echo passed'
            }
        }

        stage('Build and Test') {
            steps {
                sh 'ls -ltr'
                // Build the project and create a JAR file
                sh 'cd java-maven-sonar-argocd-helm-k8s/spring-boot-app && mvn clean install'
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    // Use the Jenkins credentials securely with the 'withCredentials' block
                    withCredentials([usernamePassword(credentialsId: 'ACR_Cred', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')]) {
                        // Login to Azure Container Registry (ACR) using credentials
                        sh """
                            az acr login --name $ACR_REGISTRY --username $ACR_USERNAME --password $ACR_PASSWORD
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the directory containing the Dockerfile and build the image
                    sh """
                        cd java-maven-sonar-argocd-helm-k8s/spring-boot-app
                        docker build -t ${ACR_REGISTRY}/my-spring-app:${env.BUILD_ID} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to ACR
                    sh """
                        docker push ${ACR_REGISTRY}/my-spring-app:${env.BUILD_ID}
                    """
                }
            }
        }
    }
}


 





 

 

 


Jenkins Theory and Interview questions
                                Jenkins
Here’s a structured guide to learning Jenkins from basics to medium level, covering practical pipeline components and interview-focused topics for DevOps roles:
________________________________________
1. Jenkins Basics
Core Concepts
•	What is Jenkins?: Open-source automation server for CI/CD.
•	Purpose: Automate building, testing, and deploying code.
•	Key Terms:
o	Job/Pipeline: A sequence of automated steps.
o	Node/Agent: Machines (master/worker) that execute jobs.
o	Plugin: Extend Jenkins functionality (e.g., Git, Docker, Kubernetes).
o	Workspace: Directory where Jenkins executes jobs.
Installation & Setup
•	Install Jenkins on Linux/Windows (Java dependency).
•	Initial setup: Unlock Jenkins, install suggested plugins.
•	Configure security (users, roles, credentials).
Detailed Installation of Jenkins on Ubuntu Linux VM
Let's go through the step-by-step process of installing Jenkins on an Ubuntu Linux VM. This installation will use Jenkins' official package repository to ensure you're installing the latest version.
Pre-requisites:
1.	A Virtual Machine (VM) running Ubuntu Linux (version 20.04 or later).
2.	Java Development Kit (JDK) installed (Jenkins requires JDK 11 or later).
3.	Internet Connection to download the required packages.
Step 1: Install Java (JDK)
Before installing Jenkins, ensure that Java is installed. Jenkins requires Java 11 or later.
1.	Check if Java is already installed:
bash
CopyEdit
java -version
2.	If Java is not installed, install OpenJDK 11:
bash
CopyEdit
sudo apt update
sudo apt install openjdk-11-jdk -y
3.	Verify Java installation:
bash
CopyEdit
java -version
This should output Java version 11 or later.
________________________________________
Step 2: Add Jenkins Repository to Ubuntu
1.	Install necessary dependencies: First, install wget, curl, and other required dependencies.
bash
CopyEdit
sudo apt update
sudo apt install wget curl gnupg -y
2.	Add Jenkins’ repository and its key: Jenkins provides a package repository that you can use to easily install and update Jenkins.
o	Download the Jenkins key:
bash
CopyEdit
wget -q -O - https://pkg.jenkins.io/keys/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
o	Add the Jenkins repository:
bash
CopyEdit
sudo sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'
3.	Update your system's package list:
bash
CopyEdit
sudo apt update
________________________________________
Step 3: Install Jenkins
1.	Install Jenkins using apt: Now you can install Jenkins using the apt package manager:
bash
CopyEdit
sudo apt install jenkins -y
2.	Verify Jenkins installation: After the installation, Jenkins will start automatically as a service. You can check its status:
bash
CopyEdit
sudo systemctl status jenkins
If Jenkins is running, you'll see output indicating the service is active.
________________________________________
Step 4: Open Jenkins in a Web Browser
1.	Find the Jenkins Web UI port: By default, Jenkins runs on port 8080. You can verify that Jenkins is running by checking the port:
bash
CopyEdit
sudo netstat -tuln | grep 8080
2.	Access Jenkins: Open a web browser and go to:
cpp
CopyEdit
http://<your-VM-ip>:8080
3.	Unlock Jenkins:
o	Jenkins will ask for an unlock key the first time you access it. Find this key using the following command:
bash
CopyEdit
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
o	Copy the password from the terminal and paste it into the Jenkins unlock page.
4.	Install Suggested Plugins: After unlocking Jenkins, it will prompt you to install the default suggested plugins. Click "Install suggested plugins".
5.	Create Admin User: After the plugin installation, Jenkins will ask you to set up an admin user. Fill in the required fields and proceed.
________________________________________
Step 5: Enable Jenkins to Start on Boot
1.	Enable Jenkins to start on system boot:
bash
CopyEdit
sudo systemctl enable jenkins
2.	Start Jenkins manually (if needed):
bash
CopyEdit
sudo systemctl start jenkins
________________________________________
Step 6: Configure Firewall (Optional)
If you're running a firewall on your VM (like UFW), allow traffic on port 8080:
1.	Allow Jenkins through UFW:
bash
CopyEdit
sudo ufw allow 8080
sudo ufw reload
________________________________________
Jenkins is now installed and accessible!
1.	Open your browser again and navigate to http://<your-VM-ip>:8080.
2.	You should now be able to see the Jenkins dashboard and begin configuring Jenkins.
________________________________________
Jenkins Interview Questions
Here are some common Jenkins-related questions you might encounter during an interview for a DevOps Engineer position:
1. What is Jenkins, and why is it used?
•	Answer: Jenkins is an open-source automation server used primarily for Continuous Integration (CI) and Continuous Deployment (CD). It automates tasks related to building, testing, and deploying code, improving the overall efficiency of the software development lifecycle.
2. What are the components of Jenkins?
•	Answer: The main components of Jenkins include:
o	Master: The central node that controls the Jenkins environment.
o	Slave (Agent): Machines that execute jobs on behalf of the Jenkins master.
o	Jobs: Tasks that Jenkins executes, like building or deploying applications.
o	Plugins: Extend Jenkins capabilities by integrating with other tools.
3. What are Jenkins Jobs and Pipelines?
•	Answer:
o	Jenkins Jobs are individual tasks that Jenkins performs, such as building or testing code.
o	Pipelines are a series of automated steps that define the flow of tasks from code integration to delivery/deployment. Pipelines can be written in Groovy using a Jenkinsfile.
4. What is a Jenkinsfile?
•	Answer: A Jenkinsfile is a text file that contains the definition of a Jenkins pipeline. It defines the stages and steps in the pipeline, which Jenkins will execute. Jenkinsfiles can be stored in version control alongside the code.
5. What is the difference between a Declarative and Scripted Pipeline in Jenkins?
•	Answer:
o	Declarative Pipeline: A simplified, structured syntax to define pipelines with stages, steps, and agents. It is recommended for most use cases.
o	Scripted Pipeline: A more flexible and powerful pipeline defined using a Groovy-based DSL, allowing more complex logic but requiring more code.
6. How does Jenkins handle version control integration?
•	Answer: Jenkins integrates with version control systems (VCS) like Git, SVN, and Mercurial. You can configure Jenkins to automatically trigger jobs based on code commits, merge requests, or scheduled times.
7. What is the role of plugins in Jenkins?
•	Answer: Jenkins plugins are used to extend Jenkins’ functionality and integrate with other tools and services. For example, the Git Plugin integrates Jenkins with Git repositories, while the Docker Plugin allows Jenkins to manage Docker containers.
8. How would you set up a Jenkins pipeline to deploy a web application?
•	Answer: A typical Jenkins pipeline for deploying a web app might include stages for:
1.	Clone the repository (from GitHub/GitLab).
2.	Build the application (compile code, run tests).
3.	Package the app (JAR, WAR, etc.).
4.	Deploy to staging (via Docker, Kubernetes, or other methods).
5.	Deploy to production (manual or automatic based on approval).
9. How do you handle Jenkins security?
•	Answer: Jenkins security can be managed by:
o	Enabling authentication (e.g., using LDAP or Active Directory).
o	Configuring role-based access control (RBAC) to restrict access to specific features or jobs.
o	Managing secrets securely (e.g., using Jenkins Credentials Plugin).
10. What is a Jenkins Agent/Slave?
•	Answer: Jenkins agents (also called slaves) are machines that run builds on behalf of the Jenkins master. Agents can be physical machines, VMs, or containers. The master delegates job execution to agents for scalability.
11. How would you troubleshoot a failing Jenkins job?
•	Answer:
o	Check the console output of the job for error messages.
o	Investigate if the build environment (e.g., agents, dependencies) is set up correctly.
o	Check for issues in the configuration of build tools (e.g., Maven, Gradle).
o	Ensure that permissions are correctly set up for accessing the repository or deploy targets.

Pipeline Types
1.	Freestyle Projects: Simple GUI-based jobs (limited flexibility).
2.	Pipeline Projects (Declarative/Scripted): Code-based (Jenkinsfile).
________________________________________
2. Declarative vs. Scripted Pipelines
•	Declarative:
o	Simplified syntax (structured with pipeline, stages, steps).
o	Example:
groovy
Copy
pipeline {
  agent any
  stages {
    stage('Build') { steps { sh 'mvn clean install' } }
    stage('Test') { steps { sh 'mvn test' } }
  }
}
•	Scripted:
o	Groovy-based, flexible (uses node, stage blocks).
o	Example:
groovy
Copy
node {
  stage('Build') { sh 'mvn clean install' }
  stage('Test') { sh 'mvn test' }
}

Interview Q: Differences between declarative and scripted pipelines?
•	________________________________________
•	1. Syntax & Structure
Declarative Pipeline	Scripted Pipeline
Uses a structured, predefined syntax with keywords like pipeline, stages, steps, and post.	Uses Groovy scripting with flexible syntax (e.g., node, stage).
Example:
groovy <br> pipeline { <br> agent any <br> stages { <br> stage('Build') { steps { sh 'mvn install' } } <br> } <br> }	Example:
groovy <br> node { <br> stage('Build') { sh 'mvn install' } <br> }
•	________________________________________
•	2. Flexibility & Control
Declarative	Scripted
Designed for simplicity and readability. Follows a strict, opinionated structure.	Offers full Groovy scripting capabilities for complex logic (e.g., loops, conditionals).
Limited to Jenkins’ declarative DSL (Domain-Specific Language).	Can use arbitrary Groovy code, making it more powerful for advanced workflows.
•	________________________________________
•	3. Use Cases
Declarative	Scripted
Ideal for most CI/CD pipelines (90% of use cases).	Reserved for legacy projects or highly custom workflows requiring complex logic.
Enforces best practices and cleaner code structure.	Useful when you need fine-grained control (e.g., dynamic parallel stages).

________________________________________
3. Key Pipeline Components
Stages & Steps
•	Stages: Logical divisions (e.g., Build, Test, Deploy).
•	Steps: Individual tasks (e.g., sh, bat, git, echo).
•	•  Stage: A logical division of the pipeline representing a distinct phase, such as Build, Test, or Deploy. Stages help organize and visualize the pipeline.
•	•  Step: A single task or action performed within a stage. Examples include shell commands, testing, or invoking external tools.
6. Can a Jenkins pipeline contain parallel stages?
•	Answer: Yes, you can define parallel stages to run multiple tasks concurrently, which can speed up the overall pipeline. Here's an example of a parallel execution:
groovy
CopyEdit
pipeline {
    agent any
    stages {
        stage('Build and Test') {
            parallel {
                stage('Build') {
                    steps {
                        sh 'mvn clean install'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'mvn test'
                    }
                }
            }
        }
    }
}
7. What is the purpose of the post block in a Jenkins pipeline?
•	Answer: The post block is used to define actions that should always or conditionally run after all stages have finished, regardless of whether the pipeline succeeds or fails. For example, cleaning up resources or sending notifications.
8. What are the types of post conditions in Jenkins?
•	Answer: Jenkins provides several conditions inside the post block to handle pipeline outcomes:
o	always: Runs after the pipeline finishes, no matter what.
o	success: Runs only if the pipeline or stage succeeds.
o	failure: Runs only if the pipeline or stage fails.
o	unstable: Runs if the pipeline ends with an unstable result (e.g., failed tests).
o	changed: Runs if the state of the pipeline has changed.
Example:
groovy
CopyEdit
post {
    success {
        echo 'The build succeeded!'
    }
    failure {
        echo 'The build failed!'
    }
}
9. How do you handle errors in Jenkins pipelines?
•	Answer: Errors can be handled using the catchError step or by configuring failure conditions in the post block (e.g., failure, unstable). In declarative pipelines, you can also use the script block to include more complex error-handling logic.
Example of handling errors:
groovy
CopyEdit
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh 'mvn clean install'
                }
            }
        }
    }
}
________________________________________



Triggers
•	Webhooks: GitHub/GitLab triggers on push/PR.
•	Poll SCM: Check repository periodically.
•	Cron Schedules: Time-based triggers.

Webhooks, Poll SCM, and Cron Schedules in Jenkins
In Jenkins, there are several ways to trigger builds or pipelines based on specific events or schedules. The three common ways to trigger Jenkins jobs are:
1.	Webhooks (GitHub/GitLab Triggers on Push/PR)
2.	Poll SCM (Check Repository Periodically)
3.	Cron Schedules (Time-Based Triggers)
Let's go through each one of them with examples and possible interview questions.
________________________________________
1. Webhooks: GitHub/GitLab Triggers on Push/PR
Definition:
A webhook is a mechanism where Jenkins listens for external events (e.g., code pushed to GitHub/GitLab) and automatically triggers a job in Jenkins when such events occur. This is generally used to automatically trigger a build when there is a code push, a pull request (PR), or a merge.
Example:
•	GitHub: To set up a webhook with GitHub, you would need to configure GitHub to notify Jenkins about code changes or pull requests.
1.	Go to your GitHub repository.
2.	Navigate to Settings > Webhooks > Add webhook.
3.	In the Payload URL, enter the Jenkins webhook URL: http://<your-jenkins-url>/github-webhook/.
4.	Select the events you want to trigger Jenkins builds on, like Push or Pull Request.
5.	In Jenkins, make sure to configure the GitHub plugin in your Jenkins job configuration.
•	GitLab: Similarly, GitLab also provides webhooks to notify Jenkins when certain events occur.
1.	Go to Settings > Webhooks in your GitLab project.
2.	Set the URL to the Jenkins webhook: http://<your-jenkins-url>/project/<your-job-name>.
3.	Select events like Push or Merge Request to trigger builds.
4.	Ensure your Jenkins job is set to listen for GitLab webhooks using the GitLab Plugin.
Jenkins Pipeline Example (Webhooks):
In Jenkins, you can configure your pipeline to trigger a build when a webhook is received (from GitHub or GitLab).
groovy
CopyEdit
pipeline {
    agent any
    triggers {
        githubPush()  // Triggers on GitHub push event
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
        }
    }
}
Interview Questions on Webhooks:
1.	What is a webhook, and how is it used in Jenkins?
o	Answer: A webhook in Jenkins is used to trigger jobs automatically when an event occurs in an external system like GitHub or GitLab. It’s typically set up for code changes (push, PRs) to trigger builds, tests, or deployments in Jenkins.
2.	How would you configure Jenkins to trigger a build when there is a new commit in GitHub?
o	Answer: You would set up a GitHub webhook pointing to the Jenkins server (with the URL /github-webhook/). Then, in Jenkins, configure the job to be triggered on GitHub Push or Pull Request events.
3.	What is the GitHub plugin in Jenkins?
o	Answer: The GitHub Plugin in Jenkins allows Jenkins to interact with GitHub. It enables features like triggering builds on GitHub events (push, PR), managing GitHub webhooks, and accessing repositories for Jenkins jobs.
________________________________________
2. Poll SCM: Check Repository Periodically
Definition:
Poll SCM allows Jenkins to periodically check the source code repository (e.g., GitHub, GitLab, Bitbucket) for changes. If Jenkins detects changes in the repository (such as new commits), it will trigger a build.
Example:
In Jenkins, you can configure Poll SCM in the job configuration:
1.	Go to your Jenkins job.
2.	Click on Configure.
3.	Under Build Triggers, select Poll SCM and specify the schedule (e.g., every 5 minutes).
4.	Set the polling schedule with the cron-like syntax (similar to Linux cron).
Jenkins Pipeline Example (Poll SCM):
groovy
CopyEdit
pipeline {
    agent any
    triggers {
        pollSCM('* * * * *')  // Poll SCM every minute
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
        }
    }
}
•	The cron syntax * * * * * means polling will happen every minute. You can adjust it to your needs (e.g., H/5 * * * * to poll every 5 minutes).
Interview Questions on Poll SCM:
1.	What is Poll SCM, and when would you use it?
o	Answer: Poll SCM is a Jenkins feature that periodically checks the repository for any changes (commits) and triggers a build if any changes are detected. It's useful when you can't use webhooks but still need to automate builds based on code changes.
2.	What is the difference between using webhooks and Poll SCM for triggering builds?
o	Answer: Webhooks are event-driven and notify Jenkins immediately when an event (like a commit) occurs, while Poll SCM checks the repository at regular intervals (e.g., every 5 minutes) to see if any changes have been made. Webhooks are more immediate, while Poll SCM introduces some delay due to its periodic checks.
3.	How would you configure Poll SCM to check the repository every 5 minutes?
o	Answer: Use the cron syntax H/5 * * * * in the Poll SCM trigger. This will check the repository every 5 minutes.
________________________________________
3. Cron Schedules: Time-Based Triggers
Definition:
A Cron schedule allows Jenkins to trigger a job at a specific time or interval, similar to how cron jobs work in Linux systems. This is useful for running periodic tasks, such as nightly builds or regular maintenance tasks.
Example:
You can configure a Jenkins job to run periodically based on a cron expression. The cron expression defines the schedule for the job to run, such as every day at midnight or every Monday at 5:00 AM.
Jenkins Job Configuration (Cron Schedule):
1.	Go to your Jenkins job.
2.	Click on Configure.
3.	Under Build Triggers, select Build periodically.
4.	Enter the cron expression that defines when you want the job to run.
Jenkins Pipeline Example (Cron Schedule):
groovy
CopyEdit
pipeline {
    agent any
    triggers {
        cron('H 0 * * *')  // Run the job every day at midnight
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
        }
    }
}
•	The cron expression H 0 * * * runs the job every day at midnight.
Common Cron Syntax:
•	H 0 * * * — Run every day at midnight.
•	H 12 * * * — Run every day at 12:00 PM.
•	H 0 0 * * 1 — Run every Monday at midnight.
Interview Questions on Cron Schedules:
1.	What is a cron schedule, and how is it used in Jenkins?
o	Answer: A cron schedule in Jenkins is used to trigger jobs based on a specified time or interval. It uses cron-like syntax to define when the job should run (e.g., daily, weekly, etc.).
2.	How would you schedule a Jenkins job to run every Sunday at midnight?
o	Answer: Use the cron expression H 0 0 * * 0. This will trigger the job every Sunday at midnight.
3.	What is the difference between Poll SCM and Cron schedule?
o	Answer: Poll SCM checks the repository periodically to detect changes and trigger a build, whereas Cron schedule triggers a job based on a time schedule, regardless of whether there are changes in the repository or not.
________________________________________
Summary of Triggers:
1.	Webhooks: Automatically trigger builds when an event occurs in an external system (e.g., code push or PR in GitHub/GitLab).
2.	Poll SCM: Periodically checks the repository for changes and triggers builds when changes are detected.
3.	Cron Schedules: Triggers builds at specified times or intervals (e.g., nightly builds or scheduled reports).

Integration with Tools
•	Version Control: Git (checkout scm in Jenkinsfile).
•	Build Tools: Maven, Gradle, npm.
•	Artifact Repositories: Nexus, Artifactory.
•	Code Quality: SonarQube.
•	Containers: Docker, Kubernetes (kubectl steps).
•	Cloud: AWS CLI, Azure DevOps.
________________________________________
4. Advanced Pipeline Features
Environment Variables & Credentials
•	Variables:
groovy
Copy
environment {
  APP_VERSION = '1.0.0'
  AWS_CRED = credentials('aws-credentials')
}
•	Credentials: Store secrets in Jenkins (e.g., API keys, passwords).
Parallel Execution
•	Run stages in parallel:
groovy
Copy
stage('Tests') {
  parallel {
    stage('Unit Tests') { steps { ... } }
    stage('Integration Tests') { steps { ... } }
  }
}
Shared Libraries
•	Reusable code across pipelines:
groovy
Copy
@Library('my-shared-lib') _
Error Handling
•	post section for cleanup/notifications:
groovy
Copy
post {
  success { slackSend(message: "Build succeeded!") }
  failure { slackSend(message: "Build failed!") }
}
•	Retry failed steps:
groovy
Copy
retry(3) { sh './deploy.sh' }
________________________________________
5. Interview Topics
Common Questions
1.	How to secure Jenkins? (RBAC, HTTPS, credentials management)
2.	Explain Jenkins agent vs. master.
3.	What is a Jenkinsfile?
4.	How to handle secrets in Jenkins?
5.	How to debug a failing pipeline?
6.	How to scale Jenkins (agents, distributed builds)?
7.	Blue-Green Deployment using Jenkins.
Key Plugins
•	Git: Integrate Git repositories.
•	Pipeline: Core plugin for Jenkinsfiles.
•	Docker Pipeline: Build/push Docker images.
•	Kubernetes: Deploy to clusters.
•	Blue Ocean: Modern UI for pipelines.
•	Credentials Binding: Manage secrets.
Troubleshooting
•	Check Console Output for errors.
•	Use echo for debugging variables.
•	Validate Jenkinsfile syntax with Replay or Declarative Linter.
________________________________________
6. Sample CI/CD Pipeline (Declarative)
groovy
Copy
pipeline {
  agent any
  environment {
    DOCKER_IMAGE = 'my-app:${BUILD_NUMBER}'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm } // Clone Git repo
    }
    stage('Build') {
      steps { sh 'mvn clean package' }
    }
    stage('Unit Tests') {
      steps { sh 'mvn test' }
      post { always { junit 'target/surefire-reports/*.xml' } }
    }
    stage('Docker Build') {
      steps { script { docker.build(DOCKER_IMAGE) } }
    }
    stage('Deploy to Dev') {
      steps { sh "kubectl apply -f k8s/dev-deployment.yaml" }
    }
  }
  post {
    failure { slackSend channel: '#alerts', message: "Pipeline failed: ${BUILD_URL}" }
  }
}
________________________________________
7. Practice Projects
1.	Create a pipeline for a Java/Python app with tests.
2.	Integrate Jenkins with Docker to build and push images.
3.	Deploy to Kubernetes using Helm/kubectl.
4.	Implement a multi-branch pipeline for Git branches.
5.	Set up a Blue-Green deployment pipeline.
________________________________________
8. Resources
•	Official Docs: jenkins.io/doc
•	Books: Jenkins 2: Up and Running by Brent Laster.
•	Courses: Jenkins courses on Udemy/Pluralsight.
•	Community: Jenkins YouTube channel, Stack Overflow.
________________________________________
This guide covers foundational concepts, practical pipeline components, and interview prep. Focus on hands-on practice and understanding error handling, integrations, and security.








