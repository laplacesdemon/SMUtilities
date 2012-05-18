SMUtilities
===========

# Important: The project is moved to following repository

https://github.com/laplacesdemon/SM-iOS-Library

The reason to move is rather than having a framework and lots of headaches, convertion to a static library and link it against to project as a dependency.
Since this is a major change, I wanted to start over with a different name.

Overview
--------

SMUtilities is a static IOS Framework which is a collection or ufeful utilities. Following are the features of the framework

Features
--------

* Asynchronous image view
* Convenient C functions for displaying iOS alerts
* NSConnection wrapper (with caching support)
* UIActivityIndicator wrapper, for creating "Loading" messages easily.
* Keychain wrapper for storing sensitive data in the keychain
* Persistency Manager: convenient messages for using Core Data
* PullToRefresh table view controller (Created by Leah Culver)
* RestClient for managing RESTFul API connections
* Socket Connector, for easiuly open a socket connection

How to install
--------------

Add the "SMUtilities.framework" file as a static library. In configuration page, go to "Build Phases" and add the library in "Link Binary With Libraries" section as usual.
