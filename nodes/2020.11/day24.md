# jenkins pipeline 
## 标准格式
```bash
#!groovy
pipeline {
    agent any
   
    environment { 
        customWorkSpace = "${JENKINS_HOME}/workspace"
    }
    // 初始化 
    parameters {
        string(name: 'Version', defaultValue: "0", description: '当前构建的版本号: $(date +\'%Y%m%d%H\')}.#${BUILD_ID}(例: 20200701.#12)')

        choice (
            description: 'Deploy: 发布 \nRollback: 回滚',
            name: 'Status',
            choices: ['Deploy', 'Rollback']
        )

    }

    tools {
        maven 'apache-maven-3.5.0' 
        jdk 'jdk1.8.0_251'
    }
    
    stages {
        stage ("init"){
            steps {
                echo "初始化"
            }
        }

        stage ("build"){
            steps {
                echo "构建"
            }
        }

        stage ("test"){
            steps {
                echo "测试"
            }
        }

        stage ("deploy"){
            steps {
                echo "发布"
            }
        }
        
    }
    post {
        aborted{
            script{
                sh '构建取消时执行'
            }
        }
    }
}

```