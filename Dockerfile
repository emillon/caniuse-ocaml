FROM ocaml/opam:alpine
RUN sudo ln -sf /usr/bin/opam-2.2 /usr/bin/opam
RUN mkdir src
COPY caniuse.opam src
WORKDIR src
RUN opam pin add -yn caniuse .
RUN opam install -y caniuse --deps-only
COPY . .
RUN opam install -y caniuse
CMD opam exec -- caniuse-server
