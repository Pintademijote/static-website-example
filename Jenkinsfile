pipeline{ agent { label "miniprojet" } stages { stage("build"){ steps { sh """ docker build -t static-website-example . """
            }
        }
        stage("run"){ steps{ sh """ docker run -rm static-website-example """
            }
        }
    }
}
