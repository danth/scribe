{ fetchurl, linkFarmFromDrvs }:
let version = "c9c15109b9dac40871c063892227d45b85cb3952";
in linkFarmFromDrvs "opt-2.7b" [
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-2.7b/resolve/${version}/merges.txt";
    sha256 = "HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-2.7b/resolve/${version}/config.json";
    sha256 = "eOKK3LRR4myji0qAilMxjcEscRom0vBBWFhmct4PFII=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-2.7b/resolve/${version}/pytorch_model.bin";
    sha256 = "R2ORViubJjXGctFb1pz6iBxcgk6+ibAP7mxYlHVB5uQ=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-2.7b/resolve/${version}/tokenizer_config.json";
    sha256 = "0eQYW0OgoGQhq3IY1cGndTUL0TAkUHs0++0l3PbBTGs=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-2.7b/resolve/${version}/vocab.json";
    sha256 = "BrTUbI51LUECE9lUjrJ6VNtw/aAxm2Jx+41Z3q1eHKs=";
  })
]
