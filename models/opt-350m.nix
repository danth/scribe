{ fetchurl, linkFarmFromDrvs }:
let version = "10517ad5b51c8c6e02db7824d8494721d4874488";
in linkFarmFromDrvs "opt-350m" [
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-350m/resolve/${version}/merges.txt";
    sha256 = "HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-350m/resolve/${version}/config.json";
    sha256 = "Psdd8OFmR240LPlSJrp3XYFVRJp7HkMHKLPKJrQl5Ks=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-350m/resolve/${version}/pytorch_model.bin";
    sha256 = "pSI65vPCbG2QAD+WprzZpKqu8NNvymRpES7+65hfKEI=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-350m/resolve/${version}/tokenizer_config.json";
    sha256 = "0eQYW0OgoGQhq3IY1cGndTUL0TAkUHs0++0l3PbBTGs=";
  })
  (fetchurl {
    url = "https://huggingface.co/facebook/opt-350m/resolve/${version}/vocab.json";
    sha256 = "BrTUbI51LUECE9lUjrJ6VNtw/aAxm2Jx+41Z3q1eHKs=";
  })
]
