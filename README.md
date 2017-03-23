## gitr: recursive git command line tool

https://npmjs.org/package/gitr

### Demo

![Demo](https://github.com/kenglxn/gitr/raw/master/demo.gif)

### Install:

    npm install -g gitr

### Usage:

gitr does not interpret any commands given to it, but simply ensures that commands are executed on any git repository under the current working directory.
Any command you can pass to git, will work with gitr. gitr also inherits stdio, so interactive commands like "git log" will work as well. 

    gitr status
    gitr pull
    gitr log --since '1 week ago' --oneline --pretty=format:'%s'

git log becomes interactive if the buffer is above one page. In the demo gif above you can see two git log commands passed through gitr. The first with is for one day, which is under one page per repo, and logs directly without interaction. The second is for one year, which goes into interactive mode.

### Building:

    git clone git://github.com/kenglxn/gitr.git
    cd gitr
    npm test

### License:

http://www.apache.org/licenses/LICENSE-2.0.html
