
To build the docker environment:

    docker build . -t p2 --build-arg linux_user_pwd=$SECRET_PWD

$SECRET_PWD should be a password you specified.

To run the shiny app:

    docker run -p $2:$2 -v `pwd`:/home/rstudio -e PASSWORD=$SECRET_PWD -it l17 sudo -H -u rstudio /bin/bash -c "cd ~/; PORT=$2 make shinyapp"
    
$2 should be the port number you like to run shiny

