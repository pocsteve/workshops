# centos7

This cookbook is currently a WIP (to be expanded with additional security and standard configurations) that is being used to demo the Detect and Correct Pattern.  The 'Detect' part is handled by the Inspec profile 'my-centos' which has been uploaded to a demo A2 server.  

Detect and Correct Steps:
1: Create a new Scan Job in A2 using the my-centos profile on a bootstrapped node to identify what is not in compliance
2: Run Chef-Client on the bootstrapped node with this cookbook in it's runlist
3: Create another Scan Job in A2 to verify the previously identified non-compliance items have been corrected

