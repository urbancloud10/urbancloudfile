You can have a quick view of all comands availables executing `make help`

### Relevant commands

`make deploy` Builds, deploys and verifies the application on minikube. It execute a while loop until local.ecosia.org/tree reponse with 200 HTTP code.
`make run` Runs aplication on docker. You can make request on localhost/tree
`make test` Runs unit test file.
