#!/bin/bash


home=/home/mg615512/projects/def-booker/mg615512
testdir=${home}/bin/minigraph/test
export PATH="${home}/bin/minigraph:$PATH"
exedir=${home}/scripts/executables

${exedir}/generate_graph.sh -t 1 -r ${testdir}/MT-human.fa -q ${testdir}/MT-chimp.fa -x ${testdir}/MT-orangA.fa -o ${testdir}/MT-test

