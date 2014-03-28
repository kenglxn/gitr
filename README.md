[![Donate](https://rawgithub.com/twolfson/gittip-badge/0.2.0/dist/gittip.png)](https://www.gittip.com/kenglxn/)


## gitr: recursive git command line tool

https://npmjs.org/package/gitr

### Demo

![Demo](https://github.com/kenglxn/gitr/raw/master/demo.gif)

### Install:

    sudo npm install -g gitr

### Usage:

gitr does not interpret any commands given to it, but simply ensures that commands are executed on any git repository under the current working directory.
Any command you can pass to git, will work with gitr. gitr also inherits stdio, so interactive commands like "git log" will work as well.

    gitr status
    gitr pull
    gitr log --since '1 week ago' --oneline --pretty=format:'%s'

### Building:

    git clone git://github.com/kenglxn/gitr.git
    cd gitr
    npm test

### License:

http://www.apache.org/licenses/LICENSE-2.0.html
