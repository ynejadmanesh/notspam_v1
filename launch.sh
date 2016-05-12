#!usrbinenv bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

update() {
  git pull
  git submodule update --init --recursive
  install_rocks
}

# Will install luarocks on THIS_DIR.luarocks
install_luarocks() {
  git clone httpsgithub.comkeplerprojectluarocks.git
  cd luarocks
  git checkout tagsv2.2.1 # Current stable

  PREFIX=$THIS_DIR.luarocks

  .configure --prefix=$PREFIX --sysconfdir=$PREFIXluarocks --force-config

  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  make build && make install
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.;exit $RET;
  fi

  cd ..
  rm -rf luarocks
}

install_rocks() {
  ..luarocksbinluarocks install luasocket
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install oauth
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install redis-lua
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install lua-cjson
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install fakeredis
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install xml
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install feedparser
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi

  ..luarocksbinluarocks install serpent
  RET=$; if [ $RET -ne 0 ];
    then echo Error. Exiting.; exit $RET;
  fi
}

install() {
  git pull
  git submodule update --init --recursive
  patch -i patchesdisable-python-and-libjansson.patch -p 0 --batch --forward
  RET=$;

  cd tg
  if [ $RET -ne 0 ]; then
    autoconf -i
  fi
  .configure && make

  RET=$; if [ $RET -ne 0 ]; then
    echo Error. Exiting.; exit $RET;
  fi
  cd ..
  install_luarocks
  install_rocks
}

if [ $1 = install ]; then
  install
elif [ $1 = update ]; then
  update
else
  if [ ! -f .tgtelegram.h ]; then
    echo tg not found
    echo Run $0 install
    exit 1
  fi

  if [ ! -f .tgbintelegram-cli ]; then
    echo tg binary not found
    echo Run $0 install
    exit 1
  fi

  .tgbintelegram-cli -k .tgtg-server.pub -s .botnod32bot.lua -l 1 -E $@
fi
