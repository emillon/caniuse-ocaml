FROM ocaml/opam:alpine
RUN mkdir src
COPY caniuse.opam src
WORKDIR src
RUN opam pin add -y caniuse .
