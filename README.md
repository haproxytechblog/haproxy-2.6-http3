# HAProxy 2.6 using HTTP/3 over QUIC

To run it:

1. Install VirtualBox
2. Install Vagrant
3. Call `vagrant up` from this directory:

  ```
  $ vagrant up
  ```

  This will compile OpenSSL and HAProxy and run them in the virtual machine.

4. Add to your /etc/hosts file:

  ```
  192.168.56.20  foo.com
  ```
  
5. Import the minica.crt certificate into your browser (in Firefox: Settings > Certificates > View Certificates > Import) so that
   the provided SSL certificate is trusted.

5. Visit http://foo.com to see the site. The first time you access the site, it 
   will return HTTP/2. Refresh the page and it will be HTTP/3.
