Liability Proof
===============

[![Build Status](https://travis-ci.org/peatio/liability-proof.png?branch=master)](https://travis-ci.org/peatio/liability-proof)

If you're not familiar with *liability proof* or *the Merkle approach*, check this page: [Proving Your Bitcoin Reserves](https://iwilcox.me.uk/2014/proving-bitcoin-reserves). Basically, every mordern exchanges should prove they really hold the bitcoins/money they claim to.

### Requirements ###

* ruby 2.0.0 or higher (if you want to run 'rake test' in this gem you'll need ruby 2.1.0 or higher)
* openssl

### Install ###

    gem install liability-proof

### Usage ###

As command line tool:

    # Generate root.json and partial tree json for each account in accounts.json.
    # The generated file format conforms with the standard in progress:
    # https://github.com/olalonde/blind-liability-proof#serialized-data-formats-work-in-progress--draft
    lproof generate -f accounts.json

    # Verify specified partial tree is valid, i.e. the root node calculated from
    # from the partial tree matches the root node in root.json
    lproof verify -r root.json -f partial_trees/jan.json

    # Pretty print a partial tree or any other json file
    lproof pp -f partial_trees/jan.json

As library: check `LiabilityProof::Generator` and `LiabilityProof::Verifier` for example.

### License ###

LiabilityProof is a ruby gem released under MIT license. See [http://peatio.mit-license.org](http://peatio.mit-license.org) for more information.

### How To Contribute ###

Just create an issue or open a pull request :)

### Other implementations ###

* clojure: https://github.com/zw/PoLtree/blob/master/src/uk/me/iwilcox/poltree.clj
* node.js: http://olalonde.github.io/blind-liability-proof
* c++: https://github.com/bifubao/proof_of_reserves
* python: https://github.com/ConceptPending/proveit

