# rails-asset-provider
Serve rails static files(/assets/*) through NGINX for way better performance

# Set up instructions
1. Search and replace the whole project by $YOUR_DOMAIN and substitute by the domain with which you wish to serve the application, as in _yourdomain.com_
1. Search and replace the whole project by $YOUR_APPLICATION_SERVER_ADDRESS and substitute with an address that points to your application
1. If you, like me, choose to deploy on Google Cloud Platform using kubernetes, search and replace the whole project by $GCP_PROJECT and substitute with your Google Cloud project name
1. Deploy the NGINX server
1. Upload your assets\(or [automate this task](google.com)\)
1. Point the DNS of _yourdomain.com_ to the NGINX instance

# How to automate the asset upload
The project Dockerfile sets up a git server through SSH that has a hook to precompile the assets upon receiving pushes.

This means all you need to do to "refresh" the assets that are cached on NGINX is a ```git push``` to the IP of the NGINX instance.

After deploying the docker image, you will need to add your public SSH key(which might be in ~/.ssh/id_rsa.pub) to the list of authorized ssh clients. Just substitute $PUBLIC_SSH_KEY by your local public SSH key and run on the server:

``` bash
echo $PUBLIC_SSH_KEY > ~/.ssh/authorized_keys
```
