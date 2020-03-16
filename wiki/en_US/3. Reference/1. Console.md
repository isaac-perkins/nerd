# Nerd Console ops 

## console/nerd

$ ./nerd {action} [ -j  #job id]

### Actions:
install, upgrade, model, crawl, tag, result, locate, job

###EG:

./nerd install		Install database
./nerd model -j 1	Build model for job 1 
./nerd job -j 2		Run job - crawl, tag + result	

## console/nerd.jar 

### Generate sentences for training
$ java nerd.jar {/path/to/nerd/directory} -tokens {file/path} 

### Create Model
$ java nerd.jar {/path/to/nerd/directory} -training {job id}

### Tag
$ java nerd.jar {/path/to/nerd/directory} -content {job id}
