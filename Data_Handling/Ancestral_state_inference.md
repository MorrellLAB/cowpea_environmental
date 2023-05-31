# Identifying ancestral state in cowpea data

* Andrew Farmer suggests the following as outgroup species: _Vigna vexillata_ as outgroup 1, _V. marina_ as outgroup 2 and _V. trilobata_ for outgroup 3
* Samples are chosen based on this [phylogeny][1].
* Download the genomes from the [Vigna Genome Server][2].

## Pulling a genome from the website.
```bash
mkdir /scratch.global/pmorrell/Vigna
wget https://viggs.dna.affrc.go.jp/download/Vvexillata_v1/Vvexillata_v1.genome.softmasked.fasta.gz
``` 

## Alignment of query to target
* Start with a minimap2 [script][3]
* We are mapping a "long assembly to a reference" and between species, so start with `asm10` or `asm20`
* In general, a longer alignment is preferred, so use the option that aligns more of the query to target!
* Consider using the following minimap2 options `./minimap2 -cx asm10 target.mmi query.fasta`
* The line above means `-c` produce CIGAR and `-x`use preset. Also `asm10` is minimal mismatch between species.
* See specifics in the minimap2 [manual][4]



[1]: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0147568 
[2]: https://viggs.dna.affrc.go.jp/download
[3]: https://github.com/pmorrell/Utilities/blob/master/minimap2.sh
[4]: https://lh3.github.io/minimap2/minimap2.html_