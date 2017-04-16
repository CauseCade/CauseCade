# CauseCade - Bayesian Networks

This repository will contain my best efforts to both learn about the interesting world of bayesian networks and implement them in an accessible manner. I am currently implementing this using Dart and an adaption of D3 for the graphical representation (using https://github.com/rwl/d3.dart package). These choices are subject to change.

## Purpose ##

In the end, I hope this project will result in a page that can teach others about bayesian networks and allow for some basic use cases (on the go). While there are currently great programs that can be used to locally compute solutions and solve problems using bayesian networks, I feel there is still room for an easy to use, educational tool focussing on them.

## Update April 2017  ##

Current work is being done on saving and loading of networks. An online version of the network is now available at https://sandcrawler.github.io/CauseCade-deploy/. When I manage to find some free time again, I will start work on the educational/explanatory part of CauseCade.  

## todo List for this Project ##

* Develop an intuitive UI
    * Allow Saving of Network
    * Allow Network to be opened (from file explorer) (already functional from Json)
    * Find a way to make the reset button clear the SVG
* Optimise Bayesian Network 
   * Move away from doubles
   * Avoid pointless computations
   * Auto-redraw the network for improved performance
* Allow for Self Learning from datasets (optional)
* Visually represent the data in the algorithm
   * Current network visualisation is a little hard to control - may move to entirely different directed graph library
* Create a sort of 'teaching' mode, that will explain the functioning of the network
   * Have Learning and Quick Use mode
   * Teach Bayesian Networks in Chapters
   * Create Exercises
   * Write out separate documents (as backup)
* Create Help screen
* Develop Alternative Canvas Views
