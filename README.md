CLeetus command line tools

```
git clone https://github.com/kenglxn/CLeetus.git
cd CLeetus
sudo npm install -g

#example usage
cleetus help
cleetus ls
cleetus do status
cleetus do "log --since '1 day ago' --oneline --pretty=format:'%s'"
```


create a CLeetus alias for convenience:
```
alias gitr="cleetus do"

#example usage
gitr status
gitr pull
gitr "log --since '1 day ago' --oneline --pretty=format:'%s'"
```
