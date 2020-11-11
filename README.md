
To build the docker environment:

    docker build . -t l17 --build-arg linux_user_pwd=$SECRET_PWD

$SECRET_PWD should be a password you specified.

To run the shiny app:

    docker run -p $port:$port -v `pwd`:/home/rstudio -e PASSWORD=$SECRET_PWD -it l17 sudo -H -u rstudio /bin/bash -c "cd ~/; PORT=$port make shinyapp"
    
$port should be the port number you would like to run shiny.

After that, go to localhost:$2 to see the shiny app.

