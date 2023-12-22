pipeline {
	agent {
		kubernetes {
    	label 'docker-builder'
    	defaultContainer 'jnlp'
    	yaml """
kind: Pod
spec:
  serviceAccountName: jenkins-agent-account
  containers:
  - name: jnlp
    workingDir: /tmp/jenkins
  - name: dind
    workingDir: /tmp/jenkins
    image: portainer/kube-tools
    imagePullPolicy: Always
    restartPolicy: Never
    command: 
    - /bin/cat
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    - name: jenkins-docker-cfg
      mountPath: /root/.docker
    securityContext:
      privileged: true
  volumes:
  - name: docker-sock
    hostPath:
      path: "/var/run/docker.sock"
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: swagregcred
          items:
            - key: .dockerconfigjson
              path: config.json 
"""
		}
	}

		
	parameters{
		credentials(credentialType: 'com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl', 
			defaultValue: '', description: 'GitHub credentials ', name: 'GITHUB_CREDENTIALS', required: true)
		credentials(credentialType: 'org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl', 
			defaultValue: '', description: 'WPM Securiy Token', name: 'WPM_CREDENTIALS', required: true)
		booleanParam(name: 'PUSHTOREGISTRY', defaultValue: true, description: 'If the image should be pushed to registry')
		string(name: 'REGISTRY', defaultValue: 'registry.localhost', description: 'Endpoint of the docker registry')
		string(name: 'HOST', defaultValue: 'edge.localhost', description: 'Base hostname of your cloud machine for the ingress')
        string(name: 'EDGE_VERSION', defaultValue: '10.16.5', description: 'Base version for the build')
	}

	environment {
		PACKAGE = "*"
		NAMESPACE = "edge-deployment"
		REGISTRY_INGRESS = "https://${params.REGISTRY}"
		CONTAINER = "demo-edge-runtime"
		CONTAINER_TAG = "1.0.${env.BUILD_NUMBER}"
		EDGE_VERSION = "${params.EDGE_VERSION}"
		GITHUB_CREDS = credentials('GITHUB_CREDENTIALS')
		WPM_CRED = credentials('WPM_CREDENTIALS')
		IMAGENAMEREGISTRY = "${params.REGISTRY}/${env.CONTAINER}:${env.CONTAINER_TAG}"
		IMAGENAMELOCAL = "${env.CONTAINER}:${env.CONTAINER_TAG}"
    }

    stages {

		stage('Read-JSON') {
			steps {
				script {
					def oldJson = '''{
					"branch":{
						"type-0.2":{"version":"0.2","rc":"1","rel":"1","extras":"1"},
						"type-0.3":{"version":"0.3","rc":"1","rel":"1","extras":"1"}
						}
					}'''
					//def props = readJSON text: oldJson
					def props = readJSON file: './Deployment.json'
					def keyList = props['engines'].keySet()
					echo "${keyList}"
					//println(props['branch'].keySet())

				}
			}
		}
    }
}
