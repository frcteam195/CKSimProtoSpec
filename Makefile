CC = g++

PROTO_FILES = $(shell find . -type f -regex ".*\.proto")

PROTO_BASE_FILES = $(shell for f in ${PROTO_FILES}; do basename $$f; done)

SOURCES = $(addprefix generated/,$(PROTO_FILES:.proto=.pb.cc))
OBJECTS = $(addprefix obj/,$(PROTO_BASE_FILES:.proto=.pb.o))

space := $(subst ,, )

VPATH = $(shell dirname ${SOURCES} | tr '\n' ':')
INCLUDE = $(subst ${space}, -I,$(shell dirname ${SOURCES}))\
		  -I../protobuf/src

TARGET = libfrcinterface.a

all: generation

target: $(TARGET)

clean:
	@echo "Cleaning all interface files"
	@rm -rf generated
	@rm -rf obj
	@rm -rf lib

obj/%.o: %.cc
	$(CC) -c -I${INCLUDE} -o $@ $<

generation:
	@mkdir -p lib
	@mkdir -p generated
	@mkdir -p obj
	@for f in ${PROTO_FILES}; do ../protobuf/cmake/build/protoc $$f --cpp_out=generated; echo "Generating $$f"; done
	@make --no-print-directory target

$(TARGET): $(OBJECTS)
	ar -crs lib/$@ $^
