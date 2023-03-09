pipeline {
 
    agent {
        node {
            label 'macserver01'
        }
    }

    options {
        buildDiscarder(logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '5', daysToKeepStr: '150', numToKeepStr: '5'))
        disableConcurrentBuilds()
        timeout(time: 15, unit: 'MINUTES')
    }

    triggers {
        cron ('H 2 * * *')
    }
 
    // Required for keytool
    tools {
        jdk 'JDK 8.0'
    }
 
 
    environment {
        DEVELOPMENT_CERTIFICATE="development_certificate.p12"
        PROVISIONING_PROFILE_CONTENTS="pp_contents.plist"
        PROVISIONING_PROFILE_UUID=""
        MY_KEYCHAIN="ingenico-objectivec-sdk.temp.keychain"
        MY_KEYCHAIN_PASSWORD="<random string>" // No need to have this be a very secret string, as the keychain will only live during build
        GCC_TREAT_WARNINGS_AS_ERRORS="NO" // AFNetworking Workaround
        LANG="en_US.UTF-8"      // Fixes issue with xcpretty
        LANGUAGE="en_US.UTF-8"  // Fixes issue with xcpretty
        LC_ALL="en_US.UTF-8"    // Fixes issue with xcpretty
    }
 
 
    stages {
         
        stage('checkout') {
            steps {
                checkout scm
            }
        }

         
        stage('Prepare certificate and provisioning profile') {
            steps {
                withCredentials([
                        certificate(aliasVariable: '', credentialsId: 'ios-generic-isaac-dev-certificate', keystoreVariable: 'DEVELOPMENT_KEYSTORE', passwordVariable: 'DEVELOPMENT_PASSWORD'),
                ]) {
                    sh '''
                        # Export the certificate in Jenkins to a p12 file that can be read by Keychain
                        keytool -importkeystore -srckeystore "$DEVELOPMENT_KEYSTORE" -destkeystore "$DEVELOPMENT_CERTIFICATE" -srcstoretype JKS -deststoretype PKCS12 -srcstorepass "$DEVELOPMENT_PASSWORD" -deststorepass "$DEVELOPMENT_PASSWORD"
 
                        # Create temp keychain
                        security create-keychain -p "$MY_KEYCHAIN_PASSWORD" "$MY_KEYCHAIN"
                        # Append temp keychain to the user domain
                        security list-keychains -d user -s "$MY_KEYCHAIN" $(security list-keychains -d user | sed s/\\\"//g)
                        # Remove relock timeout
                        security set-keychain-settings "$MY_KEYCHAIN"
                        # Unlock keychain
                        security unlock-keychain -p "$MY_KEYCHAIN_PASSWORD" "$MY_KEYCHAIN"
                        # Add development certificate to keychain
                        security import $DEVELOPMENT_CERTIFICATE -k "$MY_KEYCHAIN" -P "$DEVELOPMENT_PASSWORD" -A
                        # Programmatically derive the identity
                        CERT_IDENTITY=\$(security find-identity -v -p codesigning "$MY_KEYCHAIN" | head -1 | grep '"' | sed -e 's/[^"]*"//' -e 's/".*//')
                        # Enable codesigning from a non user interactive shell
                        security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$MY_KEYCHAIN_PASSWORD" -D "$CERT_IDENTITY" -t private "$MY_KEYCHAIN"
                    '''
                }
            }
 
            post {
                always {
                    script {
                        if (fileExists(env.DEVELOPMENT_CERTIFICATE)) {
                            sh 'rm -f "$DEVELOPMENT_CERTIFICATE"'
                        }
 
                        if (fileExists(env.PROVISIONING_PROFILE_CONTENTS)) {
                            sh 'rm -f "$PROVISIONING_PROFILE_CONTENTS"'
                        }
                    }
                }
            }
        }
 
 
        // Build/Test/Release etc. stages go here
        stage('Test app & publish test results') {
            steps {
                // Remove old reports first
                sh '''xcodebuild -project IngenicoConnectSDK.xcodeproj \
                    -sdk iphonesimulator \
                    -destination "platform=iOS simulator,name=iPhone 13,OS=15.5" \
                    -scheme IngenicoConnectSDK \
                    DEVELOPMENT_TEAM=S453L3NXGS \
                    OTHER_CODE_SIGN_FLAGS="--keychain $MY_KEYCHAIN" \
                    clean test | xcpretty -r junit || true
                '''
                junit testResults: 'build/reports/*.xml', allowEmptyResults: false, testDataPublishers: [[$class: 'AttachmentPublisher']]
            }
        }
    }
 
 
    // Send email when pipepline has failed & cleanup temporary keychain
    post {
        failure {
            emailext (
                subject: "${currentBuild.currentResult}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: '${JELLY_SCRIPT, template="html"}',
		to: 'leon.stemerdink@iodigital.com, esmee.kluijtmans@iodigital.com',
                recipientProviders: [developers(), culprits(), requestor()]
            )
        }
        
        always {
            sh '''
                # Delete temporary keychain (Command fails if the keychain was never created; not a problem)
                security delete-keychain "$MY_KEYCHAIN"
            '''
        }
    }
}

