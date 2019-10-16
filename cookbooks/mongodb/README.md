# mongodb

Purpose:
This cookbook only contains a recipe to install mongodb on CentOS. 
It performs the following steps:
1: creates a yum repo named mongodb.repo.  The properties that make
   up this repo are declared in the attributes folder; thus, making
   this cookbook data-driven
2: The mongodb package is installed
3: The mongod service is enabled and started

Not included - for reference only
For upgrading mongodb, certain procedures need to be followed based on 
the version of mongodb presently installed.  Included would be
performing a proper backup.

To Run & Verify:
-This cookbook can be tested with Test Kitchen.  Using Test Kitchen, a Centos7 instance will be used
-Steps:
 1: Run 'kitchen verify' - this will perform TK steps create, converge and verify where verify results in 7 passed test
 2: Run 'kitchen login' - once logged into the instance, enter the following command to login to the MongoDB: mongo