ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

CFLAGS += -g -O3 -ansi -pedantic -Wall -Wextra -Wno-unused-parameter
CFLAGS += -I"$(ERLANG_PATH)"
CFLAGS += -Ic_src
CFLAGS += -L/usr/local/lib/ -L/usr/lib/
CFLAGS += -lfdb_c
CFLAGS += -std=gnu99

LIB_NAME = priv/fdb_nif.so

ifneq ($(OS),Windows_NT)
       ifeq ($(shell uname),Linux)
          CFLAGS += -lm -lpthread -lrt
       endif

	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

all: $(LIB_NAME)

$(LIB_NAME): c_src/fdb_nif.c c_src/portable_endian.h
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ c_src/fdb_nif.c

clean:
	rm  -f $(LIB_NAME)

update-options:
	curl https://github.com/apple/foundationdb/blob/release-5.2/fdbclient/vexillographer/fdb.options > priv/fdb.options
