WikiNets
========

This is the code for WikiNets. Feel free to contribute. It's available under a GNU GPL v3 license, the text of which is bundled, but in short: you're free to take this code and modify it as you wish, on the condition that you declare any changes you make, and pass on this freedom and responsibility in any release of your altered code. Also you should generally be nice.

**Links**

+ [Home Page](http://wikinets.co.uk)
+ [Stable Version](http://wikinets-demo.herokuapp.com)
+ [Edge](http://wikinets-edge.herokuapp.com)

Setup
-----

WikiNets can be set to work with a local WikiNet on your machine or with a WikiNet in the cloud.

###Cloud DB Option

By default it is set-up to work with one free sandbox WikiNet that everyone shares.

To run:

  ```
  git clone https://github.com/willzeng/WikiNets
  cd wikinets
  npm install
  sh server.sh
  ```    
Then go to `localhost:3000` in your browser.

###Local DB Option

To Run on a local WikiNet, you will need to install a copy of Neo4j (version 2.0.0-RC1 or higher):

Install neo4j [here](http://www.neo4j.org/download). Then follow these commands:

    # start root shell
    sudo -s
    # Import our signing key
    wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - 
    # Create an Apt sources.list file
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
    # Find out about the files in our repository
    apt-get update
    # Install Neo4j, community edition
    apt-get install neo4j
    # start neo4j server, available at http://localhost:7474 of the target machine
    neo4j start

Change one line in web.js:

    var url = 'http://localhost:7474';

Then run the following in your terminal:

    sh server.sh

Then go to `localhost:3000` in your browser.

Development
-----------
###Roadmap for Code


###Tips

For sublime 3 text highlighting for CoffeeScript: https://github.com/aponxi/sublime-better-coffeescript
  

