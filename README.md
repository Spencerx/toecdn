=========
 toecdn
========

The Open Edge Content Delivery Network


For more information about what TOECDN is visit http://www.toecdn.org. 
Read the book to understand of how TOECDN is working!


================
 Databases - db
================

Under this directory is the scripts which will generate the TOECDN information needed to know
which Internet Service Provider that had implemented the concept of TOECDN.


=====
 dns
=====

Under the directory "net" you will find the same backend as used on toecdn.net.
You'll need to have run the scripts in DB before running make-Files-To-Load.sh.

If you put pdns_server and libluabackend.so in the dns directory, you can
run ./pdns and run test queries as:

$dig any static.yoursite.example.toecdn.example @127.0.0.1 -p5300

;; ANSWER SECTION:
static.yoursite.example.toecdn.example. 86400 IN CNAME ZYX.static.yoursite.example.

and

$ dig any static.yoursite.example.toecdn.example @::1 -p5300

;; ANSWER SECTION:
static.yoursite.example.toecdn.example. 86400 IN CNAME static.yoursite.example.tc.isp.example.
