# README

Simple web payment form to send requests for **sale** and **void** transactions to the ROR API. 

## Setup

### Ubuntu set up

* Update ubuntu -> 5 minutes
```
sudo apt-get update
```

* Install required dependencies -> 3 min
```
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
```

* install [RVM](https://rvm.io/rvm/install) -> 10 minutes

* [Ruby](http://ruby-doc.org/)
* [Rails](http://guides.rubyonrails.org/)
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.2.2
rvm use 2.2.2 --default
ruby -v

gem install bundler
```

* Configure Git -> 2 min **optional**
```
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"

cat ~/.ssh/id_rsa.pub

ssh -T git@github.com
```

* Install nodeJS -> 2 min
```
sudo apt-get install nodejs
```

* Clone the repository and issue the following commands:
```
$ bundle install
$ rails s
```
